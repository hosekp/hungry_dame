import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/constants.dart';

const Map<int, Piece> SPECIES = const{
  WHITE_PIECE_CODE: const Piece(black: false),
  BLACK_PIECE_CODE: const Piece(black: true),
  WHITE_DAME_CODE: const Dame(black: false),
  BLACK_DAME_CODE: const Dame(black: true)
};

class Arrangement {

  static Map<int, int> start() => _initialPieces(_whiteInitial(), _blackInitial());

  static List<int> _blackInitial() {
    return const [1, 3, 5, 7, 8, 10, 12, 14, 17, 19, 21, 23];
  }

  static Map<int, int> testChained() => _initialPieces([12, 28], [19, 1, 5]);
  static Map<int, int> testDame() => _initialPieces([35, 44], [26, 21, 14], [35]);
  static Map<int, int> testEnd() => _initialPieces([35], [26, 10], [35]);
  static Map<int, int> testPromote() => _initialPieces([17], [12, 10]);
//  Arrangement.testPredict():pieces = _initialPieces([35,44,62],[19,12,1]);
  static Map<int, int> testPredict() => _initialPieces([62], [51]);

  static Map<int, int> copy(Map<int, int> source) => _copyPieces(source);
  static Map<int, int> fromId(String id) => _fromId(id);

  static Iterable<int> _whiteInitial() {
    return _blackInitial().map((i) => 63 - i);
  }

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
}
