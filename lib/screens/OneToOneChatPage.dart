import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../Model/CreateRoomModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';
import '../utils/Preferances.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  ChatPage({required this.userId});

  @override
  _ChatPageState createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {
  late IOWebSocketChannel _socket; // WebSocket channel
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController(); // Add this
  bool _isConnected = false; // Track connection status
  String user_id = "";
  String user_type = "";

  @override
  void initState() {
    super.initState();
    createRoom();
    print(widget.userId);
  }

  List<Messages> _messages = [];
  OtherUser? otherUser;

  Future<void> createRoom() async {
    user_id = await PreferenceService().getString("user_id") ?? "";
    print('Creating room for chat...');
    print('user_id: $user_id');
    var res = await Userapi.CreateChatRoomAPi(widget.userId);
    if (res != null && res.settings?.success == 1) {
      print('Room created successfully: ${res.data?.room}');
      _messages = res.data?.messages ?? [];
      otherUser = res.data?.otherUser;
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
    _scrollController.dispose(); // Dispose of the ScrollController
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
          final decodedMessage = jsonDecode(message);
          print('Decoded message: $decodedMessage');

          Messages newMessage = Messages.fromJson(decodedMessage['data']);

          setState(() {
            if (newMessage.sentUser == user_id) {
              user_type = "you";
            } else {
              user_type = "remote";
            }
            _messages.add(newMessage);
            _scrollToBottom(); // Scroll to bottom when a new message is added
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

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
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
        final payload = jsonEncode({
          'command': 'new_message',
          'message': message,
          'user': user_id
        });
        _socket.sink.add(payload);
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
        width: MediaQuery.of(context).size.width * 0.75,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Color(0xffEAE1FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              DateTime.now().toLocal().toString().substring(11, 16),
              style: TextStyle(
                color: Colors.black54,
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
      backgroundColor: const Color(0xffF3ECFB),
      appBar: AppBar(
        backgroundColor: Color(0xff8856F4),
        leadingWidth: 25,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.arrow_back,
              color: Color(0xffffffff),
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(otherUser?.image ?? ""),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                otherUser?.fullName ?? "",
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Image(image: AssetImage("assets/video.png"), color: Colors.white, width: 22, height: 20),
            onPressed: () {
              // Handle video call action
            },
          ),
          IconButton(
            icon: Image(image: AssetImage("assets/call.png"), width: 22, height: 20),
            onPressed: () {
              // Handle phone call action
            },
          ),
          IconButton(
            icon: Image(image: AssetImage("assets/more.png"), width: 22, height: 20),
            onPressed: () {
              // Handle more actions
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Use the ScrollController here
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index].msg;
                final sender = _messages[index].sentUser == user_id ? "you" : "remote";
                return _buildMessageBubble(message ?? "", sender);
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

