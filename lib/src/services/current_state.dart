import 'package:angular/di.dart';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/notificator.dart';
import 'package:hungry_dame/src/services/state.dart';

@Injectable()
class CurrentState extends State {
  Arrangement arrangement;
  final Notificator activePieceChanged = new Notificator();
  final Notificator nextRoundChanged = new Notificator();
  final Notificator possiblesChanged = new Notificator();
  final Notificator gameEndedChanged = new Notificator();
  Piece activePiece;
  int activePiecePosition;
  List<int> possibleFields;

  CurrentState() {
    reset();
  }
  void reset() {
    isForced = false;
    chainedPiece = null;
    blackIsPlaying = false;
//    arrangement = new Arrangement.start();
//    arrangement = new Arrangement.testChained();
//    arrangement = new Arrangement.testDame();
//    arrangement = new Arrangement.testEnd();
//    arrangement = new Arrangement.testPromote();
    arrangement = new Arrangement.testPredict();
    findPlayablePieces();
    setActivePiece(null, null);
    nextRoundChanged.notify();
//    possiblesChanged.announce("possibleChanged","");
  }

  void setActivePiece(Piece activePiece, int position) {
    if (playablePieces.contains(position)) {
      this.activePiece = activePiece;
      this.activePiecePosition = position;
      findPossibles();
      activePieceChanged.notify();
      return;
    }
    this.activePiece = null;
    this.activePiecePosition = null;
    findPossibles();
    activePieceChanged.notify();
  }

  void findPossibles() {
    if (activePiece == null) {
      possibleFields = [];
      possiblesChanged.notify();
      return;
    }
    possibleFields = findPossiblesForPiece(activePiecePosition);
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
    setActivePiece(null, null);
    nextRoundChanged.notify();
  }

  void chainedMove(int position, Piece piece) {
    chainedPiece = position;
    findPlayablePieces();
    setActivePiece(piece, position);
    nextRoundChanged.notify();
  }

  void move(Piece piece, int from, int to) {
    if (isForced) {
      removePieceInLine(from, to, arrangement);
    }
    arrangement.pieces[to] = piece.code;
    arrangement.pieces.remove(from);
    if (piece.shouldPromote(to)) {
      piece.promote(to, arrangement);
    }
    if (isForced && piece.isForced(to, arrangement)) {
      chainedMove(to, piece);
    } else {
      nextPlayer();
    }
  }
}
