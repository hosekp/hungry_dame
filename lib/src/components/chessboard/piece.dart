part of chessboard;

@Component(
    selector: "piece",
    template: """
    
  """,
    host: const {
      '(click)': "onClick()",
      '[class.black]': 'isBlack',
      '[class.active]': 'isActive'
    },
    styles: const [
      """
      :host{
        border-radius: 1000000px;
        border: 2px solid #aaa;
        display: block;
        width: 60%;
        height: 60%;
        position:relative;
        left: 20%;
        top: 20%;
        background-color: white;
      }
      :host(.black){
        background-color: black;
      }
      :host(.active){
        border: 5px solid red;
      }
    """
    ])
class PieceComponent {
  @Input()
  int position;
  @Input("black")
  bool isBlack;
  final ChangeDetectorRef changeDetector;
  final CurrentState currentState;

  PieceComponent(this.currentState, this.changeDetector) {
    currentState.activePieceChanged.add(() {
      changeDetector.markForCheck();
      changeDetector.detectChanges();
    });
  }
  bool get isActive => currentState.activePiece == position;

  void onClick() {
    if (currentState.blackIsPlaying != isBlack) {
      currentState.activePiece = null;
      return;
    }
    currentState.activePiece = position;
  }
}
