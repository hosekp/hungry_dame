class PredictResultState{
  final double score;
  final String lastMovePieceLetter;
  final int lastMoveOrigin;
  final int lastMoveTarget;

  PredictResultState(this.score, this.lastMovePieceLetter, this.lastMoveOrigin, this.lastMoveTarget);

  int get stepsToMat {
//    print("$lastMovePieceLetter$lastMoveOrigin=>$lastMoveTarget = $score (${score / 2000000 + 0.5})");
    return (score / 2000000 + 0.5).abs().floor();
  }

}