part of model;

class Piece implements AbstractPiece {
  final bool isBlack;
  final bool isDame = false;
  final int code;
//  int position;

  const Piece({bool black: false, int code: 0})
      : isBlack = black,
        code = code == 0 ? (black ? BLACK_PIECE_CODE : WHITE_PIECE_CODE) : code;

  bool get isWhite => !isBlack;

  String get letter => isBlack ? BLACK_PIECE : WHITE_PIECE;

  bool isForced(int position, Int8List pieces) {
    if (canLeftJump(position, pieces)) return true;
    if (canRightJump(position, pieces)) return true;
    return false;
  }

  List<int> possibleForcedMoves(int position, Int8List pieces) {
    List<int> moves = [];
    if (canLeftJump(position, pieces)) {
      if (isBlack) {
        moves.add(LEFT_DOWN_NEIGHBOURS[LEFT_DOWN_NEIGHBOURS[position]]);
      } else {
        moves.add(LEFT_UP_NEIGHBOURS[LEFT_UP_NEIGHBOURS[position]]);
      }
    }
    if (canRightJump(position, pieces)) {
      if (isBlack) {
        moves.add(RIGHT_DOWN_NEIGHBOURS[RIGHT_DOWN_NEIGHBOURS[position]]);
      } else {
        moves.add(RIGHT_UP_NEIGHBOURS[RIGHT_UP_NEIGHBOURS[position]]);
      }
    }
    return moves;
  }

  List<int> possibleMoves(int position, Int8List pieces) {
    List<int> moves = [];
    if (isBlack) {
      int target = LEFT_DOWN_NEIGHBOURS[position];
      if (target != -1) {
        if (pieces[target]==0) {
          moves.add(target);
        }
      }
      target = RIGHT_DOWN_NEIGHBOURS[position];
      if (target != -1) {
        if (pieces[target]==0) {
          moves.add(target);
        }
      }
    } else {
      int target = LEFT_UP_NEIGHBOURS[position];
      if (target != -1) {
        if (pieces[target]==0) {
          moves.add(target);
        }
      }
      target = RIGHT_UP_NEIGHBOURS[position];
      if (target != -1) {
        if (pieces[target]==0) {
          moves.add(target);
        }
      }
    }
    return moves;
  }

//  static int leftUpMove(int origin) {
//    if (origin < 8 || origin % 8 == 0) return null;
//    return origin + LEFT_UP;
//  }
//
//  static int leftDownMove(int origin) {
//    if (origin > 55 || origin % 8 == 0) return null;
//    return origin + LEFT_DOWN;
//  }
//
//  static int rightUpMove(int origin) {
//    if (origin < 8 || origin % 8 == 7) return null;
//    return origin + RIGHT_UP;
//  }
//
//  static int rightDownMove(int origin) {
//    if (origin > 55 || origin % 8 == 7) return null;
//    return origin + RIGHT_DOWN;
//  }

//  static int stepMove(int origin, int step) {
//    if (step > 0) {
//      // DOWN
//      if (origin > 55) return null;
//    } else {
//      // UP
//      if (origin < 8) return null;
//    }
//    int originRow = (origin / 8).floor();
//    int target = origin + step;
//    int targetRow = (target / 8).floor();
//    if ((originRow - targetRow).abs() != 1) return null;
//    return target;
//  }
//  static int stepMove(int origin, List<int> neighbours) {
//    int target = neighbours[origin];
//    if(target<0) null;
//    return target;
//  }
//  Piece getPieceAt(int position) => SPECIES[pieces[position]];

  bool canLeftJump(int origin, Int8List pieces) {
    int target;
    if (isBlack) {
      target = LEFT_DOWN_NEIGHBOURS[origin];
      if (target == -1) return false;
      Piece neighbour = SPECIES[pieces[target]];
      if (neighbour == null) return false;
      if (neighbour.isBlack) {
        return false;
      } else {
        target = LEFT_DOWN_NEIGHBOURS[target];
        if (target == -1) return false;
        return pieces[target]==0;
      }
    } else {
      target = LEFT_UP_NEIGHBOURS[origin];
      if (target == -1) return false;
      Piece neighbour = SPECIES[pieces[target]];
      if (neighbour == null) return false;
      if (neighbour.isWhite) {
        return false;
      } else {
        target = LEFT_UP_NEIGHBOURS[target];
        if (target == -1) return false;
        return pieces[target]==0;
      }
    }
  }

  bool canRightJump(int origin, Int8List pieces) {
    int target;
    if (isBlack) {
      target = RIGHT_DOWN_NEIGHBOURS[origin];
      if (target == -1) return false;
      Piece neighbour = SPECIES[pieces[target]];
      if (neighbour == null) return false;
      if (neighbour.isBlack) {
        return false;
      } else {
        target = RIGHT_DOWN_NEIGHBOURS[target];
        if (target == -1) return false;
        return pieces[target]==0;
      }
    } else {
      target = RIGHT_UP_NEIGHBOURS[origin];
      if (target == -1) return false;
      Piece neighbour = SPECIES[pieces[target]];
      if (neighbour == null) return false;
      if (neighbour.isWhite) {
        return false;
      } else {
        target = RIGHT_UP_NEIGHBOURS[target];
        if (target == -1) return false;
        return pieces[target]==0;
      }
    }
  }

  void promote(int position, Int8List pieces) {
    if (isDame) return;
    pieces[position] = isBlack ? BLACK_DAME_CODE : WHITE_DAME_CODE;
  }

  bool shouldPromote(int position) {
    if (isDame) return false;
    if (isBlack) {
      return position > 27;
    } else {
      return position < 4;
    }
  }
}
