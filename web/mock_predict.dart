import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:hungry_dame/src/isolates/message_bus.dart';
import 'package:hungry_dame/src/isolates/predictor.dart';
import 'package:hungry_dame/src/model/arrangement.dart';
import 'package:hungry_dame/src/model/state.dart';


class MockPredictor extends Predictor{
  ReceivePort mockReceiver = new ReceivePort();
  void mockInit(){
    portToMain = mockReceiver.sendPort;
    mockReceiver.listen((rawMessage){
      if(rawMessage is List){
        for(Map<String,dynamic> message in rawMessage){
          print(JSON.encode(message));
        }
      }else{
        print(JSON.encode(rawMessage));
      }
    });
    State state = new State()..pieces8= Arrangement.start();
    new Future.delayed(const Duration(seconds: 1)).then((_){
      var rawMessage = {"arr": state.arrangementId, "black": false, "chained": false};
      predict(MessageBus.fromInitMessage(rawMessage));
    });
  }
}

void main(){
    new MockPredictor().mockInit();
}