import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';

import '../Model/RoomsModel.dart';
import '../Services/UserApi.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {


  final List<Map<String, String>> items1 = [
    {
      'image': 'assets/Pixl Team.png',
      'title': 'Vishwa',
      'subtitle': 'Date of appointment...',
      'time':'33 mins'
    },
    {
      'image': 'assets/Pixl Team.png',
      'title': 'Varun',
      'subtitle': 'Date of appointment...',
      'time':'33 mins'
    },
    {
      'image': 'assets/Pixl Team.png',
      'title': 'Karthik',
      'subtitle': 'Date of appointment...',
      'time':'33 mins'
    },

  ];
  bool isSelected =false;
  bool _loading =false;
  List<Rooms> rooms=[];
  @override
  void initState() {
    super.initState();
    GetRoomsList();
  }

  Future<void> GetRoomsList() async {
    var res = await Userapi.getrommsApi();
    setState(() {
      if (res != null) {
        if(res.settings?.success==1){
          rooms = res.data??[];
          rooms.sort((a, b) => (b.messageTime ?? 0).compareTo(a.messageTime ?? 0));
        }else{
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar:
      AppBar(
        backgroundColor: const Color(0xff8856F4),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
          ),
        ),
        title: const Text(
          "Messages",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
            height: 29.05 / 24.0,
          ),
        ),
      ),
      body:
      _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Container(
              height: w*0.08,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Image.asset(
                    "assets/search.png",
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Search",
                    style: TextStyle(
                        color: Color(0xff9E7BCA),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 19.36/14,
                        fontFamily: "Nunito"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                const Text(
                  "Direct messages",
                  style: TextStyle(
                    color: Color(0xff1C1C1C),
                    fontFamily: "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 15 / 14,
                  ),
                ),
                const Spacer(),
                const Text(
                  "Unread",
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontFamily: "Inter",
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 15 / 13,
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 20,
                  child: Transform.scale(
                    scale: 0.5,
                    child: Switch(
                      value: isSelected,
                      inactiveThumbColor: const Color(0xff98A9B0),

                      activeColor: const Color(0xff8856F4),
                      onChanged: (bool value) {
                        setState(() {
                          isSelected = value;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: w * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  var data = rooms[index];
                  String isoDate = data.messageSent ?? ""; // Fallback to empty string if null

                  DateTime? dateTime;
                  String formattedDate = ""; // Default value for null case
                  String formattedTime = "";  // Default value for null case

                  // Check if isoDate is not empty before parsing
                  if (isoDate.isNotEmpty) {
                    try {
                      dateTime = DateTime.parse(isoDate);
                      // Format the date and time
                      formattedDate = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
                      formattedTime = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
                    } catch (e) {
                      print("Error parsing date: $e");
                    }
                  }

                  // Debugging output
                  print("Date: $formattedDate");
                  print("Time: $formattedTime");

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F4FC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              ClipOval(
                                child: Image.network(
                                  data.otherUserImage ?? "",
                                  fit: BoxFit.contain,
                                  width: 32,
                                  height: 32,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10), // Space between image and text
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4, // Set a fixed width
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.otherUser ?? "",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w400,
                                    height: 19.36 / 16,
                                    color: Color(0xff1C1C1C),
                                  ),
                                ),
                                const SizedBox(height: 5), // Space between title and subtitle
                                Text(
                                  data.message ?? "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 14.52 / 12,
                                    overflow: TextOverflow.ellipsis,
                                    color: Color(0xff8A8A8A),
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text("${formattedTime}", // Display formatted time or "N/A"
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 14.52 / 12,
                              overflow: TextOverflow.ellipsis,
                              color: Color(0xff8A8A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
