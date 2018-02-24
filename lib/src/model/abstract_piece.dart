part of model;

abstract class AbstractPiece {
  bool isForced(int position, Arrangement arrangement);
  List<int> possibleForcedMoves(int position, Arrangement arrangement);
  List<int> possibleMoves(int position, Arrangement arrangement);
}
