part of model;

class Dame extends Piece implements AbstractPiece {
  final bool isDame = true;
  const Dame({bool black: false}) : super(black: black, code: black ? BLACK_DAME_CODE : WHITE_DAME_CODE);

  String get letter => isBlack ? BLACK_DAME : WHITE_DAME;

  bool isForced(int position, Map<int, int> pieces) {
    if (canStepJump(position, LEFT_UP, pieces)) return true;
    if (canStepJump(position, LEFT_DOWN, pieces)) return true;
    if (canStepJump(position, RIGHT_UP, pieces)) return true;
    if (canStepJump(position, RIGHT_DOWN, pieces)) return true;
    return false;
  }

  bool canStepJump(int origin, int step, Map<int, int> pieces) {
    int target = origin;
    while (true) {
      target = Piece.stepMove(target, step);
      if (target == null) return false;
      if (pieces.containsKey(target)) {
        Piece neighbour = SPECIES[pieces[target]];
        if (neighbour.isBlack == isBlack) return false;
        target = Piece.stepMove(target, step);
        if (target == null) return false;
        return !pieces.containsKey(target);
      }
    }
  }

  List<int> possibleForcedMoves(int position, Map<int, int> pieces) {
    List<int> moves = [];
    if (canStepJump(position, LEFT_UP, pieces)) {
      _possibleStepJumps(position, LEFT_UP, pieces, moves);
    }
    if (canStepJump(position, LEFT_DOWN, pieces)) {
      _possibleStepJumps(position, LEFT_DOWN, pieces, moves);
    }
    if (canStepJump(position, RIGHT_UP, pieces)) {
      _possibleStepJumps(position, RIGHT_UP, pieces, moves);
    }
    if (canStepJump(position, RIGHT_DOWN, pieces)) {
      _possibleStepJumps(position, RIGHT_DOWN, pieces, moves);
    }
    return moves;
  }

  List<int> possibleMoves(int position, Map<int, int> pieces) {
    List<int> moves = [];
    _possibleStepMoves(position, LEFT_UP, pieces, moves);
    _possibleStepMoves(position, LEFT_DOWN, pieces, moves);
    _possibleStepMoves(position, RIGHT_UP, pieces, moves);
    _possibleStepMoves(position, RIGHT_DOWN, pieces, moves);
    return moves;
  }

  void _possibleStepMoves(int origin, int step, Map<int, int> pieces, List<int> moves) {
    int target = origin;
    while (true) {
      target = Piece.stepMove(target, step);
      if (target == null) return;
      if (pieces.containsKey(target)) return;
      moves.add(target);
    }
  }

  void _possibleStepJumps(int origin, int step, Map<int, int> pieces, List<int> moves) {
    int target = origin;
    while (true) {
      target = Piece.stepMove(target, step);
      if (target == null) return;
      if (pieces.containsKey(target)) break;
    }
    while (true) {
      target = Piece.stepMove(target, step);
      if (target == null) return;
      if (pieces.containsKey(target)) return;
      moves.add(target);
    }
  }
}
