import 'package:angular/di.dart';
import 'package:hungry_dame/src/model/arrangement.dart';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/model/state.dart';
import 'package:hungry_dame/src/services/notificator.dart';

@Injectable()
class CurrentState extends State {
  final Notificator activePieceChanged = new Notificator();
  final Notificator nextRoundChanged = new Notificator();
  final Notificator possiblesChanged = new Notificator();
  final Notificator gameEndedChanged = new Notificator();
  Piece activePiece;
  int activePiecePosition;
  List<int> possibleFields;
  List<int> playablePieces = [];

  CurrentState() {
    reset();
  }
  void reset() {
    isForced = false;
    chainedPiece = null;
    blackIsPlaying = false;
    pieces = Arrangement.start();
//    pieces = Arrangement.testChained();
//    pieces = Arrangement.testDame();
//    pieces = Arrangement.testEnd();
//    pieces = Arrangement.testPromote();
//    pieces = Arrangement.testPredict();
    playablePieces=findPlayablePieces();
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
    playablePieces=findPlayablePieces();
    setActivePiece(null, null);
    nextRoundChanged.notify();
  }

  void chainedMove(int position, Piece piece) {
    chainedPiece = position;
    playablePieces=findPlayablePieces();
    setActivePiece(piece, position);
    nextRoundChanged.notify();
  }

  void move(Piece piece, int from, int to) {
    if (isForced) {
      removePieceInLine(from, to);
    }
    pieces[to] = piece.code;
    pieces.remove(from);
    if (piece.shouldPromote(to)) {
      piece.promote(to, pieces);
    }
    if (isForced && piece.isForced(to, pieces)) {
      chainedMove(to, piece);
    } else {
      nextPlayer();
    }
  }
}
