import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

import '../utils/Preferances.dart';

class WebSocketManager {
  static const int MAX_NUM = 50; // Maximum number of reconnections
  static const int MILLIS = 50000;

  late String TAG;
  late http.Client client;
  late http.Request request;

  // String url;
  bool isConnect = false;
  int connectNum = 0;
  IOWebSocketChannel? channel;
  StreamSubscription? subscription;
  Function()? onConnectSuccess;
  Function(String)? onMessage;
  Function()? onClose;
  Function()? onConnectFailed;

  WebSocketManager(
      {this.onConnectSuccess,
        this.onMessage,
        this.onClose,
        this.onConnectFailed});


  Future<bool> init() async {
    try {
      TAG = 'WebSocketManager';
      client = http.Client();
      request = http.Request('GET', Uri.parse('wss://ws.erp.gengroup.in/?type=user&route=employe_live_location_update&session_id=${await PreferenceService().getString("Session_id")}'));
      print('WebSocket Initiated');
      return true; // WebSocket initialization successful
    } catch (e) {
      print('Failed to initialize WebSocket: $e');
      return false; // WebSocket initialization failed
    }
  }


  void connect() async {
    if (isConnected()) {
      print('WebSocket connected');
      return;
    }
    print('WebSocket Not connected');
    try {
      final url = 'wss://ws.erp.gengroup.in/?type=user&route=employe_live_location_update&session_id=';
      print(url);
      channel = IOWebSocketChannel.connect(url);
      channel!.stream.handleError((error) {
        print('WebSocket error: $error');
        // Handle error appropriately
      });
      if (channel == null) {
        print('Failed to connect to WebSocket');
        return; // Exit the function if connection failed
      }
      subscription = channel!.stream.listen((message) {
        print('Received: $message');
        onMessage?.call(message);
      }, onError: (error) {
        print('WebSocket error: $error');
        onClose?.call();
        reconnect();
      }, onDone: () {
        print('WebSocket closed');
        onClose?.call();
        reconnect();
      }, cancelOnError: true);
      isConnect = true;
      onConnectSuccess?.call();
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      // Handle error appropriately (e.g., retry connection, show error message)
    }
  }



  void reconnect() {
    if (connectNum <= MAX_NUM) {
      Future.delayed(Duration(milliseconds: MILLIS), () {
        connect();
        connectNum++;
      });
    } else {
      print('Reconnect over $MAX_NUM, please check URL or network');
    }
  }

  void sendMessage(String text) {
    if (isConnected()) {
      print('WebSocket is not connected. Message not sent.');
      //   connect();
      return;
    }

    // Add listener to the sink's done event
    channel?.sink.done.then((_) {
      print('WebSocket sink is closed. Message not sent.');
    }).catchError((error) {
      print('Error occurred while sending message: $error');
    });

    // Send the message
    channel?.sink.add(text);
    print('Message sent: $text');
  }


  bool isConnected() {
    return isConnect;
  }


  Future<void> close() async {
    if (isConnected()) {
      print('WebSocket Closed');
      channel?.sink.close();
      channel = null;
      isConnect = false;
    }
  }

}
