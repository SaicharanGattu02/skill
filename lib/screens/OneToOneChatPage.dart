import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Services/UserApi.dart';

class WebRTCChatPage extends StatefulWidget {
  final String roomId;

  WebRTCChatPage({required this.roomId});

  @override
  _WebRTCChatPageState createState() => _WebRTCChatPageState();
}

class _WebRTCChatPageState extends State<WebRTCChatPage> {
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];
  late WebSocketChannel _socket;

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'}, // STUN server
    ]
  };

  @override
  void initState() {
    super.initState();
    _initializePeerConnection();
    CreateRoom();
  }

  Future<void> CreateRoom() async {
    var Res = await Userapi.CreateChatRoomAPi(widget.roomId);
    setState(() {
      if (Res != null) {
        if (Res.settings?.success==1) {
          _initializeWebSocket(Res.data?.room??"");
        } else {

        }
      }
    });
  }

  @override
  void dispose() {
    _peerConnection?.close();
    _messageController.dispose();
    _socket.sink.close();
    super.dispose();
  }

  // Initialize WebSocket connection
  void _initializeWebSocket(String room) {
    // _socket = WebSocketChannel.connect(
    //     Uri.parse('ws://192.168.0.56:8000/chat/${room}')
    // );
    _socket = IOWebSocketChannel.connect('ws://192.168.0.56:8000/chat/${room}');
    _socket.stream.listen(
            (message) {
          _handleSignalingMessage(jsonDecode(message));
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
        onDone: () {
          print('WebSocket connection closed.');
        }
    );

  }
  // Initialize WebRTC peer connection
  Future<void> _initializePeerConnection() async {
    _peerConnection = await createPeerConnection(_iceServers);

    // Handle ICE candidates
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _sendToServer({
        'type': 'candidate',
        'candidate': candidate.toMap(),
      });
    };

    // Create a data channel for sending messages
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit();
    _dataChannel = await _peerConnection!.createDataChannel('chat', dataChannelDict);
    _dataChannel!.onMessage = (RTCDataChannelMessage message) {
      _onMessageReceived(message.text);
    };

    // Handle data channel from the remote peer
    _peerConnection!.onDataChannel = (RTCDataChannel channel) {
      channel.onMessage = (RTCDataChannelMessage message) {
        _onMessageReceived(message.text);
      };
    };

    // Automatically create an offer when the connection is set up
    _createOffer();
  }

  // Handle incoming signaling messages
  void _handleSignalingMessage(dynamic message) async {
    if (message['type'] == 'offer') {
      await _peerConnection!.setRemoteDescription(RTCSessionDescription(
        message['sdp'], message['type'],
      ));
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      _sendToServer({
        'type': 'answer',
        'sdp': answer.sdp,
      });
    } else if (message['type'] == 'answer') {
      await _peerConnection!.setRemoteDescription(RTCSessionDescription(
        message['sdp'], message['type'],
      ));
    } else if (message['type'] == 'candidate') {
      RTCIceCandidate candidate = RTCIceCandidate(
        message['candidate']['candidate'],
        message['candidate']['sdpMid'],
        message['candidate']['sdpMLineIndex'],
      );
      await _peerConnection!.addCandidate(candidate);
    }
  }

  // Send WebRTC signaling message to the WebSocket server
  void _sendToServer(Map<String, dynamic> message) {
    _socket.sink.add(jsonEncode(message));
  }

  // Create an offer and send it to the remote peer
  Future<void> _createOffer() async {
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    _sendToServer({
      'type': 'offer',
      'sdp': offer.sdp,
    });
  }

  // Handle received messages
  void _onMessageReceived(String message) {
    setState(() {
      _messages.add('Remote: $message');
    });
  }

  // Send a message over the data channel
  void _sendMessage() {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      _dataChannel?.send(RTCDataChannelMessage(message));
      setState(() {
        _messages.add('You: $message');
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebRTC One-to-One Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
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
