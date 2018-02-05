part of chessboard;

@Component(
    selector: "piece",
    template: """
    
  """,
    host: const {
      '(click)': "onClick()",
      '[class.black]': 'piece?.isBlack == true',
      '[class.white]': 'piece?.isWhite == true',
      '[class.dame]': 'piece?.isDame == true',
      '[class.playable]': 'isPlayable',
      '[class.active]': 'isActive'
    },
    styles: const [
      """
      :host{
        border-radius: 1000000px;
        border: 2px solid #aaa;
        display: none;
        width: 60%;
        height: 60%;
        position:relative;
        left: 20%;
        top: 20%;
        background-color: white;
      }
      :host(.white){
        display: block;
      }
      :host(.black){
        background-color: black;
        display: block;
      }
      :host(.active){
        border-width: 5px;
        margin: -3px;
      }
      :host(.playable){
        border-color: red;
      }
      :host(.dame){
        width: 80%;
        height: 80%;
        left: 10%;
        top: 10%;
      }
    """
    ])
class PieceComponent {
  @Input()
  Piece piece;
  final ChangeDetectorRef changeDetector;
  final CurrentState currentState;

  PieceComponent(this.currentState, this.changeDetector) {
    currentState.activePieceChanged.add(() {
      changeDetector.markForCheck();
      changeDetector.detectChanges();
    });
  }
  bool get isActive => currentState.activePiece == piece;
  bool get isPlayable => currentState.playablePieces.contains(piece);

  void onClick() {
    currentState.setActivePiece(piece);
  }
}
