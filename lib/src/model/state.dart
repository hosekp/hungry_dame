import 'dart:typed_data';
import 'package:hungry_dame/src/model/arrangement.dart';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/constants.dart';

class State {
  Int8List pieces8;
  int chainedPiece;
  bool blackIsPlaying = false;
  bool isForced;

  State();

  List<int> findPlayablePieces() {
    isForced = true;
    if (chainedPiece != null) {
      return [chainedPiece];
    }
    List<int> playingDames = [];
    int position=0;
    Iterator<int> iterator=pieces8.iterator;
    if (blackIsPlaying) {
      while(iterator.moveNext()){
        if (iterator.current == BLACK_DAME_CODE) {
          playingDames.add(position);
        }
        position++;
      }
//      pieces.forEach((int position, int pieceCode) {
//        if (pieceCode == BLACK_DAME_CODE) {
//          playingDames.add(position);
//        }
//      });
    } else {
      while(iterator.moveNext()){
        if (iterator.current == WHITE_DAME_CODE) {
          playingDames.add(position);
        }
        position++;
      }
//      pieces.forEach((int position, int pieceCode) {
//        if (pieceCode == WHITE_DAME_CODE) {
//          playingDames.add(position);
//        }
//      });
    }
    List<int> playablePieces = [];
    for (int position in playingDames) {
      Dame dame = getPieceAt(position);
      if (dame.isForced(position, pieces8)) {
        playablePieces.add(position);
      }
    }
    if (playablePieces.length > 0) return playablePieces;

    List<int> playingPieces = [];
    position=0;
    iterator=pieces8.iterator;
    if (blackIsPlaying) {
      while(iterator.moveNext()){
        if (iterator.current == BLACK_PIECE_CODE) {
          playingPieces.add(position);
        }
        position++;
      }
//      pieces.forEach((int position, int pieceCode) {
//        if (pieceCode == BLACK_PIECE_CODE) {
//          playingPieces.add(position);
//        }
//      });
    } else {
      while(iterator.moveNext()){
        if (iterator.current == WHITE_PIECE_CODE) {
          playingPieces.add(position);
        }
        position++;
      }
//      pieces.forEach((int position, int pieceCode) {
//        if (pieceCode == WHITE_PIECE_CODE) {
//          playingPieces.add(position);
//        }
//      });
    }
    for (int position in playingPieces) {
      Piece piece = getPieceAt(position);
      if (piece.isForced(position, pieces8)) {
        playablePieces.add(position);
      }
    }
    if (playablePieces.length > 0) return playablePieces;
    playablePieces..addAll(playingDames)..addAll(playingPieces);
    isForced = false;
    return playablePieces;
  }

  List<int> findPossiblesForPiece(int position) {
    Piece piece = getPieceAt(position);
    if (isForced) {
      return piece.possibleForcedMoves(position, pieces8);
    } else {
      return piece.possibleMoves(position, pieces8);
    }
  }

  void removePieceInLine(int from, int to) {
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
      pieces8[mover]=0;
    }
  }
  Piece getPieceAt(int position) => SPECIES[pieces8[position]];

  String get id {
    StringBuffer result = new StringBuffer();
    for (int i = 0; i < 64; i++) {
      Piece piece = getPieceAt(i);
      result.write(piece == null ? "-" : piece.letter);
    }
    result..write("|")..write(blackIsPlaying?BLACK_DAME:WHITE_DAME);
    if(chainedPiece!=null){
      result.write("|${chainedPiece}");
    }
    return result.toString();
  }
  String get arrangementId{
    StringBuffer result = new StringBuffer();
    for (int i = 0; i < 64; i++) {
      Piece piece = getPieceAt(i);
      result.write(piece == null ? "-" : piece.letter);
    }
    return result.toString();
  }

  bool isEndOfGame() {
    if (blackIsPlaying) {
      return !pieces8.any((int pieceType) {
        return pieceType == WHITE_DAME_CODE || pieceType == WHITE_PIECE_CODE;
      });
    } else {
      return !pieces8.any((int pieceType) {
        return pieceType == BLACK_DAME_CODE || pieceType == BLACK_PIECE_CODE;
      });
    }
  }
}
