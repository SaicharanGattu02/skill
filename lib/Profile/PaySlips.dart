import 'package:flutter/material.dart';

class PaySlips extends StatefulWidget {
  const PaySlips({super.key});

  @override
  State<PaySlips> createState() => _PaySlipsState();
}

class _PaySlipsState extends State<PaySlips> {
  List<Map<String, String>> paySlipDates = [
    {'month': 'November', 'date': '01, 2024'},
    {'month': 'October', 'date': '01, 2024'},
    {'month': 'September', 'date': '01, 2024'},
    {'month': 'August', 'date': '01, 2024'},
    {'month': 'July', 'date': '01, 2024'},
    {'month': 'September', 'date': '01, 2024'},
    {'month': 'August', 'date': '01, 2024'},
    {'month': 'July', 'date': '01, 2024'},
  ];
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffF3ECFB),
      body: Container(
        width: w,
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            SizedBox(
              width: w,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xff9E7BCA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/search.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            isCollapsed: true,
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
                          style: TextStyle(
                            color: Color(0xff9E7BCA),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            fontFamily: "Nunito",
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                      Spacer(),
                      Image.asset(
                        "assets/calendar.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(height: h * 0.02),
            // // Select All and Action Icons
            // Row(
            //   children: [
            //     Text('Select All',
            //         style: TextStyle(
            //           color: Color(0xff1D1C1D),
            //           fontFamily: 'Inter',
            //           fontSize: 16,
            //           height: 19.36 / 16,
            //           fontWeight: FontWeight.w400,
            //         )),
            //     Spacer(),
            //     Image.asset(
            //       'assets/share.png',
            //       width: w * 0.06,
            //       height: w * 0.05,
            //       color: Color(0xff6C848F),
            //     ),
            //     SizedBox(width: w * 0.04),
            //     Image.asset(
            //       "assets/download.png",
            //       fit: BoxFit.contain,
            //       width: w * 0.07,
            //       height: w * 0.06,
            //       color: Color(0xff8856F4),
            //     ),
            //   ],
            // ),
            SizedBox(height: h * 0.02),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: paySlipDates.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(height: h * 0.02),
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Color(0xffF5E6FE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                "assets/doc.png",
                                fit: BoxFit.contain,
                                color: Color(0xffBE63F9),
                              ),
                            ),
                            SizedBox(width: w * 0.04),
                            Text(paySlipDates[index]['month'] ?? "",
                                style: TextStyle(
                                  color: Color(0xff2E2E30),
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  height: 19.36 / 15,
                                  fontWeight: FontWeight.w400,
                                )),
                            Spacer(),
                            Image.asset(
                              'assets/share.png',
                              width: w * 0.06,
                              height: w * 0.05,
                              color: Color(0xff6C848F),
                            ),
                            SizedBox(width: w * 0.02),
                            Image.asset(
                              "assets/download.png",
                              fit: BoxFit.contain,
                              width: w * 0.07,
                              height: w * 0.06,
                              color: Color(0xff8856F4),
                            ),
                            SizedBox(width: w * 0.02),
                            Image.asset(
                              'assets/eye.png',
                              width: w * 0.06,
                              height: w * 0.05,
                              color: Color(0xff6C848F),
                            ),
                          ],
                        ),
                        SizedBox(height: h * 0.02),
                        // Divider
                        Container(
                          width: w,
                          height: h * 0.002,
                          decoration: BoxDecoration(color: Color(0xffEFF0FA)),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
