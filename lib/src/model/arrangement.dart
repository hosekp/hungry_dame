part of model;

class Arrangement {
  final Map<int, int> pieces;
  final Map<int, Piece> species = {
    WHITE_PIECE_CODE: new Piece(black: false),
    BLACK_PIECE_CODE: new Piece(black: true),
    WHITE_DAME_CODE: new Dame(black: false),
    BLACK_DAME_CODE: new Dame(black: true)
  };

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

  Piece getPieceAt(int position) => species[pieces[position]];

  static Map<int, int> _initialPieces(Iterable<int> whites, Iterable<int> blacks, [Iterable<int> dames]) {
    Map<int, int> initialPieces = {};
    for (int pos in whites) {
      initialPieces[pos] = WHITE_PIECE_CODE;
    }
    for (int pos in blacks) {
      initialPieces[pos] = BLACK_PIECE_CODE;
    }
    if (dames != null) {
      for (int pos in dames) {
        initialPieces[pos] = initialPieces[pos] == WHITE_PIECE_CODE ? WHITE_DAME_CODE : BLACK_DAME_CODE;
      }
    }
    return initialPieces;
  }

  static _copyPieces(Map<int, int> oldPieces) => new Map<int, int>.from(oldPieces);

  static _fromId(String id) {
    Map<int, int> pieces = {};
    int pos = 0;
    id.runes.forEach((int rune) {
      switch (rune) {
        case 66:
          pieces[pos] = BLACK_DAME_CODE;
          break;
        case 87:
          pieces[pos] = WHITE_DAME_CODE;
          break;
        case 98:
          pieces[pos] = BLACK_PIECE_CODE;
          break;
        case 119:
          pieces[pos] = WHITE_PIECE_CODE;
          break;
        default:
          break;
      }
      pos++;
    });
    return pieces;
  }

//  void remove(Piece piece) {
//    pieces.remove(piece.position);
//  }

  String get id {
    StringBuffer result = new StringBuffer();
    for (int i = 0; i < 64; i++) {
      Piece piece = getPieceAt(i);
      result.write(piece == null ? "-" : piece.letter);
    }
    return result.toString();
  }
}
