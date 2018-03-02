import 'dart:typed_data';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/constants.dart';

const Map<int, Piece> SPECIES = const {
  0: null,
  WHITE_PIECE_CODE: const Piece(black: false),
  BLACK_PIECE_CODE: const Piece(black: true),
  WHITE_DAME_CODE: const Dame(black: false),
  BLACK_DAME_CODE: const Dame(black: true)
};

class Arrangement {
  static Int8List start() => _initialPieces(_whiteInitial, _blackInitial);

  static List<int> _blackInitial = const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  static List<int> _whiteInitial = const [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31];
//    return const [1, 3, 5, 7, 8, 10, 12, 14, 17, 19, 21, 23];

  static Int8List testChained() => _initialPieces([6, 14], [9, 0, 2]);
  static Int8List testDame() => _initialPieces([17, 22], [13, 10, 7], [17]);
  static Int8List testEnd() => _initialPieces([17], [13, 5], [17]);
  static Int8List testPromote() => _initialPieces([8], [6, 5]);
//  static Int8List testPredict()=> _initialPieces([17,22,31],[9,6,0]);
  static Int8List testPredict() => _initialPieces([31], [25]);

  static Int8List copy(Int8List source) => _copyPieces(source);
  static Int8List fromId(String id) => _fromId(id);

  static Int8List _initialPieces(Iterable<int> whites, Iterable<int> blacks, [Iterable<int> dames]) {
    Int8List initialPieces = new Int8List(32);
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
    Int8List pieces = new Int8List(32);
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

const List<int> POSITION_TO_INDEX = const [
  1,
  3,
  5,
  7,
  8,
  10,
  12,
  14,
  17,
  19,
  21,
  23,
  24,
  26,
  28,
  30,
  33,
  35,
  37,
  39,
  40,
  42,
  44,
  46,
  49,
  51,
  53,
  55,
  56,
  58,
  60,
  62
];
const List<int> LEFT_UP_NEIGHBOURS = const [
  -1,
  -1,
  -1,
  -1,
  -1,
  0,
  1,
  2,
  4,
  5,
  6,
  7,
  -1,
  8,
  9,
  10,
  12,
  13,
  14,
  15,
  -1,
  16,
  17,
  18,
  20,
  21,
  22,
  23,
  -1,
  24,
  25,
  26
];
const List<int> RIGHT_UP_NEIGHBOURS = const [
  -1,
  -1,
  -1,
  -1,
  0,
  1,
  2,
  3,
  5,
  6,
  7,
  -1,
  8,
  9,
  10,
  11,
  13,
  14,
  15,
  -1,
  16,
  17,
  18,
  19,
  21,
  22,
  23,
  -1,
  24,
  25,
  26,
  27
];
const List<int> LEFT_DOWN_NEIGHBOURS = const [
  4,
  5,
  6,
  7,
  -1,
  8,
  9,
  10,
  12,
  13,
  14,
  15,
  -1,
  16,
  17,
  18,
  20,
  21,
  22,
  23,
  -1,
  24,
  25,
  26,
  28,
  29,
  30,
  31,
  -1,
  -1,
  -1,
  -1
];
const List<int> RIGHT_DOWN_NEIGHBOURS = const [
  5,
  6,
  7,
  -1,
  8,
  9,
  10,
  11,
  13,
  14,
  15,
  -1,
  16,
  17,
  18,
  19,
  21,
  22,
  23,
  -1,
  24,
  25,
  26,
  27,
  29,
  30,
  31,
  -1,
  -1,
  -1,
  -1,
  -1
];
