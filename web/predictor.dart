import 'dart:isolate';

import 'package:hungry_dame/src/isolates/predictor.dart';

void main(List args,SendPort sendPort){
  new Predictor().init(sendPort);
}