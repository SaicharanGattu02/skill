import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  final List<Map<String, String>> tasks = [
    {
      'date': 'September 20, 2024',
      'title': 'PRPL Application',
      'subtitle': 'Presentation of new products and cost structure'
    },
    {'date': 'April 23, 2024', 'title': 'Raay Project'},
    {'date': 'April 23, 2024', 'title': 'Dotclinic Project'},
    {
      'date': 'September 20, 2024',
      'title': 'Raay Project',
      'subtitle': 'Presentation of new products and cost structure'
    },
  ];

  final List<String> daysOfWeek = ['Mo', 'Tu', 'Wed', 'Th', 'Fr', 'Sa', 'Su'];
  List<DateTime> dates = [];
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _generateDates();
  }

  // void _generateDates(DateTime month) {
  //   final startOfMonth = DateTime(month.year, month.month, 1);
  //   final endOfMonth = DateTime(month.year, month.month + 1, 0); // Last day of the month
  //   final startOfWeek = startOfMonth.subtract(Duration(days: startOfMonth.weekday - 1)); // Start from Monday
  //
  //   setState(() {
  //     dates = List.generate(7, (index) => startOfWeek.add(Duration(days: index))); // Generate only 7 days for the week
  //   });
  // }
  void _generateDates() {
    final today = DateTime.now();
    final startOfWeek =
    today.subtract(Duration(days: today.weekday - 1)); // Start from Monday
    dates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }
  Future<void> _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Select Month and Year',
      initialDatePickerMode: DatePickerMode.year,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff8856F4), // Change the color of the header
          // Change the color of the selected date
            colorScheme: ColorScheme.light(primary: const Color(0xff8856F4)), // Change color of selected date
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary), // Change button color
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        currentMonth = DateTime(picked.year, picked.month, picked.day);
        _generateDates();
        selectedDate = currentMonth; // Set the selected date to the first of the new month
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    // Format the selected date
    final selectedDateFormatted = DateFormat('MMMM d, y').format(selectedDate);

    // Filter tasks for the selected date
    final selectedTasks =
    tasks.where((task) => task['date'] == selectedDateFormatted).toList();

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
          "Todo",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
            height: 29.05 / 24.0,
          ),
        ),
      ),
      body:
      Container(
        width: w,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF), // Surrounding container color
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month and year display with button to select new month and year
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM d y').format(currentMonth),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff000000),
                    height: 19.36 / 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Color(0xff8856F4)),
                  onPressed: _pickMonth,
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Tasks",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xff8856F4),
                height: 19.36 / 18,
              ),
            ),
            const SizedBox(height: 18),
            // Horizontal Scrollable Calendar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(7, (index) {
                  final isSelected = dates[index].day == selectedDate.day &&
                      dates[index].month == selectedDate.month &&
                      dates[index].year == selectedDate.year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = dates[index]; // Update selected date
                      });
                    },
                    child: ClipRect(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: (w - 65) / 7, // Adjust the width to ensure it fits within one screen
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xffF0EAFF)
                              : Colors.transparent, // Highlight selected date
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
                                    : const Color(0xff000000), // Change color for selected date
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              daysOfWeek[index % 7],
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff94A3B8),
                                fontSize: 12,
                                height: 26 / 12,
                                letterSpacing: 0.3,
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
                itemCount: selectedTasks.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/More-vertical.png",
                              fit: BoxFit.contain,
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 10),
                            ClipOval(
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: const Color(0xffDE350B), width: 3)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedTasks[index]['title']!,
                                    style: const TextStyle(
                                        color: Color(0xff141516),
                                        fontSize: 16,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                        height: 20 / 16),
                                  ),
                                  if (selectedTasks[index]['subtitle'] != null)
                                    Text(
                                      selectedTasks[index]['subtitle']!,
                                      style: const TextStyle(
                                          color: Color(0xff4A4A4A),
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w400,
                                          height: 19.36 / 14),
                                    ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        color: Color(0xff2FB035),
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: w * 0.01,
                                      ),
                                      const Text(
                                        "Today",
                                        style: TextStyle(
                                          color: Color(0xff2FB035),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Inter",
                                          height: 20 / 16,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index != selectedTasks.length - 1) // Add divider except after the last item
                        Divider(
                          color: Color(0xff9AADB6).withOpacity(0.6), // Change color as needed
                          height: 20,
                          thickness: 1,
                        ),
                    ],
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
