part of model;

class Arrangement {
  final Map<int, Piece> pieces;

  Arrangement.start() : pieces = _initialPieces(_whiteInitial(), _blackInitial()) {}
  static List<int> _blackInitial() {
    return const [1, 3, 5, 7, 8, 10, 12, 14, 17, 19, 21, 23];
  }

  Arrangement.testChained() : pieces = _initialPieces([12, 28], [19, 1, 5]) {}
  Arrangement.testDame() : pieces = _initialPieces([35,44], [26,21,14],[35]) {}
  Arrangement.testEnd() : pieces = _initialPieces([35], [26,10],[35]) {}
  Arrangement.testPromote() : pieces = _initialPieces([17], [12,10]) {}

  static Iterable<int> _whiteInitial() {
    return _blackInitial().map((i) => 63 - i);
  }

  static Map<int, Piece> _initialPieces(Iterable<int> whites, Iterable<int> blacks, [Iterable<int> dames]) {
    Map<int, Piece> initialPieces = {};
    for (int pos in whites) {
      initialPieces[pos] = new Piece(pos: pos);
    }
    for (int pos in blacks) {
      initialPieces[pos] = new Piece(pos: pos, black: true);
    }
    if(dames!=null){
      for (int pos in dames) {
        Piece oldPiece = initialPieces[pos];
        initialPieces[pos] = new Dame(pos: pos,black: oldPiece.isBlack);
      }
    }
    return initialPieces;
  }

  void remove(Piece piece) {
    pieces.remove(piece.position);
  }
}
