import 'dart:isolate';

import 'package:hungry_dame/src/isolates/predictor_isolate.dart';

void main(List args,SendPort sendPort){
  new PredictorIsolate().init(sendPort);
}