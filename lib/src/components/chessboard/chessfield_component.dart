part of chessboard;

@Component(
  selector: "chessfield",
  directives: const [PieceComponent,NgIf],
  providers: const[CurrentState],
  template: """
    <piece class='white' *ngIf='hasWhitePiece'></piece>
    <piece class='black' *ngIf='hasBlackPiece'></piece>
  """,
    host: const {
      '[class.black]':'isBlackField',
    },
  styles: const ["""
    :host{
      height: 100px;
      width: 100px;
      display: block;
      float:left;
      background-color: beige;
    }
    :host(.black):{
      background-color: #310;
    }
  """]
)
class ChessFieldComponent{
  @Input()
  int index;
  final CurrentState currentState;

  ChessFieldComponent(this.currentState);

  bool get isBlackField {
    return ((index/8).floor()+index)%2==1;
  }
  bool get hasWhitePiece => currentState.arrangement.whiteIndices.contains(index);
  bool get hasBlackPiece => currentState.arrangement.blackIndices.contains(index);

}