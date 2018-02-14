import 'package:hungry_dame/src/isolates/predicted_state.dart';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/predict_result_state.dart';
import 'package:hungry_dame/src/services/state.dart';

class MessageBus {
  static Map<String, dynamic> toMessage(PredictedState state, double score) {
    return {
      "arr": state.arrangement.id,
//      "black": state.blackIsPlaying,
      "origin": state.lastMovedPiece.position,
      "piece": state.lastMovedPiece.letter,
      "target": state.lastMoveTarget,
//      "chained": state.chainedPiece != null,
      "score": score
    };
  }

  static Map<String, dynamic> toInitMessage(State state) {
    return {"arr": state.arrangement.id, "black": state.blackIsPlaying, "chained": state.chainedPiece != null};
  }

  static PredictedState fromInitMessage(Map<String, dynamic> message) {
    PredictedState state = new PredictedState.allData(new Arrangement.fromId(message["arr"]), message["black"],
        message["chained"], message["origin"], message["target"]);
    return state;
  }

  static PredictResultState fromIsolateMessage(Map<String, dynamic> message) {
    PredictResultState state = new PredictResultState(
      message["score"],
      message["piece"],
      message["origin"],
      message["target"],
    );
    return state;
  }
}
