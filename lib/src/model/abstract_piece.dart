part of model;

abstract class AbstractPiece {
  bool isForced(int position, Int8List pieces);
  List<int> possibleForcedMoves(int position, Int8List pieces);
  List<int> possibleMoves(int position, Int8List pieces);
}
