import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class SocketService {
  static List<ValueChanged<Map<String, dynamic>>> _listeners = [];
  static late StompClient stompClient;

  static void init() {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://192.168.0.131:8080/ws-message',
        onConnect: onConnect,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
      ),
    );
    stompClient.activate();
  }

  static void addListener(ValueChanged<Map<String, dynamic>> listener) {
    _listeners.add(listener);
  }

  static void removeListener(ValueChanged<Map<String, dynamic>> listener) {
    _listeners.remove(listener);
  }

  static void notifyListeners(Map<String, dynamic> data) {
    for (var listener in _listeners) {
      listener(data);
    }
  }

  static void onConnect(StompFrame frame) {
    print("Connected: ${frame.body}");
    stompClient.subscribe(
      destination: '/topic/greetings',
      callback: (frame) {
        Map<String, dynamic>? result = json.decode(frame.body!);
        notifyListeners(result!);
      },
    );
  }
}
