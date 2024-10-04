import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../Services/UserApi.dart';
import '../utils/Preferances.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  ChatPage({required this.roomId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IOWebSocketChannel _socket; // WebSocket channel
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _isConnected = false; // Track connection status
  String user_id="";

  @override
  void initState() {
    super.initState();
    createRoom();
  }

  Future<void> createRoom() async {
    user_id = await PreferenceService().getString("user_id") ?? "";
    print('Creating room for chat...');
    print('user_id:${user_id}');
    var res = await Userapi.CreateChatRoomAPi(widget.roomId);
    if (res != null && res.settings?.success == 1) {
      print('Room created successfully: ${res.data?.room}');
      _initializeWebSocket(res.data?.room ?? "");
    } else {
      print('Failed to create room');
    }
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
    _socket = IOWebSocketChannel.connect(Uri.parse('ws://192.168.0.56:8000/ws/chat/$room'));
    print('Connected to WebSocket at: ws://192.168.0.56:8000/ws/chat/$room');
    setState(() {
      _isConnected = true;
    });

    _socket.stream.listen(
          (message) {
        print('Message received: $message');
        try {
          // Decode the JSON string into a Map
          final decodedMessage = jsonDecode(message);
          print('Decoded message: $decodedMessage');

          setState(() {
            _messages.add({
              'sender': 'remote',
              'message': decodedMessage['data']['msg'] ?? 'Message could not be decoded',
              'timestamp': decodedMessage['data']['last_updated'] ?? DateTime.now().toString(),
            });
          });
        } catch (e) {
          print('Error processing message: $e');
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        setState(() {
          _isConnected = false; // Update connection status
        });
      },
      onDone: () {
        print('WebSocket connection closed. Trying to reconnect...');
        setState(() {
          _isConnected = false; // Update connection status
        });
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

  void _sendMessage() {
    String message = _messageController.text;
    if (message.isNotEmpty && _isConnected) {
      print('Sending message: $message');

      try {
        // Create the payload as specified
        final payload = jsonEncode({
          'command': 'new_message',
          'message': message, // Use the actual message text
          'user': user_id
        });

        _socket.sink.add(payload);

        setState(() {
          _messages.add({
            'sender': 'you',
            'message': message,
            'timestamp': DateTime.now().toString(),
            'status': 'sending', // Initial status for message
          });
        });
      } catch (e) {
        print('Error sending message: $e');
      }

      _messageController.clear();
    } else {
      print('Socket not connected or message is empty');
    }
  }


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
        title: Text('WebSocket Chat'),
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
