part of chessboard;

@Component(
    selector: "chessfield",
    directives: const [PieceComponent, NgIf],
    template: """
    <div class='label-index'>{{index}}</div>
    <piece [piece]='piece'></piece>
  """,
    host: const {
      '(click)':"onClick()",
      '[class.black]': 'isBlackField',
      '[class.possible]': 'isPossibleField',
    },
    styles: const [
      """
    :host{
      height: 100px;
      width: 100px;
      display: block;
      float:left;
      background-color: beige;
    }
    :host(.black){
      background-color: #310;
    }
    :host(.possible){
      background-color: red;
    }
    .label-index{
      position: absolute;
    }
    :host(.black) .label-index{
      color: white;
    }
  """
    ])
class ChessFieldComponent {
  @Input()
  int index;
  final CurrentState currentState;
  final ChangeDetectorRef changeDetector;

  ChessFieldComponent(this.currentState, this.changeDetector) {
    currentState.possiblesChanged.add(() {
      changeDetector.detectChanges();
    });
  }

  bool get isBlackField => ((index / 8).floor() + index) % 2 == 1;
  bool get isPossibleField {
    if (currentState.possibleFields == null) return false;
    return currentState.possibleFields.contains(index);
  }

  Piece get piece => currentState.arrangement.pieces[index];

  void onClick(){
    if(!currentState.possibleFields.contains(index)) return;
    currentState.move(currentState.activePiece, index);
  }
}
