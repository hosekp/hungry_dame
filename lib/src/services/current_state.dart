import 'package:angular/di.dart';
import 'package:hungry_dame/src/model/model.dart';

@Injectable()
class CurrentState{
  Arrangement arrangement = new Arrangement.start();
}