part of model;

class Arrangement {
  final Map<int,Piece> pieces;

  Arrangement.start()
      : pieces=_initialPieces(_whiteInitial(),_blackInitial()) {}
  static List<int> _blackInitial() {
    return const [1, 3, 5, 7, 8, 10, 12, 14, 17, 19, 21, 23];
  }
  Arrangement.testChained():pieces=_initialPieces([12,28],[19,1,5]){

  }

  static Iterable<int> _whiteInitial() {
    return _blackInitial().map((i) => 63 - i);
  }
  static Map<int,Piece> _initialPieces(List<int> whites,List<int> blacks){
    Map<int,Piece> initialPieces={};
    for(int pos in whites){
      initialPieces[pos]=new Piece(pos: pos);
    }
    for(int pos in blacks){
      initialPieces[pos]=new Piece(pos: pos, black: true);
    }
    return initialPieces;
  }

  void remove(Piece piece) {
    pieces.remove(piece.position);
  }
}
