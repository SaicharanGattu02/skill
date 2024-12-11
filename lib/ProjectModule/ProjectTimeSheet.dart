import 'package:flutter/material.dart';
import 'package:skill/ProjectModule/AddLogTime.dart';
import 'package:skill/Services/UserApi.dart';
import '../Model/TimeSheeetDeatilModel.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/app_colors.dart';

class TimeSheet extends StatefulWidget {
  final String id;
  const TimeSheet({super.key, required this.id});

  @override
  State<TimeSheet> createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> {
  final TextEditingController _searchController = TextEditingController();
  void initState() {
    _searchController.addListener(filterData); // Add listener for search
    TimeSheetDetails();
    super.initState();
  }

  void filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredData = data.where((item) {
        return (item.member?.toLowerCase().contains(query) ?? false) ||
            (item.task?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(filterData); // Remove listener
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }


  int selectedTabIndex = 0;
  bool isloading=true;

  List<Data> data = []; // Original list of notes
  List<Data> filteredData = []; // Filtered list for search
  Future<void> TimeSheetDetails() async {
    var res = await Userapi.GetProjectTimeSheetDetails(widget.id);
    setState(() {
      if (res != null) {
        if(res.settings?.success==1) {
          isloading=false;
          data = res.data ?? [];
          filteredData = res.data ?? [];
        }else{
          isloading=false;
          CustomSnackBar.show(context,res.settings?.message??"");
        }
      } else {
        print("not fetch");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffEFE2FF).withOpacity(0.1),
      body:

      // (isloading)?Center(
      //   child: CircularProgressIndicator(color: Color(0xff8856F4),),
      // ):
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Container(
              //   width: w,
              //   height: w * 0.08,
              //   decoration: BoxDecoration(
              //     color: Color(0xFF9B5FFF), // Purple background
              //     borderRadius: BorderRadius.circular(100),
              //     border: Border.all(width: 1, color: Color(0xFF9B5FFF)),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       // Details Button
              //       GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             selectedTabIndex = 0; // Selecting Details
              //           });
              //         },
              //         child: Container(
              //           width: w * 0.3,
              //           height: w * 0.08,
              //           decoration: BoxDecoration(
              //             color: selectedTabIndex == 0
              //                 ? Color(0xFF9B5FFF)
              //                 : Colors.white,
              //             borderRadius: BorderRadius.only(
              //               bottomLeft: Radius.circular(50),
              //               topLeft: Radius.circular(50),
              //             ),
              //           ),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Image.asset(
              //                 "assets/detail.png",
              //                 width: 16,
              //                 height: 16,
              //                 color: selectedTabIndex == 0
              //                     ? Colors.white
              //                     : Color(0xFF9B5FFF),
              //                 fit: BoxFit.contain,
              //               ),
              //               SizedBox(width: 8),
              //               Text(
              //                 "Details",
              //                 style: TextStyle(
              //                   color: selectedTabIndex == 0
              //                       ? Colors.white
              //                       : Color(
              //                           0xFF9B5FFF), // Purple text if selected, white if not
              //                   fontWeight: FontWeight.w500,
              //                   fontSize: 12,
              //                   fontFamily: 'Inter',
              //                   height: 14.52 / 12,
              //                   letterSpacing: 0.59,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //
              //       // Summary Button
              //       GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             selectedTabIndex = 1; // Selecting Summary
              //           });
              //         },
              //         child: Container(
              //           width: w * 0.3,
              //           height: w * 0.08,
              //           decoration: BoxDecoration(
              //             color: selectedTabIndex == 1
              //                 ? Color(0xFF9B5FFF)
              //                 : Colors
              //                     .white, // White background if selected, purple if not
              //           ),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Image.asset(
              //                 "assets/summary.png",
              //                 width: 16,
              //                 height: 16,
              //                 color: selectedTabIndex == 1
              //                     ? Colors.white
              //                     : Color(
              //                         0xFF9B5FFF), // Purple icon if selected, white if not
              //                 fit: BoxFit.contain,
              //               ),
              //               SizedBox(width: 8),
              //               Text(
              //                 "Summary",
              //                 style: TextStyle(
              //                   color: selectedTabIndex == 1
              //                       ? Colors.white
              //                       : Color(
              //                           0xFF9B5FFF), // Purple text if selected, white if not
              //                   fontWeight: FontWeight.w500,
              //                   fontSize: 12,
              //                   fontFamily: 'Inter',
              //                   height: 14.52 / 12,
              //                   letterSpacing: 0.59,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //
              //       // Chart Button
              //       GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             selectedTabIndex = 2; // Selecting Chart
              //           });
              //         },
              //         child: Container(
              //           width: w * 0.3,
              //           height: w * 0.08,
              //           decoration: BoxDecoration(
              //             color: selectedTabIndex == 2
              //                 ? Color(0xFF9B5FFF)
              //                 : Colors
              //                     .white, // White background if selected, purple if not
              //             borderRadius: BorderRadius.only(
              //               topRight: Radius.circular(50),
              //               bottomRight: Radius.circular(50),
              //             ),
              //           ),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Image.asset(
              //                 "assets/chart.png",
              //                 width: 16,
              //                 height: 16,
              //                 color: selectedTabIndex == 2
              //                     ? Colors.white
              //                     : Color(
              //                         0xFF9B5FFF), // Purple icon if selected, white if not
              //                 fit: BoxFit.contain,
              //               ),
              //               SizedBox(width: 8),
              //               Text(
              //                 "Chart",
              //                 style: TextStyle(
              //                   color: selectedTabIndex == 2
              //                       ? Colors.white
              //                       : Color(
              //                           0xFF9B5FFF), // Purple text if selected, white if not
              //                   fontWeight: FontWeight.w500,
              //                   fontSize: 12,
              //                   fontFamily: 'Inter',
              //                   height: 14.52 / 12,
              //                   letterSpacing: 0.59,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 16,
              // ),
              Row(
                children: [
                  Container(
                    width: w * 0.63,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                    Row(
                      children: [
                        Image.asset(
                          "assets/search.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 10),

                        Expanded(
                          child: TextField(
                            controller: _searchController,
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
                                decorationColor: Color(0xff9E7BCA),
                                fontFamily: "Nunito",
                                overflow: TextOverflow.ellipsis),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: w * 0.09,
                    child: InkWell(
                      onTap: () async {
                        var res= await Navigator.push(context,MaterialPageRoute(builder: (context) => Addlogtime(projectId: widget.id,)));
                        if(res==true){
                          TimeSheetDetails();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
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
                              "Log Time",
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
              if (selectedTabIndex == 0) ...[
                isloading?_buildShimmerList():
                filteredData.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*0.24,),
                      Image.asset(
                        'assets/nodata1.png', // Make sure to use the correct image path
                        width:
                        150, // Adjust the size according to your design
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "No Data Found",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontFamily: "Inter",
                        ),
                      ),
                    ],
                  ),
                )

                    :
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final detail = filteredData[index];
                    String isoDate = detail.startTime ?? "";
                    String isoDate1 = detail.endTime ?? "";

                    String formattedTime = DateTimeFormatter.format(isoDate, includeDate: false, includeTime: true);
                    String formattedTime1 = DateTimeFormatter.format(isoDate1, includeDate: false, includeTime: true);

                    print("Start Time: $formattedTime");
                    print("End Time: $formattedTime1");

                    print("time>>>${formattedTime1}");
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Start Time",
                                    style: TextStyle(
                                      color: const Color(0xff6C848F),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      height: 19.41 / 16,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                  SizedBox(
                                    height: w * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/tasktime.png",
                                        fit: BoxFit.contain,
                                        width: w * 0.04,
                                        height: w * 0.04,
                                        color: Color(0xff6C848F),
                                      ),
                                      SizedBox(
                                        width: w * 0.01,
                                      ),
                                      Container(
                                        width: w * 0.3,
                                        child: Text(
                                          "${formattedTime}",
                                          style: TextStyle(
                                            color: const Color(0xff1D1C1D),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            height: 16.94 / 14,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: "Inter",
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "End Time",
                                    style: TextStyle(
                                      color: const Color(0xff6C848F),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      height: 19.41 / 16,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                  SizedBox(
                                    height: w * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/tasktime.png",
                                        fit: BoxFit.contain,
                                        width: w * 0.04,
                                        height: w * 0.04,
                                        color: Color(0xff6C848F),
                                      ),
                                      SizedBox(
                                        width: w * 0.01,
                                      ),
                                      Container(
                                        width: w * 0.3,
                                        child: Text(
                                          "${formattedTime1}",
                                          style: TextStyle(
                                            color: const Color(0xff1D1C1D),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            height: 16.94 / 14,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: "Inter",
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // const SizedBox(height: 12),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       "End Time",
                          //       style: TextStyle(
                          //         color: const Color(0xff6C848F),
                          //         fontWeight: FontWeight.w500,
                          //         fontSize: 16,
                          //         height: 19.41 / 16,
                          //         overflow: TextOverflow.ellipsis,
                          //         fontFamily: "Inter",
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: w * 0.004,
                          //     ),
                          //     Row(
                          //       children: [
                          //         Image.asset(
                          //           "assets/tasktime.png",
                          //           fit: BoxFit.contain,
                          //           width: w * 0.045,
                          //           height: w * 0.045,
                          //           color: Color(0xff6C848F),
                          //         ),
                          //         SizedBox(
                          //           width: w * 0.004,
                          //         ),
                          //         Text(
                          //           detail.startTime?? "",
                          //           style: TextStyle(
                          //             color: const Color(0xff1D1C1D),
                          //             fontWeight: FontWeight.w400,
                          //             fontSize: 14,
                          //             height: 16.94 / 14,
                          //             overflow: TextOverflow.ellipsis,
                          //             fontFamily: "Inter",
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (detail.image != null)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: ClipOval(
                                        child: Image.network(
                                          detail.image.toString() ?? "",
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        detail.member ?? "",
                                        // "Prashanth Chary",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 24.01 / 14,
                                          color: Color(0xff1D1C1D),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        detail.task ?? "",
                                        // "Task - Admin Backend",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          height: 18.15 / 15,
                                          color: Color(0xff1D1C1D),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: w * 0.72,
                                        child: Text(
                                          detail.note ?? "",
                                          // "Note - Brief summary of the project's main objectives and significance",
                                          style: TextStyle(
                                            color: Color(0xff371F41),
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            height: 18.36 / 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/tasktime.png",
                                    fit: BoxFit.contain,
                                    width: w * 0.045,
                                    height: w * 0.045,
                                    color: Color(0xff6C848F),
                                  ),
                                  SizedBox(
                                    width: w * 0.02,
                                  ),
                                  Text(
                                    // note.createdTime?? "",
                                    "Total Hours : ",
                                    style: TextStyle(
                                      color: const Color(0xff6C848F),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      height: 16.94 / 14,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                  SizedBox(
                                    width: w * 0.002,
                                  ),
                                  Text(
                                    detail.total ?? "",
                                    // "0245:00 ",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      height: 16.94 / 14,
                                      fontFamily: "Inter",
                                    ),
                                  ),
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
              // if (selectedTabIndex == 1) ...[
              //   ListView.builder(
              //     shrinkWrap: true,
              //     physics: NeverScrollableScrollPhysics(),
              //     itemCount: data.length,
              //     itemBuilder: (context, index) {
              //       final detail = data[index];
              //       return Container(
              //         margin: const EdgeInsets.symmetric(vertical: 6),
              //         padding: const EdgeInsets.all(16),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(7),
              //         ),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 if (detail.image != null)
              //                   Padding(
              //                     padding: const EdgeInsets.only(right: 4.0),
              //                     child: ClipOval(
              //                       child: Image.network(
              //                         detail.image.toString() ?? "",
              //                         width: 24,
              //                         height: 24,
              //                         fit: BoxFit.cover,
              //                       ),
              //                     ),
              //                   ),
              //                 const SizedBox(width: 8),
              //                 Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       detail.member ?? "",
              //                       // "Prashanth Chary",
              //                       style: const TextStyle(
              //                         fontSize: 14,
              //                         height: 24.01 / 14,
              //                         color: Color(0xff1D1C1D),
              //                         fontWeight: FontWeight.w500,
              //                         fontFamily: 'Inter',
              //                       ),
              //                     ),
              //                     const SizedBox(height: 10),
              //                     Text(
              //                       detail.task ?? "",
              //                       // "Task - Admin Backend",
              //                       style: const TextStyle(
              //                         fontSize: 15,
              //                         height: 18.15 / 15,
              //                         color: Color(0xff1D1C1D),
              //                         fontWeight: FontWeight.w600,
              //                         fontFamily: 'Inter',
              //                       ),
              //                     ),
              //                     const SizedBox(height: 6),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //             SizedBox(
              //               height: 16,
              //             ),
              //             Row(
              //               children: [
              //                 Image.asset(
              //                   "assets/tasktime.png",
              //                   fit: BoxFit.contain,
              //                   width: w * 0.04,
              //                   height: w * 0.04,
              //                   color: Color(0xff6C848F),
              //                 ),
              //                 SizedBox(
              //                   width: w * 0.01,
              //                 ),
              //                 Text(
              //                   // note.createdTime?? "",
              //                   "Duration:",
              //                   style: TextStyle(
              //                     color: const Color(0xff6C848F),
              //                     fontWeight: FontWeight.w400,
              //                     fontSize: 12,
              //                     height: 16.94 / 12,
              //                     fontFamily: "Inter",
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: w * 0.001,
              //                 ),
              //                 Text(
              //                   detail.total ?? "",
              //                   // "0245:00 ",
              //                   style: TextStyle(
              //                     color: const Color(0xff8856F4),
              //                     fontWeight: FontWeight.w500,
              //                     fontSize: 13,
              //                     height: 16.94 / 13,
              //                     fontFamily: "Inter",
              //                   ),
              //                 ),
              //                 Spacer(),
              //                 Image.asset(
              //                   "assets/tasktime.png",
              //                   fit: BoxFit.contain,
              //                   width: w * 0.04,
              //                   height: w * 0.04,
              //                   color: Color(0xff6C848F),
              //                 ),
              //                 SizedBox(
              //                   width: w * 0.01,
              //                 ),
              //                 Text(
              //                   // note.createdTime?? "",
              //                   "Total Hours:",
              //                   style: TextStyle(
              //                     color: const Color(0xff6C848F),
              //                     fontWeight: FontWeight.w500,
              //                     fontSize: 13,
              //                     height: 16.94 / 13,
              //                     fontFamily: "Inter",
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: w * 0.002,
              //                 ),
              //                 Text(
              //                   detail.total ?? "",
              //                   // "0245:00 ",
              //                   style: TextStyle(
              //                     color: const Color(0xff8856F4),
              //                     fontWeight: FontWeight.w700,
              //                     fontSize: 14,
              //                     height: 16.94 / 14,
              //                     fontFamily: "Inter",
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ],
              //
              //
              // if (selectedTabIndex == 2) ...[
              //   ListView.builder(
              //     shrinkWrap: true,
              //     physics: NeverScrollableScrollPhysics(),
              //     itemCount: 1,
              //     itemBuilder: (context, index) {
              //       // final detail = data[index];
              //       return Container(
              //         margin: const EdgeInsets.symmetric(vertical: 6),
              //         padding: const EdgeInsets.all(16),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(7),
              //         ),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ]
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildShimmerList() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      itemCount: 5, // Set the number of shimmer items you want to show
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerText(80, 16,context), // Shimmer for "Start Time"
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          shimmerRectangle(20,context), // Shimmer for time icon
                          const SizedBox(width: 8),
                          shimmerText(100, 14,context), // Shimmer for formatted time
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerText(80, 16,context), // Shimmer for "End Time"
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          shimmerRectangle(20,context), // Shimmer for time icon
                          const SizedBox(width: 8),
                          shimmerText(100, 14,context), // Shimmer for formatted time
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  shimmerCircle(24,context), // Shimmer for member image
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerText(120, 14,context), // Shimmer for member name
                      const SizedBox(height: 6),
                      shimmerText(150, 15,context), // Shimmer for task
                      const SizedBox(height: 6),
                      shimmerText(200, 14,context), // Shimmer for note
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  shimmerRectangle(20,context), // Shimmer for time icon
                  const SizedBox(width: 8),
                  shimmerText(100, 14,context), // Shimmer for "Total Hours"
                  const SizedBox(width: 4),
                  shimmerText(50, 14,context), // Shimmer for total time value
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}
