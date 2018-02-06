part of chessboard;

@Component(
    selector: "piece",
    template: """
     <div class="dame-inner"></div>
  """,
    host: const {
      '(click)': "onClick()",
      '[class.black]': 'piece?.isBlack == true',
      '[class.white]': 'piece?.isWhite == true',
      '[class.dame]': 'isDame',
      '[class.playable]': 'isPlayable',
      '[class.active]': 'isActive'
    },
    styleUrls: const ["piece.css"])
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
  bool get isDame => piece?.isDame == true;
  bool get isPlayable => currentState.playablePieces.contains(piece);

  void onClick() {
    currentState.setActivePiece(piece);
  }
}
