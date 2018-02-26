part of model;

abstract class AbstractPiece {
  bool isForced(int position, Map<int, int> pieces);
  List<int> possibleForcedMoves(int position, Map<int, int> pieces);
  List<int> possibleMoves(int position, Map<int, int> pieces);
}
