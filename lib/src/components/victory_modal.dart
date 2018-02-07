import 'package:angular/core.dart';
import 'package:angular/src/common/directives.dart';
import 'package:angular_components/angular_components.dart';
import 'package:hungry_dame/src/services/current_state.dart';

@Component(
    selector: "victory-modal",
    directives: const[MaterialDialogComponent,MaterialButtonComponent,ModalComponent,AutoFocusDirective,NgIf],
    template: """
    <modal [visible]='isVisible' >
      <material-dialog>
        <h3 header>Vítězství</h3>
        <p>
          Vítězství {{winnerLabel}} hráče
        </p>
        <div footer>
          <material-button autoFocus
                           clear-size
                           raised
                           class="blue"
                           (trigger)="close()">
            Zavřít
          </material-button>
        </div>
      </material-dialog>
    </modal>
    """,
//    host: const {"[ngIf]": "isVisible"},
    styles: const [
    ])
class VictoryModal {
  bool isBlackWinner;
  bool isVisible=false;
  final CurrentState currentState;
  final ChangeDetectorRef changeDetector;

  VictoryModal(this.currentState, this.changeDetector){
    isBlackWinner=currentState.blackIsPlaying;
    currentState.gameEndedChanged.add((){
      if(!currentState.isEndOfGame()) return;
      isVisible=true;
      isBlackWinner=currentState.blackIsPlaying;
      changeDetector.detectChanges();
    });
  }

  void close(){
    isVisible=false;
    currentState.reset();
  }

  String get winnerLabel => isBlackWinner ? "Cerného" : "Bílého";
}
