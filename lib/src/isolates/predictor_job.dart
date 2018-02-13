import 'dart:async';
import 'dart:collection';

import 'package:hungry_dame/src/isolates/message_bus.dart';
import 'package:hungry_dame/src/isolates/predictor_isolate.dart';
import 'package:hungry_dame/src/services/predicted_state.dart';
import 'package:hungry_dame/src/services/state.dart';

class PredictorJob {
  static const int MAX_DEPTH = 12;
  static const int MAX_STEPS = 100000;
  static const HUNGRY_DAME = false;
  List<PredictedState> predictions = [];
  List<PredictedState> orphans = [];
  int currentDepth = 1;
  int currentStep = 0;
  ListQueue<PredictedState> stateQueue = new ListQueue<PredictedState>();
  final PredictorIsolate parent;
  static const UPDATE_PERIOD = const Duration(milliseconds: 1000);
  DateTime lastUpdateTime;
  bool _isFinished = false;

  PredictorJob(this.parent);

  bool get isKilled => _isFinished || parent.current != this;

  void predict(State currentState) {
//    print("predict(${currentState.id})");
    currentState.findPlayablePieces();
    predictions = prepareMoves(currentState);
    if (predictions.length == 0) {
      return finish();
    }
    for (PredictedState state in predictions) {
      stateQueue.add(state);
    }
    stateQueue.add(null);
    currentDepth++;

    lastUpdateTime = new DateTime.now();
    predictCycler();
  }

  void predictCycler() {
    for (int i = 0; i < 500; i++) {
      if (isKilled) return null;
      if (stateQueue.length == 0) {
        return finish();
      }
      currentStep++;
      PredictedState state = stateQueue.removeFirst();
      List<PredictedState> states = predictForStateOneLevel(state);
      if (states == null) {
        currentStep--;
        if (currentDepth >= MAX_DEPTH) {
          return finish();
        }
        currentDepth++;
        stateQueue.add(null);
      } else if (states.length == 0) {
        orphans.add(state);
      } else {
        stateQueue.addAll(states);
      }
    }
    if (new DateTime.now().difference(lastUpdateTime) > UPDATE_PERIOD) {
      sendResults();
      lastUpdateTime = new DateTime.now();
    }

    delay().then((_) => predictCycler());
  }

  List<PredictedState> predictForStateOneLevel(PredictedState state) {
    if (state == null) return null;
    state.findPlayablePieces();
    List<PredictedState> predictions = prepareMoves(state);
    return predictions;
  }

  List<PredictedState> prepareMoves(State source) {
    List<PredictedState> predictions = [];
    for (var playablePiece in source.playablePieces) {
      List<int> possibles = source.findPossiblesForPiece(playablePiece);
      if (possibles.length == 0) continue;
      for (int target in possibles) {
        PredictedState predictedState = new PredictedState.move(source, playablePiece, target);
        predictions.add(predictedState);
      }
    }
    return predictions;
  }

  double computeTreeCost(List<PredictedState> stateGroup, int depth) {
    double bestScore;
    if (stateGroup.length == 1) {
      PredictedState orphan = stateGroup.first;
      if (orphan.path.length == depth) {
//        print(
//            "${new List.generate(depth, (_)=>"-").join()} ${orphan.path.sublist(0,depth).join("|")} score: ${orphan.computeScore().toStringAsFixed(2)}");
        return orphan.computeScore();
      }
    }
    Map<String, List<PredictedState>> subGroups = {};
    stateGroup.forEach((PredictedState state) {
      String pathPart = state.path[depth];
      if (!subGroups.containsKey(pathPart)) {
        subGroups[pathPart] = [];
      }
      subGroups[pathPart].add(state);
    });
    subGroups.forEach((String pathPart, List<PredictedState> states) {
      double subGroupScore = computeTreeCost(states, depth + 1);
      if (bestScore == null) {
        bestScore = subGroupScore;
        return;
      }
//      print("$pathPart $bestScore ${bestScore > subGroupScore?">":"<="} $subGroupScore");
      if (pathPart.startsWith(new RegExp("W|w")) != HUNGRY_DAME) {
        if (bestScore < subGroupScore) {
//          print("New best: $bestScore=>$subGroupScore for $pathPart");
          bestScore = subGroupScore;
        }
      } else {
        if (bestScore > subGroupScore) {
//          print("New best: $bestScore=>$subGroupScore for $pathPart");
          bestScore = subGroupScore;
        }
      }
//      print(
//          "${new List.generate(depth, (_)=>"-").join()} ${stateGroup[0].path.sublist(0,depth).join("|")} score: ${bestScore.toStringAsFixed(2)}");
    });
    return bestScore;
  }

  Future delay() => new Future.delayed(const Duration(milliseconds: 0));

  void finish() {
    _isFinished=true;
    sendResults();
  }

  void sendResults() {
    print("sendResults");
    Iterable<PredictedState> allStates =
        [orphans, stateQueue].expand((f) => f).where((PredictedState state) => state != null);
    for (PredictedState state in predictions) {
      String firstPath = state.path.first;
      List<PredictedState> group =
          allStates.where((PredictedState subState) => subState.path.first == firstPath).toList(growable: false);
      state.score = computeTreeCost(group, 0);
    }
    List messages = MessageBus.toMessageList(predictions);
    messages.add({"steps": currentStep, "depth": currentDepth});
    parent.portToMain.send(messages);
  }

  void print(String message) {
    parent.portToMain.send(message);
  }
}
