import 'package:hungry_dame/src/services/predicted_state.dart';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/state.dart';

class MessageBus {
  static Map<String, dynamic> toMessage(PredictedState state) {
    return {
      "arr": state.arrangement.id,
      "black": state.blackIsPlaying,
      "origin": state.lastMovedPiece.position,
      "target": state.lastMoveTarget,
      "chained": state.chainedPiece != null,
      "score": state.score
    };
  }

  static Map<String, dynamic> toInitMessage(State state) {
    return {"arr": state.arrangement.id, "black": state.blackIsPlaying, "chained": state.chainedPiece != null};
  }

  static PredictedState fromMessage(Map<String, dynamic> message) {
    PredictedState state = new PredictedState.allData(new Arrangement.fromId(message["arr"]), message["black"],
        message["chained"], message["origin"], message["target"], message["score"]);
    return state;
  }

  static List<Map<String, dynamic>> toMessageList(List<PredictedState> predictions) {
    return predictions.map(toMessage).toList();
  }
}
