import 'package:angular/di.dart';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/notificator.dart';
import 'package:hungry_dame/src/services/state.dart';

@Injectable()
class CurrentState extends State {
  Arrangement arrangement;
  final PossibleFinder possibleFinder = new PossibleFinder();
  final Notificator activePieceChanged = new Notificator();
  final Notificator blackIsPlayingChanged = new Notificator();
  final Notificator possiblesChanged = new Notificator();
  Piece activePiece;
  List<int> possibleFields;

  CurrentState() {
    possibleFinder.state = this;
    arrangement = new Arrangement.start();
    findPlayablePieces();
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

  void setBlackIsPlaying(bool blackIsPlaying) {
    this.blackIsPlaying = blackIsPlaying;
    blackIsPlayingChanged.notify();
  }

  void findPossibles(){
    if(activePiece==null){
      possiblesChanged.notify();
      return;
    }
    if(isForced){
      possibleFields=activePiece.possibleForcedMoves(arrangement);
    }else{
      possibleFields=activePiece.possibleMoves(arrangement);
    }
    possiblesChanged.notify();
  }
}
