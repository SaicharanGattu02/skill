import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/CustomAppBar.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  List<String> chatHistory = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('chatHistory');
    if (history != null) {
      setState(() {
        chatHistory = history;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Chat History",
        actions: [Container()],
      ),

      body: chatHistory.isEmpty
          ? Center(child: Text("No chat history available."))
          : ListView.separated(
        itemCount: chatHistory.length,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Align(
            alignment: index.isOdd ? Alignment.centerLeft : Alignment.centerRight,
            child: Card(
              color: index.isOdd ? Color(0xffEAE1FF) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  chatHistory[index],
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
