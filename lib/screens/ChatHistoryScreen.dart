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

  Future<void> _clearChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chatHistory'); // Clear chat history
    setState(() {
      chatHistory = []; // Update the state
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF3ECFB),
      appBar: CustomAppBar(
        title: "Chat History",
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline,color: Colors.white,),
            onPressed: () {
              _clearChatHistory(); // Clear chat history on tap
            },
          ),
        ],
      ),
      body: chatHistory.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Image.asset(
              'assets/nodata1.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            const Text(
              "No Data Foound!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontFamily: "Inter",
              ),
            ),
            SizedBox(
              height: h * 0.3,
            )
          ],
        ),
      )
          : Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: ListView.separated(
                    itemCount: chatHistory.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
            return Align(
              alignment: index.isOdd
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: index.isOdd ? MainAxisAlignment.start : MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index.isOdd)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/chatbot.jpeg",
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
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: index.isOdd ? Color(0xffEAE1FF) : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: index.isOdd ? Radius.circular(15) : Radius.circular(0),
                          bottomLeft: index.isOdd ? Radius.circular(0) : Radius.circular(15),
                        ),
                      ),
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
                  ],
                ),
              ),
            );
                    },
                  ),
          ),
    );
  }
}
