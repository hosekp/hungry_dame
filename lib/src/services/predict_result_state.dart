class PredictResultState {
  final double score;
  final String lastMovePieceLetter;
  final int lastMoveOrigin;
  final int lastMoveTarget;

  PredictResultState(this.score, this.lastMovePieceLetter, this.lastMoveOrigin, this.lastMoveTarget);

//  int get stepsToMat {
////    print("$lastMovePieceLetter$lastMoveOrigin=>$lastMoveTarget = $score (${score / 2000000 + 0.5})");
//    if (score > 0) {
//      return ((1000000 - score) / 2 + 0.5).floor();
//    } else {
//      return ((1000000 + score) / 2 + 0.5).floor();
//    }
//  }
  int get stepsToMat => (1000000 - score.abs()).floor();
//    print("$lastMovePieceLetter$lastMoveOrigin=>$lastMoveTarget = $score (${score / 2000000 + 0.5})");
}
