import 'dart:typed_data';
import 'package:hungry_dame/src/model/arrangement.dart';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/model/state.dart';
import 'package:hungry_dame/src/services/constants.dart';

class PredictedState extends State {
  List<int> path = [];

  PredictedState.move(State previous, Piece piece, int origin, int target) {
    pieces8 = Arrangement.copy(previous.pieces8);
    isForced = previous.isForced;
    blackIsPlaying = previous.blackIsPlaying;

    if (isForced) {
      removePieceInLine(origin, target);
    }
    pieces8[target] = piece.code;
    pieces8[origin] = 0;
    if (piece.shouldPromote(target)) {
      piece.promote(target, pieces8);
    }
    if (isForced && piece.isForced(target, pieces8)) {
      chainedPiece = target;
    } else {
      isForced = false;
      chainedPiece = null;
      blackIsPlaying = !blackIsPlaying;
    }
    if (previous is PredictedState) {
      path.addAll(previous.path);
    }
    path.add(pathStepBuild(piece, origin, target));
  }

  PredictedState.allData(Int8List pieces, bool black, bool isChained, int origin, int target) {
    this.pieces8 = pieces;
    blackIsPlaying = black;
    if (isChained) {
      chainedPiece = pieces[target];
    }
  }
  int get pathStep => path.last;
  Piece get lastStepPiece {
    int code = (pathStep.abs() / 1000000).floor() * pathStep.sign;
    return SPECIES[code];
  }
  int get lastStepOrigin => ((pathStep.abs() % 1000000) / 1000).floor();
  int get lastStepTarget => pathStep.abs() % 1000;

  static int pathStepBuild(Piece piece, int origin, int target) {
    return (piece.code.abs() * 1000000 + origin * 1000 + target) * piece.code.sign;
  }

  String get id => "${super.id}|${path}";

  double computeScore() {
    double whiteScore = 0.0;
    double blackScore = 0.0;
    int piecePos = 0;
    Iterator<int> iterator = pieces8.iterator;
    while (iterator.moveNext()) {
      int pieceCode = iterator.current;
      if (pieceCode == 0) {
        piecePos++;
        continue;
      }
      if (pieceCode >= WHITE_PIECE_CODE) {
        if (pieceCode == WHITE_PIECE_CODE) {
          int row = (piecePos / 4).floor();
          whiteScore += PIECE_VALUE * (1 + (7 - row) / 7.0);
        } else {
          whiteScore += DAME_VALUE;
        }
      } else {
        if (pieceCode == BLACK_PIECE_CODE) {
          int row = (piecePos / 4).floor();
          blackScore += PIECE_VALUE * (1 + row / 7.0);
        } else {
          blackScore += DAME_VALUE;
        }
      }
      piecePos++;
//      double pieceValue;
//      if (pieceCode == BLACK_DAME_CODE || pieceCode == WHITE_DAME_CODE) {
//        pieceValue = DAME_VALUE;
//      } else {
////        int row = (piece.position / 8).floor();
////        pieceValue = PIECE_VALUE + PIECE_VALUE * (piece.isBlack ? row : 7 - row);
//        pieceValue = PIECE_VALUE;
//      }
//      if (pieceCode == BLACK_DAME_CODE || pieceCode == BLACK_PIECE_CODE) {
//        blackScore += pieceValue;
//      } else {
//        whiteScore += pieceValue;
//      }
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
