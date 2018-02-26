library recommendations;

import 'dart:async';
import 'package:angular/core.dart';
import 'package:angular/src/common/directives.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:hungry_dame/src/services/current_state.dart';
import 'package:hungry_dame/src/services/predict_result_state.dart';
import 'package:hungry_dame/src/services/predictor_gateway.dart';

part 'prediction.dart';

@Component(
    selector: "recommendations",
    directives: const [MaterialButtonComponent, NgIf, NgFor],
    template: """
    <div class='recommendation_switch' (click)='onSwitch()'></div>
    <template [ngIf]='isVisible'>
      <material-button raised (click)='orderResults()'>Results</material-button>
      <material-button raised (click)='stopPredict()'>Kill</material-button>
      <div class='step_counter'>Depth: {{predictor.currentDepth}} Step: {{predictor.currentStep}}</div>
      <div *ngFor='let prediction of recommendations'>
        {{lastPieceLabel(prediction)}} to {{prediction.lastMoveTarget}}: {{scoreLabel(prediction)}}
      </div>
    </template>
  """,
    styles: const [
      """
    .step_counter{
      border-bottom: 1px solid black;
    }
    .recommendation_switch{
      height: 50px;
      width:50px;
      position:absolute;
      right:0;
      top:0;
    }
    """
    ])
class RecommendationsComponent {
  final PredictorGateway predictor;
  final ChangeDetectorRef changeDetector;
  final CurrentState currentState;
  bool isVisible = true;

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

  String get currentDepth => predictor.currentDepth.toStringAsFixed(2);
  String scoreLabel(PredictResultState state) {
    if (state.score > 1000) return "bílý MAT ${state.stepsToMat}";
    if (state.score < -1000) return "černý MAT ${state.stepsToMat}";
    return state.score.toStringAsFixed(2);
  }

  Iterable<PredictResultState> get recommendations {
    List<PredictResultState> recommendations = predictor.predictions.toList()
      ..sort((PredictResultState a, PredictResultState b) {
        return a.score.compareTo(b.score);
      });
    if (!currentState.blackIsPlaying) {
      return recommendations.reversed;
    }
    return recommendations;
  }

  void orderResults() {
    predictor.orderResult();
  }

  void stopPredict() {
    predictor.stop();
  }

  void onSwitch() {
    isVisible = !isVisible;
    changeDetector.detectChanges();
  }
}
