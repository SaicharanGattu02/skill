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
bool _loading =false;

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: CustomAppBar(title: 'Comments', actions: []),
      body:
      _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
      SingleChildScrollView(
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
                width: w,
                decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(7)),
                child: DottedBorder(
                  color: Color(0xffB1BFD0), // Color of the dotted border
                  strokeWidth: 1,
                  dashPattern: [6, 3], // Dotted pattern
                  borderType: BorderType.RRect, // Rounded rectangle
                  radius: Radius.circular(8),
                  padding: EdgeInsets.all(10.0),
                  // Padding around the Row
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/Outline.png",
                            width: w * 0.3,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          Text(
                            'Comments',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 18.36 / 14,
                                fontFamily: "Inter"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(7)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/prashanth.png",
                          height: 36,
                          width: 36,
                        ),
                        SizedBox(width: 8,),
                        Text(
                          "Vissu",
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 15 / 16,
                              fontFamily: "Inter"),
                        ),
                        Spacer(),
                       Icon(Icons.remove_red_eye,color: Color(0xff969DB2),),
                        SizedBox(width: 18,),
                      Image.asset("assets/delete.png",height: 18,width: 18,color: Color(0xffDE350B),),
                        SizedBox(width: 18,),
                        Image.asset("assets/download.png",height: 18,width: 18,)
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text("specific information about a project, such as the tasks to be completed.",style: TextStyle(color: Color(0xff969DB2)),),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Image.asset("assets/imageframe1.png",width: 32,height: 32,),
                        ),
             SizedBox(width: 20,),
                        Text(
                          "Vissu",
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 15 / 16,
                              fontFamily: "Inter"),
                        ),
                      ],
                    ),


                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
