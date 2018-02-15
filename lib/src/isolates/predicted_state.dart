import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/constants.dart';
import 'package:hungry_dame/src/services/state.dart';

class PredictedState extends State {
  Piece lastMovedPiece; // do not belong to arrangement
  int lastMoveTarget;
  List<String> path = [];

  PredictedState.move(State previous, Piece oldPiece, int target) {
    lastMoveTarget = target;
    lastMovedPiece = oldPiece;
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
    if (previous is PredictedState) {
      path.addAll(previous.path);
    }
    path.add("${lastMovedPiece.letter}${lastMovedPiece.position}-$lastMoveTarget");
  }
  PredictedState.allData(Arrangement arrangement, bool black, bool isChained, int origin, int target) {
    this.arrangement = arrangement;
    blackIsPlaying = black;
    if (isChained) {
      chainedPiece = arrangement.pieces[target];
    }
    if (origin != null) {
      lastMovedPiece = arrangement.pieces[target].copy();
      lastMovedPiece.position = origin;
      lastMoveTarget = target;
    }
  }

  double computeScore() {
    double whiteScore = 0.0;
    double blackScore = 0.0;
    for (Piece piece in arrangement.pieces.values) {
      double pieceValue;
      if (piece.isDame) {
        pieceValue = DAME_VALUE;
      } else {
//        int row = (piece.position / 8).floor();
//        pieceValue = PIECE_VALUE + PIECE_VALUE * (piece.isBlack ? row : 7 - row);
        pieceValue = PIECE_VALUE;
      }
      if (piece.isBlack) {
        blackScore += pieceValue;
      } else {
        whiteScore += pieceValue;
      }
    }
    if (HUNGRY_DAME) {
      if (blackScore == 0) return -1000000.0;
      if (whiteScore == 0) return 1000000.0;
      return blackScore - whiteScore;
    } else {
      if (blackScore == 0) return 1000000.0;
      if (whiteScore == 0) return -1000000.0;
      return whiteScore - blackScore;
    }
//    if (whiteScore > blackScore) {
//      if (blackScore == 0) return 1000000.0;
//      return whiteScore / (blackScore + 0.00001);
//    } else if (blackScore > whiteScore) {
//      if (whiteScore == 0) return -1000000.0;
//      return -blackScore / (whiteScore + 0.00001);
//    } else {
//      return 0.0;
//    }
  }
}
