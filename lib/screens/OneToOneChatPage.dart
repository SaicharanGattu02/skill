import 'dart:convert';
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

  final _secretKey = encrypt.Key.fromBase16(
      '21a288673f1daa503e0f540f1d02145c20fe122ec0c8fea359947253654553cd'); // AES with 256-bit key
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
    super.dispose();
  }

  void _initializeWebSocket(String room) {
    print('Attempting to connect to WebSocket...');
    _socket = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.56:8000/ws/chat/$room'),
    );
    print('Connected to WebSocket at: ws://192.168.0.56:8000/ws/chat/$room');

    _socket.stream.listen(
          (message) {
        print('Raw message received: $message');
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
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed. Trying to reconnect...');
        _reconnectWebSocket(room);
      },
    );
  }

  void _reconnectWebSocket(String room) {
    Future.delayed(Duration(seconds: 5), () {
      print('Reconnecting to WebSocket...');
      _initializeWebSocket(room);
    });
  }

  // Encrypt message before sending (AES-256, CBC, PKCS7)
  String _encryptMessage(String message) {
    print('Encrypting message: $message');
    final encrypter = encrypt.Encrypter(encrypt.AES(_secretKey));
    final encrypted = encrypter.encrypt(message, iv: _iv);
    print('Encrypted message: ${encrypted.base64}');
    return encrypted.base64; // Base64 encoded string for transmission
  }

  // Decrypt received message (AES-256, CBC, PKCS7)
  String _decryptMessage(String encryptedMessage) {
    print('Decrypting message: $encryptedMessage');
    final encrypter = encrypt.Encrypter(encrypt.AES(_secretKey));
    final decrypted = encrypter.decrypt64(encryptedMessage, iv: _iv);
    print('Decrypted message: $decrypted');
    return decrypted;
  }

  // Send an encrypted message over WebSocket
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
              DateTime.now().toLocal().toString().substring(11, 16), // Timestamp in HH:mm format
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
