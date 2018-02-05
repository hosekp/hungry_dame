part of model;

class Dame extends Piece{
  bool isDame = true;

  bool isForced(Arrangement arrangement) {
    return false;
  }
}