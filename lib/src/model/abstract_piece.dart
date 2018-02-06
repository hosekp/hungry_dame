part of model;

abstract class AbstractPiece{
  bool isForced(Arrangement arrangement);
  List<int> possibleForcedMoves(Arrangement arrangement);
  List<int> possibleMoves(Arrangement arrangement);
}