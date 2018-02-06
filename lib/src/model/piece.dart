part of model;

class Piece {
  bool isBlack = false;
  bool isDame = false;
  int position;
  Piece({bool black: false, int pos: null}) {
    isBlack = black;
    position = pos;
  }
  bool get isWhite => !isBlack;
  bool isForced(Arrangement arrangement) {
      if(canLeftJump(position, arrangement)) return true;
      if(canRightJump(position, arrangement)) return true;
    return false;
  }

  List<int> possibleForcedMoves(Arrangement arrangement) {
    List<int> moves = [];
    if(canLeftJump(position, arrangement)){
      if(isBlack){
        moves.add(leftDownMove(leftDownMove(position)));
      }else{
        moves.add(leftUpMove(leftUpMove(position)));
      }
    }
    if(canRightJump(position, arrangement)){
      if(isBlack){
        moves.add(rightDownMove(rightDownMove(position)));
      }else{
        moves.add(rightUpMove(rightUpMove(position)));
      }
    }
    return moves;
  }
  List<int> possibleMoves(Arrangement arrangement) {
    List<int> moves = [];
    if(isBlack){
      int target = leftDownMove(position);
      if (target!=null){
        if(!arrangement.pieces.containsKey(target)){
          moves.add(target);
        }
      }
      target = rightDownMove(position);
      if (target!=null){
        if(!arrangement.pieces.containsKey(target)){
          moves.add(target);
        }
      }
    }else{
      int target = leftUpMove(position);
      if (target!=null){
        if(!arrangement.pieces.containsKey(target)){
          moves.add(target);
        }
      }
      target = rightUpMove(position);
      if (target!=null){
        if(!arrangement.pieces.containsKey(target)){
          moves.add(target);
        }
      }
    }
    return moves;
  }

  static int leftUpMove(int origin) {
    if (origin < 8 || origin % 8 == 0) return null;
    return origin - 9;
  }

  static int leftDownMove(int origin) {
    if (origin > 55 || origin % 8 == 0) return null;
    return origin + 7;
  }

  static int rightUpMove(int origin) {
    if (origin < 8 || origin % 8 == 7) return null;
    return origin - 7;
  }

  static int rightDownMove(int origin) {
    if (origin > 55 || origin % 8 == 7) return null;
    return origin + 9;
  }
  static int stepMove(int origin,int step){
    if(step>0){ // DOWN
      if(origin > 55) return null;
    }else{  // UP
      if(origin < 8) return null;
    }
    int originRow = (origin/8).floor();
    int target = origin+step;
    int targetRow = (target/8).floor();
    if((originRow-targetRow).abs()!=1) return null;
    return target;
  }

  bool canLeftJump(int origin, Arrangement arrangement) {
    int target;
    if (isBlack) {
      target = leftDownMove(origin);
      if (target == null) return false;
      Piece neighbour = arrangement.pieces[target];
      if (neighbour == null) return false;
      if (neighbour.isBlack) {
        return false;
      } else {
        target = leftDownMove(target);
        if (target == null) return false;
        return !arrangement.pieces.containsKey(target);
      }
    } else {
      target = leftUpMove(origin);
      if (target == null) return false;
      Piece neighbour = arrangement.pieces[target];
      if (neighbour == null) return false;
      if (neighbour.isWhite) {
        return false;
      } else {
        target = leftUpMove(target);
        if (target == null) return false;
        return !arrangement.pieces.containsKey(target);
      }
    }
  }
  bool canRightJump(int origin, Arrangement arrangement) {
    int target;
    if (isBlack) {
      target = rightDownMove(origin);
      if (target == null) return false;
      Piece neighbour = arrangement.pieces[target];
      if (neighbour == null) return false;
      if (neighbour.isBlack) {
        return false;
      } else {
        target = rightDownMove(target);
        if (target == null) return false;
        return !arrangement.pieces.containsKey(target);
      }
    } else {
      target = rightUpMove(origin);
      if (target == null) return false;
      Piece neighbour = arrangement.pieces[target];
      if (neighbour == null) return false;
      if (neighbour.isWhite) {
        return false;
      } else {
        target = rightUpMove(target);
        if (target == null) return false;
        return !arrangement.pieces.containsKey(target);
      }
    }
  }
}
