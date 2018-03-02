part of chessboard;

@Component(
    selector: "chessfield",
    directives: const [PieceComponent, NgIf],
    template: """
    <div *ngIf='isBlackField' class='label-index'>{{position}}</div>
    <piece [piece]='piece' [position]='position'></piece>
  """,
    host: const {
      '(click)': "onClick()",
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
class ChessFieldComponent implements OnInit{
  @Input()
  int index;
  final CurrentState currentState;
  final ChangeDetectorRef changeDetector;
  bool isBlackField;
  int position;

  ChessFieldComponent(this.currentState, this.changeDetector) {
    currentState.possiblesChanged.add(() {
      changeDetector.detectChanges();
    });
  }

  bool get isPossibleField {
    if(!isBlackField) return false;
    if (currentState.possibleFields == null) return false;
    return currentState.possibleFields.contains(position);
  }

  Piece get piece => isBlackField?currentState.getPieceAt(position):null;

  void onClick() {
    if(!isBlackField) return;
    if (!currentState.possibleFields.contains(position)) return;
    currentState.move(currentState.activePiece, currentState.activePiecePosition, position);
  }
  @override
  void ngOnInit() {
    position=(index/2).floor();
    isBlackField = ((index / 8).floor() + index) % 2 == 1;
  }
}
