import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:intl/intl.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final List<String> daysOfWeek = ['Mo', 'Tu', 'Wed', 'Th', 'Fr', 'Sa', 'Su'];
  List<DateTime> dates = [];
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();
  late ScrollController _scrollController;

  // Sample task data
  final List<Map<String, String>> tasks = [
    {
      "title": "Plan and conduct user research and competitor analysis.",
      "subtitle": "Brainstorming brings team members' diverse experience into play.",
      "collaborators": "+6 Collaborators",
      "startDate": "10-09-2024",
      "endDate": "10-09-2024",
    },
    {
      "title": "Interpret data and qualitative feedback.",
      "subtitle": "Brainstorming brings team members' diverse experience into play.",
      "collaborators": "+6 Collaborators",
      "startDate": "10-09-2024",
      "endDate": "10-09-2024",
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
          "Tasks",
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM d, y').format(currentMonth),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                    height: 19.36 / 16,
                  ),
                ),
                // IconButton(
                //   icon: const Icon(Icons.calendar_today, color: Color(0xff8856F4)),
                //   onPressed: _pickMonth,
                // ),

              ],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff8856F4),
                    height: 19.36 / 18,
                  ),
                ),
                Spacer(),
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
                    height: 16.94/14,
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
                        Text(
                          task["title"]!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1D1C1D),
                            height: 21 / 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task["subtitle"]!,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 16 / 12,
                            color: Color(0xff787486),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Adding the images before the collaborators text
                            ...List.generate(1, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: ClipOval(
                                  child: Image.asset(
                                    imageList[index],
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(width: 4),
                            Text(
                              task["collaborators"]!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Start Date: ",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff64748B),
                              ),
                            ),
                            Text(
                             "${task["startDate"]!}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff64748B),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "End Date: ",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff64748B),
                              ),
                            ),
                            Text(
                              "${task["endDate"]!}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff64748B),
                              ),
                            ),
                          ],
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
