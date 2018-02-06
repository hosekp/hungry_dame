part of model;

class Dame extends Piece{
  bool isDame = true;

//  bool isForced(Arrangement arrangement) {
//    return false;
//  }

  bool canStepJump(int origin, int step,Arrangement arrangement){

  }
//  bool canLeftUpJump(int origin, Arrangement arrangement) {
//    int target;
//    if (isBlack) {
//      target = leftDownMove(origin);
//      if (target == null) return false;
//      Piece neighbour = arrangement.pieces[target];
//      if (neighbour == null) return false;
//      if (neighbour.isBlack) {
//        return false;
//      } else {
//        target = leftDownMove(target);
//        if (target == null) return false;
//        return !arrangement.pieces.containsKey(target);
//      }
//    } else {
//      target = leftUpMove(origin);
//      if (target == null) return false;
//      Piece neighbour = arrangement.pieces[target];
//      if (neighbour == null) return false;
//      if (neighbour.isWhite) {
//        return false;
//      } else {
//        target = leftUpMove(target);
//        if (target == null) return false;
//        return !arrangement.pieces.containsKey(target);
//      }
//    }
//  }
//  bool canRightJump(int origin, Arrangement arrangement) {
//    int target;
//    if (isBlack) {
//      target = rightDownMove(origin);
//      if (target == null) return false;
//      Piece neighbour = arrangement.pieces[target];
//      if (neighbour == null) return false;
//      if (neighbour.isBlack) {
//        return false;
//      } else {
//        target = rightDownMove(target);
//        if (target == null) return false;
//        return !arrangement.pieces.containsKey(target);
//      }
//    } else {
//      target = rightUpMove(origin);
//      if (target == null) return false;
//      Piece neighbour = arrangement.pieces[target];
//      if (neighbour == null) return false;
//      if (neighbour.isWhite) {
//        return false;
//      } else {
//        target = rightUpMove(target);
//        if (target == null) return false;
//        return !arrangement.pieces.containsKey(target);
//      }
//    }
//  }
}