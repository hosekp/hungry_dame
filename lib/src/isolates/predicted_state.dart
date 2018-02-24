import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/constants.dart';
import 'package:hungry_dame/src/services/state.dart';

class PredictedState extends State {
  Piece lastMovedPiece; // do not belong to arrangement
  int lastMoveTarget;
  int lastMoveOrigin;
  List<String> path = [];

  PredictedState.move(State previous, Piece piece, int origin, int target) {
    lastMoveTarget = target;
    lastMovedPiece = piece;
    lastMoveOrigin = origin;
    arrangement = new Arrangement.copy(previous.arrangement);
    isForced = previous.isForced;
    blackIsPlaying = previous.blackIsPlaying;

    if (isForced) {
      removePieceInLine(origin, target, arrangement);
    }
    arrangement.pieces[target] = piece.code;
    arrangement.pieces.remove(origin);
    if (piece.shouldPromote(target)) {
      piece.promote(target, arrangement);
    }
    if (isForced && piece.isForced(target, arrangement)) {
      chainedPiece = target;
    } else {
      isForced = false;
      chainedPiece = null;
      blackIsPlaying = !blackIsPlaying;
    }
    if (previous is PredictedState) {
      path.addAll(previous.path);
    }
    path.add(pathStep);
  }

  PredictedState.allData(Arrangement arrangement, bool black, bool isChained, int origin, int target) {
    this.arrangement = arrangement;
    blackIsPlaying = black;
    if (isChained) {
      chainedPiece = arrangement.pieces[target];
    }
    if (target != null) {
      lastMovedPiece = arrangement.getPieceAt(target);
      lastMoveTarget = target;
      lastMoveOrigin = origin;
    }
  }
  String get pathStep => "${lastMovedPiece.letter}${lastMoveOrigin}-$lastMoveTarget";
  String get id => "${super.id}|${path}";

  double computeScore() {
    double whiteScore = 0.0;
    double blackScore = 0.0;
    for (int pieceCode in arrangement.pieces.values) {
      double pieceValue;
      if (pieceCode == BLACK_DAME_CODE || pieceCode == WHITE_DAME_CODE) {
        pieceValue = DAME_VALUE;
      } else {
//        int row = (piece.position / 8).floor();
//        pieceValue = PIECE_VALUE + PIECE_VALUE * (piece.isBlack ? row : 7 - row);
        pieceValue = PIECE_VALUE;
      }
      if (pieceCode == BLACK_DAME_CODE || pieceCode == BLACK_PIECE_CODE) {
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
  }
}
