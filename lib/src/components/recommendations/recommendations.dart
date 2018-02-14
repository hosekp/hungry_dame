library recommendations;

import 'dart:async';
import 'package:angular/core.dart';
import 'package:angular/src/common/directives.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:hungry_dame/src/services/current_state.dart';
import 'package:hungry_dame/src/services/predict_result_state.dart';
import 'package:hungry_dame/src/services/predictor.dart';

part 'prediction.dart';

@Component(
    selector: "recommendations",
    directives: const [MaterialButtonComponent, NgFor],
    template: """
    <material-button raised (click)='predict()'>Predict</material-button>
    <div class='step_counter'>Depth: {{predictor.currentDepth}} Step: {{predictor.currentStep}}</div>
    <div *ngFor='let prediction of recommendations'>
      {{lastPieceLabel(prediction)}} to {{prediction.lastMoveTarget}}: {{scoreLabel(prediction)}}
    </div>
  """,
    styles: const [
      """
    .step_counter{
      border-bottom: 1px solid black;
    }
    """
    ])
class RecommendationsComponent {
  final Predictor predictor;
  final ChangeDetectorRef changeDetector;
  final CurrentState currentState;

  RecommendationsComponent(this.predictor, this.changeDetector, this.currentState) {
    predictor.onPrediction.add(() {
      changeDetector.detectChanges();
    });
    new Future.delayed(const Duration(seconds: 1)).then((_) {
      currentState.nextRoundChanged.add(() {
        predictor.predict(currentState);
      });
      predictor.predict(currentState);
    });
  }
  String lastPieceLabel(PredictResultState state) => "${state.lastMovePieceLetter}${state.lastMoveOrigin}";
  String scoreLabel(PredictResultState state) {
    if (state.score > 1000) return "bílý MAT ${state.stepsToMat}";
    if (state.score < -1000) return "černý MAT ${state.stepsToMat}";
    return state.score.toStringAsFixed(2);
  }

  Iterable<PredictResultState> get recommendations {
    List<PredictResultState> recommendations = predictor.predictions.toList()
      ..sort((PredictResultState a, PredictResultState b) {
        if(a.score.abs() > 10000){
          if(b.score.abs() > 10000 && a.score.sign == b.score.sign){
            return b.score.compareTo(a.score);
          }
        }
        return a.score.compareTo(b.score);
      });
    if (!currentState.blackIsPlaying) {
      return recommendations.reversed;
    }
    return recommendations;
  }

  void predict() {
    predictor.predict(currentState);
  }
}
