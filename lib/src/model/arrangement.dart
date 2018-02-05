part of model;

class Arrangement {
  final Map<int,Piece> pieces;

  Arrangement.start()
      : pieces=_initialPieces() {}
  static List<int> _blackInitial() {
    return const [1, 3, 5, 7, 8, 10, 12, 14, 17, 19, 21, 23];
  }

  static Iterable<int> _whiteInitial() {
    return _blackInitial().map((i) => 63 - i);
  }
  static Map<int,Piece> _initialPieces(){
    Map<int,Piece> initialPieces={};
    for(int pos in _whiteInitial()){
      initialPieces[pos]=new Piece(pos: pos);
    }
    for(int pos in _blackInitial()){
      initialPieces[pos]=new Piece(pos: pos, black: true);
    }
    return initialPieces;
  }
}
