import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';

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

  // Sample task data
  final List<Map<String, String>> tasks = [
    {
      "date": "2/28/2024",
      "time": "8:30–9:00 AM",
      "title": "Presentation of new products and cost structure.",
      "link": "https://zoom.us/i/1983475281",
    },
  ];

  // List of image assets for collaborators
  final List<String> imageList = [
    "assets/prashanth.png",
    "assets/prashanth.png",
    "assets/prashanth.png",
    "assets/prashanth.png",
    "assets/prashanth.png",
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
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
      final double offset = index * 55.0; // Adjust the 55.0 based on the item width
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
          "Meetings",
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Good Morning,",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Prashanth,",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  "assets/sun.png",
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "Now is almost sunny",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    color: Color(0xff64748B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  "assets/sunn.png",
                  width: 24,
                  height: 24,
                ),
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
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffD0CBDB), width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
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
                              task["date"]!,
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
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: Color(0xff3B82F6),
                                      borderRadius: BorderRadius.circular(100)),
                                )),
                            SizedBox(width: w * 0.008),
                            Column(
                              children: [
                                Text(
                                  task["time"]!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 16 / 12,
                                    color: Color(0xff4A4A4A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(width: w * 0.008),
                            ClipOval(
                              child: Container( width: 12,
                                height: 12,
                                padding:EdgeInsets.all(2),
                                decoration:BoxDecoration(color: Color(0xffF0EAFF),borderRadius: BorderRadius.circular(100)),
                                child: Image.asset(
                                  "assets/meet.png",
                                  width: 4,height: 4,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task["title"]!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff141516),
                            height: 16 / 21,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task["link"]!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            height: 16 / 14,
                            decoration:TextDecoration.underline,
                            decorationColor: Color(0xffDE350B),
                            fontWeight: FontWeight.w400,
                            color: Color(0xffDE350B),
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
}