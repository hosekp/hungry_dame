import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:hungry_dame/src/components/chessboard/chessboard.dart';

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [materialDirectives, ChessBoardComponent],
  providers: const [materialProviders],
)
class AppComponent {
}
