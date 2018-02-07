library recommendations;

import 'dart:async';
import 'package:angular/core.dart';
import 'package:angular/src/common/directives.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:hungry_dame/src/services/current_state.dart';
import 'package:hungry_dame/src/services/predicted_state.dart';
import 'package:hungry_dame/src/services/predictor.dart';

part 'prediction.dart';

@Component(
  selector: "recommendations",
  directives: const [MaterialButtonComponent,NgFor],
  template: """
    <material-button raised (click)='predict()'>Predict</material-button>
    <div *ngFor='let prediction of recommendations'>
      {{lastPieceLabel(prediction)}} to {{prediction.lastMoveTarget}}: {{scoreLabel(prediction)}}
    </div>
  """
)
class RecommendationsComponent{
  final Predictor predictor;
  final ChangeDetectorRef changeDetector;
  final CurrentState currentState;

  RecommendationsComponent(this.predictor, this.changeDetector, this.currentState){
    predictor.onPrediction.add((){
      changeDetector.detectChanges();
    });
    new Future.delayed(const Duration(seconds: 1)).then((_){
      currentState.nextRoundChanged.add((){
        predictor.predict(currentState);
      });
      predictor.predict(currentState);
    });
  }
  String lastPieceLabel(PredictedState state)=> "${state.lastMovedPiece.letter}${state.lastMovedPiece.position}";
  String scoreLabel(PredictedState state){
    if(state.score>1000) return "bílý MAT ${stepsToMat(state)}";
    if(state.score<-1000) return "černý MAT ${stepsToMat(state)}";
    return state.score.toStringAsFixed(2);
  }

  Iterable<PredictedState> get recommendations{
    List<PredictedState> recommendations = predictor.predictions.toList()..sort((PredictedState a, PredictedState b) {
      if (a.score.abs() > 10000 && b.score.abs() > 10000) return b.score.compareTo(a.score);
      return a.score.compareTo(b.score);
    });
    if (!currentState.blackIsPlaying) {
      return recommendations.reversed;
    }
    return recommendations;
  }

  void predict(){
    predictor.predict(currentState);
  }
  int stepsToMat(PredictedState state) => (state.score/2000000+0.5).abs().floor();
}