part of chessboard;

@Component(
    selector: "piece",
    template: """
     <div class="dame-inner"></div>
  """,
    host: const {
      '(click)': "onClick()",
      '[class.black]': 'piece?.isBlack == true',
      '[class.white]': 'piece?.isBlack == false',
      '[class.dame]': 'isDame',
      '[class.playable]': 'isPlayable',
      '[class.active]': 'isActive'
    },
    styleUrls: const [
      "piece.css"
    ])
class PieceComponent {
  @Input()
  Piece piece;
  @Input()
  int position;
  final ChangeDetectorRef changeDetector;
  final CurrentState currentState;

  PieceComponent(this.currentState, this.changeDetector) {
    currentState.activePieceChanged.add(() {
      changeDetector.markForCheck();
      changeDetector.detectChanges();
    });
  }
  bool get isActive => currentState.activePiecePosition == position;
  bool get isDame => piece?.isDame == true;
  bool get isPlayable => currentState.playablePieces.contains(position);

  void onClick() {
    currentState.setActivePiece(piece, position);
  }
}
