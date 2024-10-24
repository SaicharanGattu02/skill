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
      backgroundColor: Color(0xffF3ECFB),
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
            alignment: index.isOdd
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),


              child: Row(
                mainAxisAlignment:  index.isOdd ? MainAxisAlignment.start : MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ( index.isOdd)

                    Padding(
                      padding: const EdgeInsets.only(top:5.0),
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
                      color:
                      index.isOdd ? Color(0xffEAE1FF) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: index.isOdd
                            ? Radius.circular(15)
                            : Radius.circular(0),
                        bottomLeft: index.isOdd
                            ? Radius.circular(0)
                            : Radius.circular(15),
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
    );
  }
}
