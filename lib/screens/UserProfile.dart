import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/DashboardTaksModel.dart';
import '../Services/UserApi.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({super.key});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: AppBar(
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
          "Profile Someone",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        width: w,
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        padding: const EdgeInsets.only(left: 48,right: 48),
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.grey,
            ),
            Text(
              "Profile Someone",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24.0,
                color: Color(0xff290358),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "UX/UI Designer",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                color: Color(0xff6C848F),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                // UX/UI and Contact Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Color(0xFF36B37E).withOpacity(0.1),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/call.png",
                                    fit: BoxFit.contain,
                                    width: 12,
                                    color: Color(0xff36B37E),
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    // Wrap Text with Expanded to avoid overflow
                                    child: Text(
                                      "lkjsbfhkisjvbkshvb",
                                      style: TextStyle(
                                        color: Color(0xff36B37E),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                        height: 13.41 / 11,
                                        letterSpacing: 0.14,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: w * 0.015),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Color(0xff2572ED).withOpacity(0.2),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/gmail.png",
                                    fit: BoxFit.contain,
                                    width: 12,
                                    color: const Color(0xff2572ED),
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    // Wrap Text with Expanded here too
                                    child: Text(
                                      "rtjrtmtymtuu,rutr6",
                                      style: TextStyle(
                                        color: const Color(0xff2572ED),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                        height: 13.41 / 11,
                                        letterSpacing: 0.14,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16,),
                      Divider(
                        height: 1,
                      ),
                      SizedBox(height: 16,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [
                            Image.asset("assets/msg.png",width: 18,height: 18,color: Color(0xff8856F4),),
                            SizedBox(height: 8,),
                            Text(
                              "Message",
                              style: TextStyle(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                height: 13.41 / 11,
                                letterSpacing: 0.14,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: "Inter",
                              ),
                            ),
                          ],),
                         Container(width: 1,height: 50,decoration: BoxDecoration(color: Color(0xff1D1C1D).withOpacity(0.2)),),
                          Column(children: [
                            Image.asset("assets/call.png",width: 18,height: 18,color: Color(0xff8856F4),),
                            SizedBox(height: 8,),
                            Text(
                              "Call",
                              style: TextStyle(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                height: 13.41 / 11,
                                letterSpacing: 0.14,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: "Inter",
                              ),
                            ),
                          ],),
                          Container(width: 1,height: 50,decoration: BoxDecoration(color: Color(0xff1D1C1D).withOpacity(0.2)),),
                          Column(children: [
                            Image.asset("assets/video.png",width: 18,height: 18,color: Color(0xff8856F4),),
                            SizedBox(height: 8,),
                            Text(
                              "Mail",
                              style: TextStyle(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                height: 13.41 / 11,
                                letterSpacing: 0.14,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: "Inter",
                              ),
                            ),
                          ],),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Divider(
                        height: 1,
                      ),
                    ],
                  ),
                ),


                // Performance Container
              ],
            ),
          ],
        ),
      ),
    );
  }
}