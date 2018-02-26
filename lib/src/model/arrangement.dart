import 'dart:typed_data';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/constants.dart';

const Map<int, Piece> SPECIES = const{
  0:null,
  WHITE_PIECE_CODE: const Piece(black: false),
  BLACK_PIECE_CODE: const Piece(black: true),
  WHITE_DAME_CODE: const Dame(black: false),
  BLACK_DAME_CODE: const Dame(black: true)
};

class Arrangement {

  static Int8List start() => _initialPieces(_whiteInitial(), _blackInitial());

  static List<int> _blackInitial() {
    return const [1, 3, 5, 7, 8, 10, 12, 14, 17, 19, 21, 23];
  }

  static Int8List testChained() => _initialPieces([12, 28], [19, 1, 5]);
  static Int8List testDame() => _initialPieces([35, 44], [26, 21, 14], [35]);
  static Int8List testEnd() => _initialPieces([35], [26, 10], [35]);
  static Int8List testPromote() => _initialPieces([17], [12, 10]);
//  Arrangement.testPredict():pieces = _initialPieces([35,44,62],[19,12,1]);
  static Int8List testPredict() => _initialPieces([62], [51]);

  static Int8List copy(Int8List source) => _copyPieces(source);
  static Int8List fromId(String id) => _fromId(id);

  static Iterable<int> _whiteInitial() {
    return _blackInitial().map((i) => 63 - i);
  }

  static Int8List _initialPieces(Iterable<int> whites, Iterable<int> blacks, [Iterable<int> dames]) {
    Int8List initialPieces = new Int8List(64);
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

  static _copyPieces(Int8List oldPieces) => new Int8List.fromList(oldPieces);

  static _fromId(String id) {
    Int8List pieces = new Int8List(64);
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
