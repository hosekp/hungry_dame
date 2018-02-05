import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:hungry_dame/src/components/chessboard/chessboard.dart';

@Component(
  selector: 'my-app',
  directives: const [materialDirectives, ChessBoardComponent],
  providers: const [materialProviders],
  template: """
    <h1>Hungry dame</h1>
    <chessboard></chessboard>
    <recommendations></recommendations>
  """,
  styles: const["""
  
  """]
)
class AppComponent {
}
