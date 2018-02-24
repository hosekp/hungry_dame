part of model;

class Dame extends Piece implements AbstractPiece {
  bool isDame = true;
  Dame({bool black: false}) : super(black: black, code: black ? BLACK_DAME_CODE : WHITE_DAME_CODE);

  String get letter => isBlack ? BLACK_DAME : WHITE_DAME;

  bool isForced(int position, Arrangement arrangement) {
    if (canStepJump(position, LEFT_UP, arrangement)) return true;
    if (canStepJump(position, LEFT_DOWN, arrangement)) return true;
    if (canStepJump(position, RIGHT_UP, arrangement)) return true;
    if (canStepJump(position, RIGHT_DOWN, arrangement)) return true;
    return false;
  }

  bool canStepJump(int origin, int step, Arrangement arrangement) {
    int target = origin;
    while (true) {
      target = Piece.stepMove(target, step);
      if (target == null) return false;
      if (arrangement.pieces.containsKey(target)) {
        Piece neighbour = arrangement.getPieceAt(target);
        if (neighbour.isBlack == isBlack) return false;
        target = Piece.stepMove(target, step);
        if (target == null) return false;
        return !arrangement.pieces.containsKey(target);
      }
    }
  }

  List<int> possibleForcedMoves(int position, Arrangement arrangement) {
    List<int> moves = [];
    if (canStepJump(position, LEFT_UP, arrangement)) {
      _possibleStepJumps(position, LEFT_UP, arrangement, moves);
    }
    if (canStepJump(position, LEFT_DOWN, arrangement)) {
      _possibleStepJumps(position, LEFT_DOWN, arrangement, moves);
    }
    if (canStepJump(position, RIGHT_UP, arrangement)) {
      _possibleStepJumps(position, RIGHT_UP, arrangement, moves);
    }
    if (canStepJump(position, RIGHT_DOWN, arrangement)) {
      _possibleStepJumps(position, RIGHT_DOWN, arrangement, moves);
    }
    return moves;
  }

  List<int> possibleMoves(int position, Arrangement arrangement) {
    List<int> moves = [];
    _possibleStepMoves(position, LEFT_UP, arrangement, moves);
    _possibleStepMoves(position, LEFT_DOWN, arrangement, moves);
    _possibleStepMoves(position, RIGHT_UP, arrangement, moves);
    _possibleStepMoves(position, RIGHT_DOWN, arrangement, moves);
    return moves;
  }

  void _possibleStepMoves(int origin, int step, Arrangement arrangement, List<int> moves) {
    int target = origin;
    while (true) {
      target = Piece.stepMove(target, step);
      if (target == null) return;
      if (arrangement.pieces.containsKey(target)) return;
      moves.add(target);
    }
  }

  void _possibleStepJumps(int origin, int step, Arrangement arrangement, List<int> moves) {
    int target = origin;
    while (true) {
      target = Piece.stepMove(target, step);
      if (target == null) return;
      if (arrangement.pieces.containsKey(target)) break;
    }
    while (true) {
      target = Piece.stepMove(target, step);
      if (target == null) return;
      if (arrangement.pieces.containsKey(target)) return;
      moves.add(target);
    }
  }
}
