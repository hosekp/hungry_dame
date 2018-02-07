import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/state.dart';

class PredictedState extends State{
  static const double DAME_VALUE = 3.0;
  static const double PIECE_VALUE = 1.0;
  Piece lastMovedPiece; // do not belong to arrangement
  int lastMoveTarget;
  double score;
  double innerScore;
  List<PredictedState> subPredictions;

  PredictedState.move(State previous, Piece oldPiece, int target) {
    lastMoveTarget=target;
    lastMovedPiece=oldPiece;
    arrangement = new Arrangement.copy(previous.arrangement);
    isForced = previous.isForced;
    blackIsPlaying = previous.blackIsPlaying;

    if (isForced) {
      removePieceInLine(oldPiece.position, target, arrangement);
    }
    Piece piece = arrangement.pieces[oldPiece.position];
    arrangement.pieces[target] = piece;
    arrangement.pieces.remove(oldPiece.position);
    piece.position = target;
    if (piece.shouldPromote()) {
      piece = piece.promote(arrangement);
    }
    if (isForced && piece.isForced(arrangement)) {
      chainedPiece = piece;
    } else {
      isForced = false;
      chainedPiece = null;
      blackIsPlaying = !blackIsPlaying;
    }
    innerScore = computeScore();
  }

  double computeScore() {
    double whiteScore = 0.0;
    double blackScore = 0.0;
    for (Piece piece in arrangement.pieces.values) {
      double pieceValue;
      if(piece.isDame){
        pieceValue=DAME_VALUE;
      }else{
        int row=(piece.position/8).floor();
        pieceValue=PIECE_VALUE+PIECE_VALUE*(piece.isBlack?row:7-row);
      }
      if (piece.isBlack) {
        blackScore += pieceValue;
      } else {
        whiteScore += pieceValue;
      }
    }
    if (whiteScore > blackScore) {
      if(blackScore==0) return 1000000.0;
      return whiteScore / (blackScore + 0.00001);
    } else if (blackScore > whiteScore) {
      if(whiteScore==0) return -1000000.0;
      return -blackScore / (whiteScore + 0.00001);
    } else {
      return 0.0;
    }
  }
}