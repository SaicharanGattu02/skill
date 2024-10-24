import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:web_socket_channel/io.dart';
import '../Model/FetchmesgsModel.dart';
import '../Model/RoomsDetailsModel.dart';
import '../Model/RoomsModel.dart';
import '../Services/UserApi.dart';
import '../utils/Preferances.dart';
import 'Profiledashboard.dart';
import 'UserProfile.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  ChatPage({required this.roomId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IOWebSocketChannel _socket;
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isConnected = false;
  bool _isLoadingMore = false; // Track loading state for more messages
  String user_id = "";
  String user_type = "";
  int _currentPage = 0;
  String last_msg_id = "";

  String username = "";
  String userimage = "";
  String userID = "";

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    RoomDetailsApi();
    _scrollController
        .addListener(_scrollListener); // Add listener for scrolling
    print(widget.roomId);
  }

  List<Messages> _messages = [];

  Future<void> RoomDetailsApi() async {
    user_id = await PreferenceService().getString("user_id") ?? "";
    print('user_id: $user_id');

    var res = await Userapi.getrommsdetailsApi(widget.roomId);
    setState(() {
      if (res != null && res.settings?.success == 1) {
        _messages = res.data?.messages ?? [];
        if (_messages.isNotEmpty) {
          last_msg_id = _messages[0].id ?? "";
        }
        username = res.data?.userName ?? "";
        userimage = res.data?.userImage ?? "";
        userID = res.data?.userId ?? "";

        // Scroll to the bottom after messages are loaded
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      } else {
        print('Failed to create room');
      }
    });
  }

  Future<void> _fetchMessages() async {
    print('Fetching messages for page $_currentPage...');
    var res = await Userapi.fetchroommessages(widget.roomId, last_msg_id);

    if (res != null && res.settings?.success == 1) {
      print('Messages fetched successfully');
      // Assuming res.data is List<Message>
      List<Message> fetchedMessages =
          res.data ?? []; // Ensure it's a List<Message>
      setState(() {
        // Convert List<Message> to List<Messages>
        List<Messages> convertedMessages = fetchedMessages.map((msg) {
          return Messages(
            id: msg.id,
            sentUser: msg.sentUser,
            msg: msg.msg,
            lastUpdated: msg.lastUpdated,
            unixTimestamp: msg.unixTimestamp,
            isRead: msg.isRead,
          );
        }).toList();

        _messages.insertAll(0, convertedMessages); // Prepend new messages

        if (_messages.isNotEmpty) {
          last_msg_id =
              _messages[0].id ?? ""; // Update last_msg_id if messages exist
        }
      });
    } else {
      print('Failed to fetch messages');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels == 0 &&
        !_isLoadingMore) {
      _loadMoreMessages(); // Load more messages when scrolled to top
    }
  }

  Future<void> _loadMoreMessages() async {
    setState(() {
      _isLoadingMore = true;
    });

    await _fetchMessages(); // Fetch next page of messages

    setState(() {
      _isLoadingMore = false; // Reset loading state
    });
  }

  @override
  void dispose() {
    print('Disposing WebSocket and cleaning up resources...');
    _socket.sink.close();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeWebSocket() {
    print('Attempting to connect to WebSocket...');
    _socket = IOWebSocketChannel.connect(
        Uri.parse('wss://stage.skil.in/ws/chat/${widget.roomId}'));
    print(
        'Connected to WebSocket at: wss://stage.skil.in/ws/chat/${widget.roomId}');
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
          // Reset message count for the specific room
          setState(() {
            _messages.add(newMessage);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom(); // Keep scrolling down to latest message
            });
          });
        } catch (e) {
          print('Error processing message: $e');
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        setState(() {
          _isConnected = false;
        });
      },
      onDone: () {
        print('WebSocket connection closed. Trying to reconnect...');
        setState(() {
          _isConnected = false;
        });
        _reconnectWebSocket();
      },
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _reconnectWebSocket() {
    Future.delayed(Duration(seconds: 5), () {
      print('Reconnecting to WebSocket...');
      _initializeWebSocket();
    });
  }

  void _sendMessage() {
    String message = _messageController.text;
    if (message.isNotEmpty && _isConnected) {
      print('Sending message: $message');

      try {
        final payload = jsonEncode(
            {'command': 'new_message', 'message': message, 'user': user_id});
        _socket.sink.add(payload);
      } catch (e) {
        print('Error sending message: $e');
      }
      _messageController.clear();
    } else {
      print('Socket not connected or message is empty');
    }
  }

  Widget _buildMessageBubble(String message, String sender, String datetime) {
    bool isMe = sender == 'you';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)

              Padding(
                padding: const EdgeInsets.only(top:5.0),
                child: ClipOval(
                  child: Image.network(
                    userimage,
                    width: 35,
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(width: 8),

            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Color(0xffEAE1FF) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: isMe ? Radius.circular(15) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(15),
                ),
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
                    datetime,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context, true),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () async {
                var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(userID: userID)));
                if(res == true) {
                  _initializeWebSocket();
                  RoomDetailsApi();
                }
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userimage),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InkResponse(
                onTap: () async {
                  var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(userID: userID)));
                  if(res == true) {
                    _initializeWebSocket();
                    RoomDetailsApi();
                  }
                },
                child: Text(
                  username,
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
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: Image(
        //         image: AssetImage("assets/video.png"),
        //         color: Colors.white,
        //         width: 22,
        //         height: 20),
        //     onPressed: () {
        //       // Handle video call action
        //     },
        //   ),
        //   IconButton(
        //     icon: Image(
        //         image: AssetImage("assets/call.png"), width: 22, height: 20),
        //     onPressed: () {
        //       // Handle phone call action
        //     },
        //   ),
        //   IconButton(
        //     icon: Image(
        //         image: AssetImage("assets/more.png"), width: 22, height: 20),
        //     onPressed: () {
        //       // Handle more actions
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              // In the ListView.builder
              itemCount: _messages.length +
                  (_isLoadingMore ? 1 : 0), // Add 1 for the loader
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoadingMore) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final message = _messages[index].msg;
                final sender = _messages[index].sentUser == user_id ? "you" : "remote";
                final datetime = _messages[index].lastUpdated??"";
                return _buildMessageBubble(message ?? "", sender,datetime);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter your message',
                        border: InputBorder.none, // Remove the default border
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0), // Add padding
                      ),
                    ),
                  ),
                  InkResponse(
                    onTap: (){
                      _sendMessage();
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                        child: Image(
                      image: AssetImage(
                        "assets/container.png",
                      ),
                      height: 36,
                      width: 36,
                    )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
