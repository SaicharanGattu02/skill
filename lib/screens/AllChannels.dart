import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:skill/screens/Alertscreen2.dart';
import 'package:skill/utils/CustomAppBar.dart';

import 'Alertscreen1.dart';

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
    'title': 'Pixl Team',
    'subtitle': 'All Pixl Developer Employees.'
  },
  {
    'image': 'assets/hrteam.png',
    'title': 'Hr Team',
    'subtitle': 'All Pixl Hrteam Employees.'
  },
  {
    'image': 'assets/Pixl Team.png',
    'title': 'Pixl Team',
    'subtitle': 'All Pixl Company Employees.'
  },
  {
    'image': 'assets/Pixl Team.png',
    'title': 'Pixl Team',
    'subtitle': 'All Pixl Company Employees.'
  },
  {
    'image': 'assets/Pixl Team.png',
    'title': 'Pixl Team',
    'subtitle': 'All Pixl Company Employees.'
  },
];

final List<String> _images = [
  'https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
  'https://images.unsplash.com/photo-1612594305265-86300a9a5b5b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
  'https://images.unsplash.com/photo-1612626256634-991e6e977fc1?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1712&q=80',
  'https://images.unsplash.com/photo-1593642702749-b7d2a804fbcf?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80'
];
bool _loading =false;
class _AllchannelsState extends State<Allchannels> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: CustomAppBar(title: "All Channels", actions: [],onPlusTap: (){
        Navigator.push(context, MaterialPageRoute(builder:(context)=>AlertDialogScreen()));
      },),
      body:
      _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Image.asset(
                    "assets/search.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Search",
                    style: TextStyle(
                        color: Color(0xff9E7BCA),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        fontFamily: "Nunito"),
                  ),
                ],
              ),
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
                          ClipOval(
                            child: Image.asset(
                              items1[index]['image']!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
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
                                    fontWeight: FontWeight.w500,
                                    height: 19.36 / 16,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        5), // Space between title and subtitle
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
                          FlutterImageStack(
                            imageList: _images,
                            totalCount: _images.length,
                            showTotalCount: true,
                            itemBorderWidth: 1,
                            itemRadius: 27, // Radius of each image
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
