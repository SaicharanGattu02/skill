import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';

import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:skill/utils/CustomAppBar.dart'; // Make sure to include this package

class Allchannels extends StatefulWidget {
  const Allchannels({super.key});

  @override
  State<Allchannels> createState() => _AllchannelsState();
}

final List<Map<String, String>> items1 = [
  {
    'image': 'assets/Pixl Team.png',
    'title': 'Pixl Team',
    'subtitle': 'All Pixl Company Employees.'
  },
  {
    'image': 'assets/designers.png',
    'title': 'Designers Team',
    'subtitle': 'All Pixl Designers Employees.'
  },
  {
    'image': 'assets/developer.png',
    'title': 'Developer Team',
    'subtitle': 'All Pixl Developer Employees.'
  },
  {
    'image': 'assets/hrteam.png',
    'title': 'HR Team',
    'subtitle': 'All Pixl HR Team Employees.'
  },
];

final List<String> _images = [
  'https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
  'https://images.unsplash.com/photo-1612594305265-86300a9a5b5b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
  'https://images.unsplash.com/photo-1612626256634-991e6e977fc1?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1712&q=80',
  'https://images.unsplash.com/photo-1593642702749-b7d2a804fbcf?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80'
];

class _AllchannelsState extends State<Allchannels> {

  List<Map<String, String>> filteredItems = items1;
  String searchQuery = "";

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      // Filter based only on title
      filteredItems = items1
          .where((item) => item['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar:CustomAppBar(title: 'All Channels',actions:[ Container()],  ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: h*0.045,
              child: Container(
                padding:  EdgeInsets.only(left: 14,right: 14,),
                decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/search.png",
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(

                          child: TextField(
                            onChanged: updateSearchQuery,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search',
                              hintStyle: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Color(0xff9E7BCA),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontFamily: "Nunito",

                              ),
                            ),
                            style:  TextStyle(
                              color: Color(0xff9E7BCA),
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              decorationColor:  Color(0xff9E7BCA),
                              fontFamily: "Nunito",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
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
                          ClipOval(
                            child: Image.asset(
                              filteredItems[index]['image']!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: w * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filteredItems[index]['title']!,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                    height: 19.36 / 16,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  filteredItems[index]['subtitle']!,
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
                          FlutterImageStack(
                            imageList: _images,
                            totalCount: _images.length,
                            showTotalCount: true,
                            itemBorderWidth: 1,
                            itemRadius: 27,
                            extraCountTextStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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


