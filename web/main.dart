import 'package:angular/core.dart';

import 'package:angular/src/platform/bootstrap.dart';
import 'package:hungry_dame/src/components/app_component.dart';
import 'package:hungry_dame/src/services/current_state.dart';

void main() {
  bootstrap(AppComponent, [provide(CurrentState, useValue: new CurrentState())]);
}
