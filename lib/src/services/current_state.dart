import 'package:angular/di.dart';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/notificator.dart';
import 'package:hungry_dame/src/services/state.dart';

@Injectable()
class CurrentState extends State {
  Arrangement arrangement;
  final PossibleFinder possibleFinder = new PossibleFinder();
  final Notificator activePieceChanged = new Notificator();
  final Notificator nextRoundChanged = new Notificator();
  final Notificator possiblesChanged = new Notificator();
  final Notificator gameEndedChanged = new Notificator();
  Piece activePiece;
  List<int> possibleFields;

  CurrentState() {
    possibleFinder.state = this;
    reset();
  }
  void reset() {
    isForced = false;
    chainedPiece = null;
    blackIsPlaying = false;
//    arrangement = new Arrangement.start();
//    arrangement = new Arrangement.testChained();
    arrangement = new Arrangement.testDame();
//    arrangement = new Arrangement.testEnd();
//    arrangement = new Arrangement.testPromote();
    findPlayablePieces();
    setActivePiece(null);
    nextRoundChanged.notify();
//    possiblesChanged.announce("possibleChanged","");
  }

  void setActivePiece(Piece activePiece) {
    if (playablePieces.contains(activePiece)) {
      this.activePiece = activePiece;
      findPossibles();
      activePieceChanged.notify();
      return;
    }
    this.activePiece = null;
    findPossibles();
    activePieceChanged.notify();
  }

  void findPossibles() {
    if (activePiece == null) {
      possibleFields = [];
      possiblesChanged.notify();
      return;
    }
    possibleFields = findPossiblesForPiece(activePiece);
    possiblesChanged.notify();
  }

  void nextPlayer() {
    isForced = false;
    chainedPiece = null;
    if (isEndOfGame()) {
      gameEndedChanged.notify();
      return;
    }
    blackIsPlaying = !blackIsPlaying;
    findPlayablePieces();
    setActivePiece(null);
    nextRoundChanged.notify();
  }

  void chainedMove(Piece piece) {
    chainedPiece = piece;
    findPlayablePieces();
    setActivePiece(piece);
    nextRoundChanged.notify();
  }

  void move(Piece piece, int position) {
    if (isForced) {
      removePieceInLine(piece.position, position, arrangement);
    }
    arrangement.pieces[position] = piece;
    arrangement.pieces.remove(piece.position);
    piece.position = position;
    if (piece.shouldPromote()) {
      piece = piece.promote(arrangement);
    }
    if (isForced && piece.isForced(arrangement)) {
      chainedMove(piece);
    } else {
      nextPlayer();
    }
  }
}
