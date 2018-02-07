part of model;

class Dame extends Piece implements AbstractPiece {
  bool isDame = true;
  Dame({int pos, bool black: false}) : super(black: black, pos: pos);

  String get letter => isBlack?"B":"W";

  bool isForced(Arrangement arrangement) {
    if (canStepJump(position, Piece.LEFT_UP, arrangement)) return true;
    if (canStepJump(position, Piece.LEFT_DOWN, arrangement)) return true;
    if (canStepJump(position, Piece.RIGHT_UP, arrangement)) return true;
    if (canStepJump(position, Piece.RIGHT_DOWN, arrangement)) return true;
    return false;
  }

  bool canStepJump(int origin, int step, Arrangement arrangement) {
    int target = origin;
    while (true) {
      target = Piece.stepMove(target, step);
      if (target == null) return false;
      if (arrangement.pieces.containsKey(target)) {
        Piece neighbour = arrangement.pieces[target];
        if (neighbour.isBlack == isBlack) return false;
        target = Piece.stepMove(target, step);
        if (target == null) return false;
        return !arrangement.pieces.containsKey(target);
      }
    }
  }

  List<int> possibleForcedMoves(Arrangement arrangement) {
    List<int> moves = [];
    if (canStepJump(position, Piece.LEFT_UP, arrangement)){
      _possibleStepJumps(position, Piece.LEFT_UP, arrangement, moves);
    }
    if (canStepJump(position, Piece.LEFT_DOWN, arrangement)){
      _possibleStepJumps(position, Piece.LEFT_DOWN, arrangement, moves);
    }
    if (canStepJump(position, Piece.RIGHT_UP, arrangement)){
      _possibleStepJumps(position, Piece.RIGHT_UP, arrangement, moves);
    }
    if (canStepJump(position, Piece.RIGHT_DOWN, arrangement)){
      _possibleStepJumps(position, Piece.RIGHT_DOWN, arrangement, moves);
    }
    return moves;
  }
  List<int> possibleMoves(Arrangement arrangement) {
    List<int> moves = [];
    _possibleStepMoves(position, Piece.LEFT_UP, arrangement, moves);
    _possibleStepMoves(position, Piece.LEFT_DOWN, arrangement, moves);
    _possibleStepMoves(position, Piece.RIGHT_UP, arrangement, moves);
    _possibleStepMoves(position, Piece.RIGHT_DOWN, arrangement, moves);
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
  void _possibleStepJumps(int origin,int step,Arrangement arrangement, List<int> moves){
    int target = origin;
    while (true) {
      target = Piece.stepMove(target, step);
      if(target==null) return;
      if (arrangement.pieces.containsKey(target)) break;
    }
    while(true){
      target = Piece.stepMove(target, step);
      if(target==null) return;
      if (arrangement.pieces.containsKey(target)) return;
      moves.add(target);
    }
  }
  Piece copy(){
    return new Dame(pos:position,black: isBlack);
  }
}
