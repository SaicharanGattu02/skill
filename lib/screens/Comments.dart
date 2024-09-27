import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skill/utils/CustomAppBar.dart';
import 'package:skill/utils/constants.dart';

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: CustomAppBar(title: 'Comments', actions: []),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(8),
                ),
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
                        fontSize: 16,
                        fontFamily: "Nunito",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Comments',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 18.36 / 14,
                    fontFamily: "Inter"),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: w * 0.18,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Upload',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 18.36 / 14,
                    fontFamily: "Inter"),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: w * 0.5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 30),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F8FF),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: DottedBorder(
                  color: Color(0xffB1BFD0), // Color of the dotted border
                  strokeWidth: 1,
                  dashPattern: [6, 3], // Dotted pattern
                  borderType: BorderType.RRect, // Rounded rectangle
                  radius: Radius.circular(8),
                  padding: EdgeInsets.all(10.0), // Padding around the Row
                  child: Row(
                    children: [


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
