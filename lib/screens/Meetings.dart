import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:intl/intl.dart';
import 'package:skill/Services/UserApi.dart';
import 'package:skill/screens/AddMeetings.dart';
import 'package:skill/utils/CustomAppBar.dart';

import '../Model/MeetingModel.dart';
import '../utils/Mywidgets.dart';

class Meetings extends StatefulWidget {
  const Meetings({super.key});

  @override
  State<Meetings> createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  final List<String> daysOfWeek = ['Mo', 'Tu', 'Wed', 'Th', 'Fr', 'Sa', 'Su'];
  List<DateTime> dates = [];
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();
  late ScrollController _scrollController;
  bool _loading = true;
  String formattedDate = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
    formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    getMeeting(formattedDate);
  }

  List<Data> meetings = [];
  // Future<void> getMeeting() async {
  //   var res = await Userapi.GetMeeting();
  //   setState(() {
  //     if (res != null) {
  //       if (res.data != null) {
  //         _loading = false;
  //         meetings = res.data ?? [];
  //         print("projectsData List Get SuccFully  ${res.settings!.message}");
  //       } else {
  //         _loading = false;
  //         print("Employee List Failure  ${res.settings?.message}");
  //       }
  //     }
  //   });
  // }

  Future<void> getMeeting(String date) async {
    var res = await Userapi.GetMeetingbydate(date);
    setState(() {
      if (res != null) {
        if(res.settings?.success==1){
          _loading = false;
          meetings = res.data ?? [];
        }else{
          _loading = false;
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    final index = dates.indexWhere((date) =>
        date.day == selectedDate.day &&
        date.month == selectedDate.month &&
        date.year == selectedDate.year);

    if (index != -1) {
      final double offset =
          index * 55.0; // Adjust the 55.0 based on the item width
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _generateDates() {
    final startOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final endOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    setState(() {
      dates = List.generate(
        endOfMonth.day,
        (index) => DateTime(currentMonth.year, currentMonth.month, index + 1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: CustomAppBar(
        title: 'Meetings',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () async {
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddMeetings(), // Replace with your destination screen
                  ),
                );
                if (res == true) {
                  setState(() {
                    _loading = true;
                  });
                  getMeeting(formattedDate);
                }
              },
              child: Image.asset(
                "assets/Plus square.png",
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: w,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff8856F4),
                        height: 19.36 / 16,
                      ),
                    ),
                    Text(
                      DateFormat('MMMM d, y').format(currentMonth),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                        fontFamily: "Inter",
                        height: 19.36 / 14,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                // Image.asset(
                //   "assets/sun.png",
                //   width: w * 0.05,
                //   height: w * 0.04,
                // ),
                // const SizedBox(width: 4),
                // Text(
                //   "Now is almost sunny",
                //   style: TextStyle(
                //     fontFamily: 'Inter',
                //     fontSize: 10,
                //     color: Color(0xff64748B),
                //     height: 16.94 / 10,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
                // const SizedBox(width: 4),
                // Image.asset(
                //   "assets/sunn.png",
                //   width: 24,
                //   height: 24,
                // ),
              ],
            ),
            const SizedBox(height: 18),
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(dates.length, (index) {
                  final isSelected = dates[index].day == selectedDate.day &&
                      dates[index].month == selectedDate.month &&
                      dates[index].year == selectedDate.year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = dates[index];
                        formattedDate =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                        print("selectedDate: $formattedDate");
                        meetings=[];
                        _loading=true;
                        getMeeting(formattedDate);
                      });
                      _scrollToSelectedDate();
                    },
                    child: ClipRect(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: 55,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xffF0EAFF)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dates[index].day.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected
                                    ? const Color(0xff8856F4)
                                    : const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              daysOfWeek[dates[index].weekday - 1],
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff94A3B8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child:(_loading)?_buildShimmerList():
              meetings.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Image.asset(
                            'assets/nodata1.png',
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
                  : ListView.builder(
                      itemCount: meetings.length,
                      itemBuilder: (context, index) {
                        final task = meetings[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffD0CBDB), width: 0.7),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Today",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff9AADB6),
                                        height: 20 / 15,
                                        fontFamily: "Inter"),
                                  ),
                                  SizedBox(width: w * 0.009),
                                  Text(
                                    task.startDate ?? "",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff9AADB6),
                                      fontFamily: "Inter",
                                      height: 20 / 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ClipOval(
                                      child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        color: Color(0xff3B82F6),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  )),
                                  SizedBox(width: w * 0.008),
                                  Column(
                                    children: [
                                      Text(
                                        task.startDate ?? "",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          height: 16 / 12,
                                          color: Color(0xff4A4A4A),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: w * 0.008),
                                  ClipOval(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: Color(0xffF0EAFF),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Image.asset(
                                        "assets/meet.png",
                                        width: 4,
                                        height: 4,
                                        color: Color(0xff000000),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                task.title ?? "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff141516),
                                  height: 16 / 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                task.meetingLink ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  height: 16 / 14,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xffDE350B),
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffDE350B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 1, bottom: 1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color(0xff2FB035)),
                                child: Text(
                                  task.meetingLink ?? "",
                                  style: TextStyle(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      height: 19.41 / 12,
                                      letterSpacing: 0.14,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Inter"),
                                ),
                              ),
                            ],
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
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10, // Adjust the number of shimmer items as needed
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26, // Adjust shadow color
                offset: Offset(0, 2), // Change the offset as needed
                blurRadius: 8, // Change the blur radius as needed
                spreadRadius: 1, // Change the spread radius as needed
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  shimmerText(50, 15), // Shimmer for "Today" label
                  const Spacer(),
                  shimmerRectangle(24), // Shimmer for delete icon
                  const SizedBox(width: 8),
                  shimmerRectangle(24), // Shimmer for edit icon
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  shimmerCircle(10), // Shimmer for status dot
                  const SizedBox(width: 8),
                  shimmerText(150, 12), // Shimmer for start date
                  const SizedBox(width: 8),
                  shimmerCircle(12), // Shimmer for meeting icon
                ],
              ),
              const SizedBox(height: 8),
              shimmerText(150, 12), // Shimmer for task title
              const SizedBox(height: 8),
              shimmerText(200, 12), // Shimmer for meeting link
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey[300], // Shimmer background color
                ),
                child: shimmerText(100, 12), // Shimmer for meeting link button
              ),
            ],
          ),
        );
      },
    );
  }

}
