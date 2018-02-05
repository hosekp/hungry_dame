import 'package:angular/di.dart';
import 'package:hungry_dame/src/model/model.dart';
import 'package:hungry_dame/src/services/notificator.dart';

@Injectable()
class CurrentState{
  Arrangement arrangement = new Arrangement.start();
  final Notificator activePieceChanged = new Notificator();
  final Notificator blackIsPlayingChanged = new Notificator();

  int _activePiece;

  int get activePiece => _activePiece;

  void set activePiece(int activePiece) {
    _activePiece = activePiece;
    activePieceChanged.notify();
  }
  bool _blackIsPlaying=false;

  bool get blackIsPlaying => _blackIsPlaying;

  void set blackIsPlaying(bool blackIsPlaying) {
    _blackIsPlaying = blackIsPlaying;
    blackIsPlayingChanged.notify();
  }
}