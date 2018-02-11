import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:hungry_dame/src/isolates/message_bus.dart';
import 'package:hungry_dame/src/isolates/predictor_job.dart';
import 'package:hungry_dame/src/services/predicted_state.dart';
import 'package:hungry_dame/src/services/state.dart';

class PredictorIsolate {
  SendPort portToMain;
  ReceivePort portFromMain = new ReceivePort();
  ListQueue<PredictedState> stateQueue;
  PredictorJob current;

  void init(SendPort sendPort) {
    portToMain = sendPort;
    sendPort.send(portFromMain.sendPort);
    portFromMain.listen((rawMessage) {
//      print("Message from Main: $rawMessage");
      predict(MessageBus.fromMessage(rawMessage));
    });
  }

  void predict(State currentState) {
//    print("PredictorIsolate.predict(${currentState.id})");
    current = new PredictorJob(this);
    current.predict(currentState);
  }


  Future delay() => new Future.delayed(const Duration(milliseconds: 10));

  void print(String message) {
    portToMain.send(message);
  }

}
