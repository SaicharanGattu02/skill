import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

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

class _MessagesState extends State<Messages> {
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
      body: Padding(
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
                itemCount: items1.length,
                itemBuilder: (context, index) {
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
                          // ClipOval(
                          //   child: Image.asset(
                          //     items1[index]['image']!,
                          //     width: 48,
                          //     height: 48,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          Stack(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  items1[index]['image']!,
                                  fit: BoxFit.contain,
                                  width: 32,
                                  height: 32,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    // color: items1[index]['active']
                                    //     ? Colors.green
                                    //     : Color(0xff8856F4),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                ),
                              ),

                            ],
                          ),
                          const SizedBox(
                              width: 10), // Space between image and text
                          SizedBox(
                            width: w * 0.4, // Set a fixed width
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items1[index]['title']!,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w400,
                                    height: 19.36 / 16,
                                    color: Color(0xff1C1C1C),
                                  ),
                                ),
                                const SizedBox(
                                    height: 5), // Space between title and subtitle
                                Text(
                                  items1[index]['subtitle']!,
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
                          Spacer(),
                          Text(
                            items1[index]['time']!,
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
