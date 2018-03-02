import 'dart:async';
import 'dart:collection';

import 'dart:isolate';
import 'package:hungry_dame/src/isolates/message_bus.dart';
import 'package:hungry_dame/src/isolates/predicted_state.dart';
import 'package:hungry_dame/src/services/constants.dart';

class Predictor {
  SendPort portToMain;
  ReceivePort portFromMain = new ReceivePort();
  List<PredictedState> predictions = [];
  List<PredictedState> orphans = [];
  Queue<PredictedState> stateQueue = new Queue<PredictedState>();
  int currentStep = 0;
  DateTime lastUpdateTime;
  bool _paused = false;
  final RegExp whiteRegexp = new RegExp("$WHITE_DAME|$WHITE_PIECE");

  void init(SendPort sendPort) {
    portToMain = sendPort;
    sendPort.send(portFromMain.sendPort);
    portFromMain.listen((rawMessage) {
//      print("Message from Main: $rawMessage");
      if (rawMessage is Map) {
        if (rawMessage.containsKey("stop")) {
          pause();
          return;
        }
        if (rawMessage.containsKey("sendResult")) {
          if(_paused) return;
          sendResults();
          return;
        }
      }
      predict(MessageBus.fromInitMessage(rawMessage));
    });
  }

  void reset([PredictedState chosenDummy]) {
    currentStep = 0;
    PredictedState chosenState;
    if (chosenDummy != null) {
      String chosenId = chosenDummy.arrangementId;
      chosenState =
          predictions.firstWhere((PredictedState state) => state.arrangementId == chosenId, orElse: () => null);
    }
    if (chosenState != null) {
      predictions = [];
      String pathStep = chosenState.pathStep;
      orphans = orphans
          .where((PredictedState state) => state.path.length > 0 && state.path.first == pathStep)
          .map((PredictedState state) => state..path.removeAt(0))
          .toList();
      Iterable<PredictedState> stateQueueTemp = stateQueue
          .where((PredictedState state) => state.path.length > 0 && state.path.first == pathStep)
          .map((PredictedState state) => state..path.removeAt(0));
      stateQueue
        ..clear()
        ..addAll(stateQueueTemp);
    } else {
      predictions = [];
      orphans = [];
      stateQueue.clear();
    }
    _paused = false;
  }

  void predict(PredictedState currentState) {
    reset(currentState);

    currentState.findPlayablePieces();
    predictions = prepareMoves(currentState);
    if (predictions.length == 0) {
      return pause();
    }
    if (stateQueue.length == 0) {
      for (PredictedState state in predictions) {
        stateQueue.add(state);
      }
    }
    lastUpdateTime = new DateTime.now();
    predictCycler();
  }

  void predictCycler() {
    for (int i = 0; i < 500; i++) {
      if (_paused) return null;
      if (stateQueue.length == 0) {
        return pause();
      }
      currentStep++;
      PredictedState state = stateQueue.removeFirst();
      List<PredictedState> states = predictForStateOneLevel(state);
      if (states.length == 0) {
        orphans.add(state);
      } else {
        if(state.isForced){
          states.forEach(stateQueue.addFirst);
        }else{
          stateQueue.addAll(states);
        }
      }
    }
    if (new DateTime.now().difference(lastUpdateTime) > UPDATE_PERIOD) {
      if(stateQueue.length+orphans.length >=MAX_STEPS){
        return pause();
      }
      sendProgress();
      lastUpdateTime = new DateTime.now();
    }

    delay().then((_) => predictCycler());
  }

  List<PredictedState> predictForStateOneLevel(PredictedState state) {
    if(state.path.length == MAX_DEPTH) return const [];
    List<PredictedState> predictions = prepareMoves(state);
    return predictions;
  }

  List<PredictedState> prepareMoves(PredictedState source) {
    List<PredictedState> predictions = [];
    List<int> playablePieces = source.findPlayablePieces();
    for (var piecePosition in playablePieces) {
      List<int> possibles = source.findPossiblesForPiece(piecePosition);
      if (possibles.length == 0) continue;
      for (int target in possibles) {
        PredictedState predictedState =
            new PredictedState.move(source, source.getPieceAt(piecePosition), piecePosition, target);
        predictions.add(predictedState);
      }
    }
    return predictions;
  }

  double computeTreeCost(Iterable<PredictedState> stateGroup, int depth) {
    double bestScore;
    Map<String, List<PredictedState>> subGroups = {};
    for (PredictedState state in stateGroup) {
      if (state.path.length == depth) {
        return state.computeScore();
      }
      String pathPart = state.path[depth];
      if (subGroups[pathPart] == null) {
        subGroups[pathPart] = [state];
        continue;
      }
      subGroups[pathPart].add(state);
    }
    subGroups.forEach((String pathPart, List<PredictedState> states) {
      double subGroupScore = computeTreeCost(states, depth + 1);
      if (bestScore == null) {
        bestScore = subGroupScore;
        return;
      }
//      print("$pathPart $bestScore ${bestScore > subGroupScore?">":"<="} $subGroupScore");
      if (pathPart.startsWith(whiteRegexp)) {
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
    });
    if (bestScore >= 100000) {
      return bestScore - 1;
    } else if (bestScore <= -100000) {
      return bestScore + 1;
    }
//    print(
//        "${new List.generate(depth, (_)=>".").join()}└ ${stateGroup[0].path.sublist(0,depth).join("|")} score: ${bestScore.toStringAsFixed(2)}");
    return bestScore;
  }

  Future delay() => new Future.delayed(const Duration(milliseconds: 1));

  void pause() {
    _paused = true;
    sendResults();
//    stateQueue.clear();
//    orphans.clear();
  }

  void sendResults() {
//    print("sendResults");
    Iterable<PredictedState> allStates =
        [orphans, stateQueue].expand((f) => f).where((PredictedState state) => state != null);
    List<Map<String, dynamic>> messages = [];
    for (PredictedState state in predictions) {
      String firstPath = state.path.first;
      Iterable<PredictedState> group =
          allStates.where((PredictedState subState) => subState.path.length>0 && subState.path[0] == firstPath);
      double score = computeTreeCost(group, 1);
      messages.add(MessageBus.toMessage(state, score));
    }
    double currentDepth = computeDepth();
    messages.add({"steps": stateQueue.length + orphans.length, "depth": currentDepth});
    portToMain.send(messages);
  }
  void sendProgress(){
    double currentDepth = computeDepth();
    portToMain.send({"steps": stateQueue.length + orphans.length, "depth": currentDepth});
  }

  double computeDepth() {
//    if (currentStep == 0 && stateQueue.length == 0) return 0.0;
    if (stateQueue.length == 0) return double.INFINITY;
    int summedDepth = 0;
    int length = stateQueue.length;
    for (double i = 0.0; i < 1; i += 0.002) {
      summedDepth += stateQueue.elementAt((i * length).floor()).path.length;
    }
//    int summedDepth = stateQueue.fold<int>(0, (int sum, PredictedState state) => sum + state.path.length);
    return summedDepth / 500.0;
  }

  void print(String message) {
    portToMain.send(message);
  }
}
