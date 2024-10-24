import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/CustomAppBar.dart';
import '../utils/constants.dart';
import '../utils/three_bounce.dart';
import 'ChatHistoryScreen.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({
    super.key,
  });

  @override
  State<AIChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<AIChatPage> {
  TextEditingController controller = TextEditingController();
  List<String> listDatas = [];
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _loadChatHistory(); // Load chat history on initialization
    _scrollController.addListener(_scrollListener);
  }

  // Future<void> _loadChatHistory() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? chatHistory = prefs.getStringList('chatHistory');
  //   if (chatHistory != null) {
  //     listDatas = chatHistory;
  //     setState(() {});
  //   }
  // }

  Future<void> _saveChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('chatHistory', listDatas);
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels == 0) {
      // Load more messages when scrolled to top (if needed)
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF3ECFB),
      appBar: CustomAppBar(
        title: "Jarvis",
        actions: [
          Container(),
          IconButton(
            icon: Icon(Icons.history,color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatHistoryScreen()), // Navigate to history screen
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          listDatas.isEmpty
              ? Expanded(
                  child: Center(
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
                          "Explore your doubts here!",
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
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: listDatas.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (BuildContext context, int index) {
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
                                    listDatas[index],
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
          ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (BuildContext context, dynamic value, Widget? child) {
              if (!value) {
                return const SizedBox();
              }
              return const SpinKitThreeBounce(
                color: Colors.blue,
                size: 30,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
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
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Enter a Prompt ...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ),
                  InkResponse(
                    onTap: _searchContent,
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Image(
                        image: AssetImage("assets/container.png"),
                        height: 36,
                        width: 36,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _searchContent() async {
    if (controller.text.isNotEmpty) {
      listDatas.add(controller.text);
      isLoading.value = true;
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: geminiApiKey,
      );
      final prompt = controller.text;
      final content = [Content.text(prompt)];
      controller.clear();
      final response = await model.generateContent(content);
      listDatas.add(response.text ?? "");
      isLoading.value = false;
      await _saveChatHistory(); // Save chat history
      controller.clear();
      // _scrollToBottom();
      setState(() {});
    }
  }
}
