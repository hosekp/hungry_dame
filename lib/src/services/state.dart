import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/constants.dart';

class State {
  Arrangement arrangement;
  int chainedPiece;
  List<int> playablePieces = [];
  bool blackIsPlaying = false;
  bool isForced;

  State();

  void findPlayablePieces() {
    playablePieces.clear();
    isForced = true;
    if (chainedPiece != null) {
      playablePieces.add(chainedPiece);
      return;
    }
    List<int> playingDames = [];
    if (blackIsPlaying) {
      arrangement.pieces.forEach((int position, int pieceCode) {
        if (pieceCode == BLACK_DAME_CODE) {
          playingDames.add(position);
        }
      });
    } else {
      arrangement.pieces.forEach((int position, int pieceCode) {
        if (pieceCode == WHITE_DAME_CODE) {
          playingDames.add(position);
        }
      });
    }
    for (int position in playingDames) {
      Dame dame = arrangement.getPieceAt(position);
      if (dame.isForced(position, arrangement)) {
        playablePieces.add(position);
      }
    }
    if (playablePieces.length > 0) return;
    List<int> playingPieces = [];
    if (blackIsPlaying) {
      arrangement.pieces.forEach((int position, int pieceCode) {
        if (pieceCode == BLACK_PIECE_CODE) {
          playingPieces.add(position);
        }
      });
    } else {
      arrangement.pieces.forEach((int position, int pieceCode) {
        if (pieceCode == WHITE_PIECE_CODE) {
          playingPieces.add(position);
        }
      });
    }
    for (int position in playingPieces) {
      Piece piece = arrangement.getPieceAt(position);
      if (piece.isForced(position, arrangement)) {
        playablePieces.add(position);
      }
    }
    if (playablePieces.length > 0) return;
    playablePieces..addAll(playingDames)..addAll(playingPieces);
    isForced = false;
  }

  List<int> findPossiblesForPiece(int position) {
    Piece piece = arrangement.getPieceAt(position);
    if (isForced) {
      return piece.possibleForcedMoves(position, arrangement);
    } else {
      return piece.possibleMoves(position, arrangement);
    }
  }

  void removePieceInLine(int from, int to, Arrangement arrangement) {
    int diff = to - from;
    int step;
    if (diff > 0) {
      step = diff % 7 == 0 ? 7 : 9;
    } else {
      step = -diff % 7 == 0 ? -7 : -9;
    }
    int mover = from;
    while (mover != to) {
      mover += step;
      arrangement.pieces.remove(mover);
    }
  }

  String get id => "${arrangement.id}|${blackIsPlaying?"B":"W"}${chainedPiece==null?"":"|"+chainedPiece.toString()}";

  bool isEndOfGame() {
    if (blackIsPlaying) {
      return !arrangement.pieces.values.any((int pieceType) {
        return pieceType == WHITE_DAME_CODE || pieceType == WHITE_PIECE_CODE;
      });
    } else {
      return !arrangement.pieces.values.any((int pieceType) {
        return pieceType == BLACK_DAME_CODE || pieceType == BLACK_PIECE_CODE;
      });
    }
  }
//      !arrangement.pieces.values.any((Piece piece) => piece.isBlack != blackIsPlaying);
}
