import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:hungry_dame/src/components/chessboard/chessboard.dart';
import 'package:hungry_dame/src/components/victory_modal.dart';

@Component(
    selector: 'my-app',
    directives: const [materialDirectives, ChessBoardComponent, VictoryModal],
    providers: const [materialProviders],
    template: """
    <h1>Hungry dame</h1>
    <chessboard></chessboard>
    <recommendations></recommendations>
    <victory-modal></victory-modal>
  """,
    styles: const [
      """
    :host{
      opacity: 1;
      display: block;
    }
  """
    ])
class AppComponent {}
