import 'dart:async';
import 'dart:collection';

import 'package:hungry_dame/src/isolates/message_bus.dart';
import 'package:hungry_dame/src/isolates/predictor_isolate.dart';
import 'package:hungry_dame/src/services/predicted_state.dart';
import 'package:hungry_dame/src/services/state.dart';

class PredictorJob {
  static const int MAX_DEPTH = 8;
  static const int MAX_STEPS = 500000;
  static const HUNGRY_DAME = true;
  List<PredictedState> predictions = [];
  List<PredictedState> deepPredictions = [];
  int currentDepth = 0;
  int currentStep = 0;
  ListQueue<PredictedState> stateQueue = new ListQueue<PredictedState>();
  final PredictorIsolate parent;

  PredictorJob(this.parent);

  bool get isKilled => parent.current != this;

  void predict(State currentState) {
//    print("predict(${currentState.id})");
    currentState.findPlayablePieces();
    predictions = prepareMoves(currentState);
    if (predictions.length == 0) {
      sendResults();
      return;
    }
    for (PredictedState state in predictions) {
      stateQueue.add(state);
    }
    stateQueue.add(null);
    predictCycler(stateQueue);
  }

  void predictCycler(ListQueue<PredictedState> queue) {
    for (int i = 0; i < 500; i++) {
      if (isKilled) return;
      if (queue.length == 0) {
        sendResults();
        return;
      }
      currentStep++;
      List<PredictedState> states = predictForStateOneLevel(queue.removeFirst());
      if (states == null) {
        currentStep--;
        if (currentDepth >= MAX_DEPTH) {
          sendResults();
          return;
        }
        currentDepth++;
        queue.add(null);
      } else {
        queue.addAll(states);
      }
    }
//    if (currentStep > MAX_STEPS) {
//      sendResults();
//      return;
//    }
    sendResults();
    delay().then((_) => predictCycler(queue));
  }

  List<PredictedState> predictForStateOneLevel(PredictedState state) {
    if (state == null) return null;
    state.findPlayablePieces();
    List<PredictedState> predictions = prepareMoves(state);
    state.subPredictions = predictions;
    return state.subPredictions;
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

  double computeTreeCost(PredictedState state) {
    double bestScore;
    if (state.subPredictions == null || state.subPredictions.length == 0) {
      state.score = state.innerScore;
      return state.innerScore;
    }
    for (PredictedState subState in state.subPredictions) {
      computeTreeCost(subState);
      if (bestScore == null) {
        bestScore = subState.score;
        continue;
      }
      if (state.blackIsPlaying != HUNGRY_DAME) {
        if (bestScore > subState.score) {
          bestScore = subState.score;
        }
      } else {
        if (bestScore < subState.score) {
          bestScore = subState.score;
        }
      }
    }
    if (bestScore.abs() >= 1000000) {
      bestScore += 1000000 * bestScore.sign;
    }
    state.score = bestScore;
    return bestScore;
  }

  Future delay() => new Future.delayed(const Duration(milliseconds: 0));

  void sendResults() {
    predictions.forEach(computeTreeCost);
    List messages = MessageBus.toMessageList(predictions);
    messages.add({"steps": currentStep, "depth": currentDepth});
    parent.portToMain.send(messages);
  }

  void print(String message) {
    parent.portToMain.send(message);
  }
}
