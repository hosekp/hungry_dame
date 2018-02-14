import 'dart:async';
import 'dart:isolate' as isolateLib;
import 'package:angular/di.dart';
import 'package:hungry_dame/src/services/current_state.dart';
import 'package:hungry_dame/src/isolates/message_bus.dart';
import 'package:hungry_dame/src/services/notificator.dart';
import 'package:hungry_dame/src/services/predict_result_state.dart';

@Injectable()
class Predictor {
  List<PredictResultState> predictions = [];
  Notificator onPrediction = new Notificator();
  int currentDepth = 0;
  int currentStep = 0;
  isolateLib.ReceivePort portFromIsolate = new isolateLib.ReceivePort();
  isolateLib.Isolate isolate;
  isolateLib.SendPort portToIsolate;
  isolateLib.ReceivePort onExit = new isolateLib.ReceivePort();

  Predictor() {
    portFromIsolate.listen(onResponse);
    onExit.listen((_){
      print("Isolate died: $_");
    });
    Uri uri = Uri.parse("/predictor_isolate.dart");
    isolateLib.Isolate
        .spawnUri(uri, [], portFromIsolate.sendPort, checked: true,errorsAreFatal: true,onError: onExit.sendPort)
        .then((isolateLib.Isolate freshIsolate) {
      isolate = freshIsolate;
    });
  }

  void predict(CurrentState currentState) {
    if (portToIsolate == null) {
      delay().then((_) {
        predict(currentState);
      });
      return;
    }
    portToIsolate.send(MessageBus.toInitMessage(currentState));
  }
  void stop(){
    portToIsolate.send({"stop":true});
  }

  void onResponse(rawMessage) {
    if(rawMessage is isolateLib.SendPort){
      portToIsolate = rawMessage;
    }
    if(rawMessage is String){
      print(rawMessage);
    }
    if (rawMessage is! List) return;
    predictions.clear();
    List<Map<String, dynamic>> messages = rawMessage;
    for (Map<String, dynamic> message in messages) {
      if (message["steps"] != null) {
        currentStep = message["steps"];
        currentDepth = message["depth"];
      } else {
        predictions.add(MessageBus.fromIsolateMessage(message));
      }
    }
    onPrediction.notify();
  }

  Future delay() => new Future.delayed(const Duration(milliseconds: 10));
}
