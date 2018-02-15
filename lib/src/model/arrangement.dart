part of model;

class Arrangement {
  final Map<int, Piece> pieces;

  Arrangement.start() : pieces = _initialPieces(_whiteInitial(), _blackInitial()) {}

  static List<int> _blackInitial() {
    return const [1, 3, 5, 7, 8, 10, 12, 14, 17, 19, 21, 23];
  }

  Arrangement.testChained() : pieces = _initialPieces([12, 28], [19, 1, 5]) {}
  Arrangement.testDame() : pieces = _initialPieces([35, 44], [26, 21, 14], [35]) {}
  Arrangement.testEnd() : pieces = _initialPieces([35], [26, 10], [35]) {}
  Arrangement.testPromote() : pieces = _initialPieces([17], [12, 10]) {}
//  Arrangement.testPredict():pieces = _initialPieces([35,44,62],[19,12,1]);
  Arrangement.testPredict() : pieces = _initialPieces([62], [51]);

  Arrangement.copy(Arrangement arrangement) : pieces = _copyPieces(arrangement.pieces);
  Arrangement.fromId(String id) : pieces = _fromId(id);

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
    if (dames != null) {
      for (int pos in dames) {
        Piece oldPiece = initialPieces[pos];
        initialPieces[pos] = new Dame(pos: pos, black: oldPiece.isBlack);
      }
    }
    return initialPieces;
  }

  static _copyPieces(Map<int, Piece> oldPieces) {
    Map<int, Piece> newPieces = {};
    oldPieces.forEach((int pos, Piece piece) {
      newPieces[pos] = piece.copy();
    });
    return newPieces;
  }

  static _fromId(String id) {
    Map<int, Piece> pieces = {};
    int pos = 0;
    id.runes.forEach((int rune) {
      switch (rune) {
        case 66:
          pieces[pos] = new Dame(pos: pos, black: true);
          break;
        case 87:
          pieces[pos] = new Dame(pos: pos, black: false);
          break;
        case 98:
          pieces[pos] = new Piece(pos: pos, black: true);
          break;
        case 119:
          pieces[pos] = new Piece(pos: pos, black: false);
          break;
        default:
          break;
      }
      pos++;
    });
    return pieces;
  }

  void remove(Piece piece) {
    pieces.remove(piece.position);
  }

  String get id {
    StringBuffer result = new StringBuffer();
    for (int i = 0; i < 64; i++) {
      Piece piece = pieces[i];
      result.write(piece == null ? "-" : piece.letter);
    }
    return result.toString();
  }
}
