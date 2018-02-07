import 'package:angular/di.dart';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/current_state.dart';
import 'package:hungry_dame/src/services/notificator.dart';
import 'package:hungry_dame/src/services/predicted_state.dart';
import 'package:hungry_dame/src/services/state.dart';

@Injectable()
class Predictor {
  static const int MAX_DEPTH = 5;
  List<PredictedState> predictions = [];
  Notificator onPrediction = new Notificator();

  Predictor() {}

  void predict(CurrentState currentState) {
    currentState.findPlayablePieces();
    predictions = prepareMoves(currentState);
    for (PredictedState state in predictions) {
      predictForState(state, 1);
      computeTreeCost(state);
    }
    predictions.sort((PredictedState a, PredictedState b) => a.score.compareTo(b.score));
    if (!currentState.blackIsPlaying) {
      predictions = predictions.reversed.toList();
    }
    onPrediction.notify();
  }

  void predictForState(PredictedState state, int depth) {
    state.findPlayablePieces();
    List<PredictedState> predictions = prepareMoves(state);
    state.subPredictions = predictions;
    if (depth >= MAX_DEPTH) return;
    for (PredictedState subState in predictions) {
      predictForState(subState, depth + 1);
    }
  }

  List<PredictedState> prepareMoves(State source) {
    List<PredictedState> predictions = [];
    for (Piece playablePiece in source.playablePieces) {
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

      if (state.blackIsPlaying) {
        if (bestScore > subState.score) {
          bestScore = subState.score;
        }
      } else {
        if (bestScore < subState.score) {
          bestScore = subState.score;
        }
      }
    }
    state.score = bestScore;
    return bestScore;
  }
}
