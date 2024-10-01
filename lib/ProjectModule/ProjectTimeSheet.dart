import 'package:flutter/material.dart';

import '../Model/CreateRoomModel.dart';

class TimeSheet extends StatefulWidget {
  final String id;
  const TimeSheet({super.key,required this.id});

  @override
  State<TimeSheet> createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> {
  int selectedTabIndex = 0;
  List<Data> data = [];
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffEFE2FF).withOpacity(0.1),
      body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
            Container(
            width: w,
            height: w * 0.08,
            decoration: BoxDecoration(
              color: Color(0xFF9B5FFF), // Purple background
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 1, color: Color(0xFF9B5FFF)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Details Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTabIndex = 0; // Selecting Details
                    });
                  },
                  child: Container(
                    width: w * 0.3,
                    height: w * 0.08,
                    decoration: BoxDecoration(
                      color: selectedTabIndex == 0
                          ? Colors.white
                          : Color(0xFF9B5FFF), // White background if selected, purple if not
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/detail.png",
                          width: 16,
                          height: 16,
                          color: selectedTabIndex == 0
                              ? Color(0xFF9B5FFF)
                              : Colors.white, // Purple icon if selected, white if not
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Details",
                          style: TextStyle(
                            color: selectedTabIndex == 0
                                ? Color(0xFF9B5FFF)
                                : Colors.white, // Purple text if selected, white if not
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            height: 14.52 / 12,
                            letterSpacing: 0.59,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Summary Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTabIndex = 1; // Selecting Summary
                    });
                  },
                  child: Container(
                    width: w * 0.3,
                    height: w * 0.08,
                    decoration: BoxDecoration(
                      color: selectedTabIndex == 1
                          ? Colors.white
                          : Color(0xFF9B5FFF), // White background if selected, purple if not
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/summary.png",
                          width: 16,
                          height: 16,
                          color: selectedTabIndex == 1
                              ? Color(0xFF9B5FFF)
                              : Colors.white, // Purple icon if selected, white if not
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Summary",
                          style: TextStyle(
                            color: selectedTabIndex == 1
                                ? Color(0xFF9B5FFF)
                                : Colors.white, // Purple text if selected, white if not
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            height: 14.52 / 12,
                            letterSpacing: 0.59,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Chart Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTabIndex = 2; // Selecting Chart
                    });
                  },
                  child: Container(
                    width: w * 0.3,
                    height: w * 0.08,
                    decoration: BoxDecoration(
                      color: selectedTabIndex == 2
                          ? Colors.white
                          : Color(0xFF9B5FFF), // White background if selected, purple if not
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/chart.png",
                          width: 16,
                          height: 16,
                          color: selectedTabIndex == 2
                              ? Color(0xFF9B5FFF)
                              : Colors.white, // Purple icon if selected, white if not
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Chart",
                          style: TextStyle(
                            color: selectedTabIndex == 2
                                ? Color(0xFF9B5FFF)
                                : Colors.white, // Purple text if selected, white if not
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            height: 14.52 / 12,
                            letterSpacing: 0.59,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Container(
                    width: w * 0.61,
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
                  Spacer(),
                  SizedBox(
                    height: w * 0.09,
                    child: InkWell(
                      onTap: () {
                        // showModalBottomSheet(
                        //   context: context,
                        //   isScrollControlled: true,
                        //   // isDismissible: false,
                        //
                        //   builder: (BuildContext context) {
                        //     return _bottomSheet(context);
                        //   },
                        // );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Color(0xff8856F4),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/circleadd.png",
                              fit: BoxFit.contain,
                              width: w * 0.045,
                              height: w * 0.05,
                              color: Color(0xffffffff),
                            ),
                            SizedBox(
                              width: w * 0.01,
                            ),
                            Text(
                              "Add Files",
                              style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  fontFamily: "Inter",
                                  height: 16.94 / 12,
                                  letterSpacing: 0.59),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final projectfile = data[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/calendar.png",
                              fit: BoxFit.contain,
                              width: w * 0.06,
                              height: w * 0.05,
                              color: Color(0xff6C848F),
                            ),
                            SizedBox(
                              width: w * 0.004,
                            ),
                            Text(
                              // note.createdTime?? "",
                              "01/01/0000",
                              style: TextStyle(
                                color: const Color(0xff1D1C1D),
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                height: 19.41 / 15,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: "Inter",
                              ),
                            ),
                            Spacer(),
                            Image.asset(
                              "assets/download.png",
                              fit: BoxFit.contain,
                              width: w * 0.06,
                              height: w * 0.05,
                              color: Color(0xff8856F4),
                            ),
                            SizedBox(
                              width: w * 0.025,
                            ),
                            Image.asset(
                              "assets/edit.png",
                              fit: BoxFit.contain,
                              width: w * 0.06,
                              height: w * 0.05,
                              color: Color(0xff8856F4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                "assets/gallery.png",
                                fit: BoxFit.contain,
                                color: Color(0xffBE63F9),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 21.78 / 15,
                                    color: Color(0xff1D1C1D),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 16 / 14,
                                    color: Color(0xff1D1C1D),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Row(
                                //   children: [
                                //     if ( projectfile.fileUrl!= null)
                                //       Padding(
                                //         padding: const EdgeInsets.only(right: 4.0),
                                //         child: ClipOval(
                                //           child: Image.network(
                                //             projectfile.fileUrl.toString() ?? "",
                                //             width: 24,
                                //             height: 24,
                                //             fit: BoxFit.cover,
                                //           ),
                                //         ),
                                //       ),
                                //     SizedBox(
                                //       width: w * 0.01,
                                //     ),
                                //     Text(
                                //       projectfile.uploadedBy ?? "",
                                //       style: TextStyle(
                                //         color: Color(0xff371F41),
                                //         fontFamily: 'Inter',
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.w400,
                                //         height: 18.36 / 14,
                                //       ),
                                //     )
                                //   ],
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
}
