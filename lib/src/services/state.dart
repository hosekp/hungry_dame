import 'package:hungry_dame/src/model/model.dart';

class State {
  Arrangement arrangement;
  Piece chainedPiece;
  List<Piece> playablePieces = [];
  bool blackIsPlaying = false;
  bool isForced;



  void findPlayablePieces() {
    playablePieces.clear();
    isForced=true;
    if (chainedPiece != null) {
      playablePieces.add(chainedPiece);
      return;
    }
    Iterable<Piece> playingPieces = arrangement.pieces.values.where((Piece piece) => piece.isBlack == blackIsPlaying);
    Iterable<Dame> dames = playingPieces.where((Piece piece) => piece.isDame);
    for (Dame dame in dames) {
      if (dame.isForced(arrangement)) {
        playablePieces.add(dame);
      }
    }
    if (playablePieces.length > 0) return;
    Iterable<Piece> pieces = playingPieces.where((Piece piece) => !piece.isDame);
    for (Piece piece in pieces) {
      if (piece.isForced(arrangement)) {
        playablePieces.add(piece);
      }
    }
    if (playablePieces.length > 0) return;
    playablePieces.addAll(playingPieces);
    isForced=false;
  }

  void removePieceInLine(int from,int to,Arrangement arrangement){
    int diff = to-from;
    int step;
    if(diff>0){
      step=diff%7==0?7:9;
    }else{
      step=-diff%7==0?-7:-9;
    }
    int mover=from;
    while(mover!=to){
      mover+=step;
      Piece piece=arrangement.pieces[mover];
      if(piece!=null){
        arrangement.remove(piece);
        return;
      }
    }
  }
  
  bool isEndOfGame()=> !arrangement.pieces.values.any((Piece piece)=>piece.isBlack!=blackIsPlaying);
}
