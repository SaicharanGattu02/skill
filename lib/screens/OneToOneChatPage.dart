import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../Services/UserApi.dart';

class EncryptedChatPage extends StatefulWidget {
  final String roomId;
  EncryptedChatPage({required this.roomId});
  @override
  _EncryptedChatPageState createState() => _EncryptedChatPageState();
}

class _EncryptedChatPageState extends State<EncryptedChatPage> {
  late WebSocketChannel _socket;
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  Timer? _pingTimer;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;

  final _secretKey = encrypt.Key.fromBase16(
      '21a288673f1daa503e0f540f1d02145c20fe122ec0c8fea359947253654553cd');
  final _iv = encrypt.IV.allZerosOfLength(16); // Fixed IV in Hex format

  @override
  void initState() {
    super.initState();
    createRoom();
  }

  Future<void> createRoom() async {
    print('Creating room for chat...');
    var res = await Userapi.CreateChatRoomAPi(widget.roomId);
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          print('Room created successfully: ${res.data?.room}');
          _initializeWebSocket(res.data?.room ?? "");
        } else {
          print('Failed to create room');
        }
      } else {
        print('Room creation API returned null.');
      }
    });
  }

  @override
  void dispose() {
    print('Disposing WebSocket and cleaning up resources...');
    _socket.sink.close();
    _messageController.dispose();
    _pingTimer?.cancel();
    super.dispose();
  }

  void _initializeWebSocket(String room) {
    print('Attempting to connect to WebSocket...');
    try {
      _socket = WebSocketChannel.connect(
        Uri.parse('ws://192.168.0.56:8000/ws/chat/$room'),
      );
      print('Connected to WebSocket at: ws://192.168.0.56:8000/ws/chat/$room');
      _startPing();

      _socket.stream.listen(
            (message) {
          print('Raw message received: $message');
          _handleIncomingMessage(message);
        },
        onError: (error) {
          print('WebSocket error: $error');
          _reconnectWebSocket(room);
        },
        onDone: () {
          print('WebSocket connection closed. Trying to reconnect...');
          _reconnectWebSocket(room);
        },
      );
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      _reconnectWebSocket(room);
    }
  }

  void _startPing() {
    // Send a ping every 30 seconds to keep the connection alive
    _pingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _socket.sink.add(jsonEncode({"type": "ping"}));
      print('Sent ping to WebSocket to keep connection alive.');
    });
  }

  void _handleIncomingMessage(String message) {
    try {
      final decodedMessage = jsonDecode(message);
      print('Decoded JSON message: $decodedMessage');

      if (decodedMessage['type'] == 'new_message') {
        final msgData = decodedMessage['data'];
        final encryptedMsg = msgData['msg'];

        // Decrypt the message
        final decryptedMessage = _decryptMessage(encryptedMsg);
        print('Decrypted message: $decryptedMessage');

        setState(() {
          _messages.add({
            'sender': 'remote',
            'message': decryptedMessage,
            'timestamp': msgData['last_updated'] ?? DateTime.now().toString(),
          });
        });
      }
    } catch (e) {
      print('Error processing message: $e');
    }
  }

  void _reconnectWebSocket(String room) {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('Max reconnect attempts reached. Stopping reconnection.');
      return;
    }

    Future.delayed(Duration(seconds: 5), () {
      _reconnectAttempts++;
      print('Reconnecting to WebSocket... Attempt $_reconnectAttempts');
      _initializeWebSocket(room);
    });
  }

  // Encrypt message before sending
  String _encryptMessage(String message) {
    print('Encrypting message: $message');
    final encrypter = encrypt.Encrypter(encrypt.AES(_secretKey));
    final encrypted = encrypter.encrypt(message, iv: _iv);
    print('Encrypted message: ${encrypted.base64}');
    return encrypted.base64;
  }

  // Decrypt received message
  String _decryptMessage(String encryptedMessage) {
    print('Decrypting message: $encryptedMessage');
    final encrypter = encrypt.Encrypter(encrypt.AES(_secretKey));
    final decrypted = encrypter.decrypt64(encryptedMessage, iv: _iv);
    print('Decrypted message: $decrypted');
    return decrypted;
  }

  void _sendMessage() {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      print('Sending message: $message');
      final encryptedMessage = _encryptMessage(message);
      _socket.sink.add(encryptedMessage); // Send encrypted message
      print('Encrypted message sent to WebSocket.');

      setState(() {
        _messages.add({
          'sender': 'you',
          'message': message,
          'timestamp': DateTime.now().toString(),
        });
      });

      _messageController.clear();
    }
  }

  // Build each chat message bubble
  Widget _buildMessageBubble(String message, String sender) {
    bool isMe = sender == 'you';
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              DateTime.now().toLocal().toString().substring(11, 16),
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encrypted WebSocket Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index]['message'];
                final sender = _messages[index]['sender'];
                return _buildMessageBubble(message, sender);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
