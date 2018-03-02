part of model;

class Dame extends Piece implements AbstractPiece {
  final bool isDame = true;
  const Dame({bool black: false}) : super(black: black, code: black ? BLACK_DAME_CODE : WHITE_DAME_CODE);

  String get letter => isBlack ? BLACK_DAME : WHITE_DAME;

  bool isForced(int position, Int8List pieces) {
    if (canStepJump(position, LEFT_UP_NEIGHBOURS, pieces)) return true;
    if (canStepJump(position, LEFT_DOWN_NEIGHBOURS, pieces)) return true;
    if (canStepJump(position, RIGHT_UP_NEIGHBOURS, pieces)) return true;
    if (canStepJump(position, RIGHT_DOWN_NEIGHBOURS, pieces)) return true;
    return false;
  }

  bool canStepJump(int origin, List<int> neighbours, Int8List pieces) {
    int target = origin;
    while (true) {
      target = neighbours[target];
      if (target == -1) return false;
      if (pieces[target]!=0) {
        Piece neighbour = SPECIES[pieces[target]];
        if (neighbour.isBlack == isBlack) return false;
        target = neighbours[target];
        if (target == -1) return false;
        return pieces[target]==0;
      }
    }
  }

  List<int> possibleForcedMoves(int position, Int8List pieces) {
    List<int> moves = [];
    if (canStepJump(position, LEFT_UP_NEIGHBOURS, pieces)) {
      _possibleStepJumps(position, LEFT_UP_NEIGHBOURS, pieces, moves);
    }
    if (canStepJump(position, LEFT_DOWN_NEIGHBOURS, pieces)) {
      _possibleStepJumps(position, LEFT_DOWN_NEIGHBOURS, pieces, moves);
    }
    if (canStepJump(position, RIGHT_UP_NEIGHBOURS, pieces)) {
      _possibleStepJumps(position, RIGHT_UP_NEIGHBOURS, pieces, moves);
    }
    if (canStepJump(position, RIGHT_DOWN_NEIGHBOURS, pieces)) {
      _possibleStepJumps(position, RIGHT_DOWN_NEIGHBOURS, pieces, moves);
    }
    return moves;
  }

  List<int> possibleMoves(int position, Int8List pieces) {
    List<int> moves = [];
    _possibleStepMoves(position, LEFT_UP_NEIGHBOURS, pieces, moves);
    _possibleStepMoves(position, LEFT_DOWN_NEIGHBOURS, pieces, moves);
    _possibleStepMoves(position, RIGHT_UP_NEIGHBOURS, pieces, moves);
    _possibleStepMoves(position, RIGHT_DOWN_NEIGHBOURS, pieces, moves);
    return moves;
  }

  void _possibleStepMoves(int origin, List<int> neighbours, Int8List pieces, List<int> moves) {
    int target = origin;
    while (true) {
      target = neighbours[target];
      if (target == -1) return;
      if (pieces[target]!=0) return;
      moves.add(target);
    }
  }

  void _possibleStepJumps(int origin, List<int> neighbours, Int8List pieces, List<int> moves) {
    int target = origin;
    while (true) {
      target = neighbours[target];
      if (target == -1) return;
      if (pieces[target]!=0) break;
    }
    while (true) {
      target = neighbours[target];
      if (target == -1) return;
      if (pieces[target]!=0) return;
      moves.add(target);
    }
  }
}
