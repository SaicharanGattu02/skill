import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Model/ToDoListModel.dart';
import '../Services/UserApi.dart';

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  final List<Map<String, String>> tasks = [
    {
      'date': 'September 23, 2024',
      'title': 'PRPL Application',
      'subtitle': 'Presentation of new products and cost structure'
    },
    {'date': 'September 24, 2024', 'title': 'Raay Project'},
    {'date': 'September 24', 'title': 'Dotclinic Project'},
    {
      'date': 'October 5, 2024',
      'title': 'Raay Project',
      'subtitle': 'Presentation of new products and cost structure'
    },
  ];

  final List<String> daysOfWeek = ['Mo', 'Tu', 'Wed', 'Th', 'Fr', 'Sa', 'Su'];
  List<DateTime> dates = [];
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // _scrollController = ScrollController();
    // _generateDates();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollToSelectedDate();
    // });
    GetToDoList();
  }

  List<TODOList> data = [];
  Future<void> GetToDoList() async {
    var res = await Userapi.gettodolistApi();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          data = res.data ?? [];
        } else {}
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Color hexToColor(String hexColor) {
    // Check if the hex color starts with "#", if so, remove it
    hexColor = hexColor.replaceFirst('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor; // Add full opacity if not provided
    }
    return Color(int.parse(hexColor, radix: 16));
  }


  // void _scrollToSelectedDate() {
  //   final index = dates.indexWhere((date) =>
  //       date.day == selectedDate.day &&
  //       date.month == selectedDate.month &&
  //       date.year == selectedDate.year);
  //
  //   if (index != -1) {
  //     // Scroll to the selected date with some offset to keep it centered
  //     final double offset =
  //         index * 55.0; // Adjust the 55.0 based on the item width
  //     _scrollController.animateTo(
  //       offset,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  // }

  // void _generateDates() {
  //   final startOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
  //   final endOfMonth = DateTime(
  //       currentMonth.year, currentMonth.month + 1, 0); // Last day of the month
  //
  //   setState(() {
  //     dates = List.generate(
  //       endOfMonth.day,
  //       (index) => DateTime(currentMonth.year, currentMonth.month, index + 1),
  //     ); // Generate all dates in the current month
  //   });
  // }

  // Future<void> _pickMonth() async {
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: currentMonth,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //     helpText: 'Select Month and Year',
  //     initialDatePickerMode: DatePickerMode.year,
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           primaryColor:
  //               const Color(0xff8856F4), // Change the color of the header
  //           colorScheme: ColorScheme.light(
  //               primary:
  //                   const Color(0xff8856F4)), // Change color of selected date
  //           buttonTheme: const ButtonThemeData(
  //               textTheme: ButtonTextTheme.primary), // Change button color
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   if (picked != null) {
  //     setState(() {
  //       currentMonth = DateTime(picked.year, picked.month, picked.day);
  //       _generateDates();
  //       selectedDate =
  //           currentMonth; // Set the selected date to the first of the new month
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
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
      body: Container(
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
            // Row(
            //   children: [
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Today",
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w400,
            //             color: Color(0xff8856F4),
            //             height: 19.36 / 16,
            //           ),
            //         ),
            //         Text(
            //           DateFormat('MMMM d, y').format(currentMonth),
            //           style: const TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w400,
            //             color: Color(0xff000000),
            //             fontFamily: "Inter",
            //             height: 19.36 / 14,
            //           ),
            //         ),
            //       ],
            //     ),
            //     Spacer(),
            //     Image.asset(
            //       "assets/sun.png",
            //       width: w * 0.05,
            //       height: w * 0.04,
            //     ),
            //     const SizedBox(width: 4),
            //     Text(
            //       "Now is almost sunny",
            //       style: TextStyle(
            //         fontFamily: 'Inter',
            //         fontSize: 10,
            //         color: Color(0xff64748B),
            //         height: 16.94 / 10,
            //         fontWeight: FontWeight.w400,
            //       ),
            //     ),
            //     const SizedBox(width: 4),
            //     Image.asset(
            //       "assets/sunn.png",
            //       width: 24,
            //       height: 24,
            //     ),
            //   ],
            // ),
            SizedBox(height: 18),
            // SingleChildScrollView(
            //   controller: _scrollController,
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: List.generate(dates.length, (index) {
            //       final isSelected = dates[index].day == selectedDate.day &&
            //           dates[index].month == selectedDate.month &&
            //           dates[index].year == selectedDate.year;
            //
            //       return GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             selectedDate = dates[index]; // Update selected date
            //           });
            //           _scrollToSelectedDate(); // Scroll to selected date when tapped
            //         },
            //         child: ClipRect(
            //           child: Container(
            //             padding: const EdgeInsets.symmetric(vertical: 10),
            //             width: 55,
            //             decoration: BoxDecoration(
            //               color: isSelected
            //                   ? const Color(0xffF0EAFF)
            //                   : Colors.transparent, // Highlight selected date
            //               borderRadius: BorderRadius.circular(16),
            //             ),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Text(
            //                   dates[index].day.toString(),
            //                   style: TextStyle(
            //                     fontSize: 16,
            //                     color: isSelected
            //                         ? const Color(0xff8856F4)
            //                         : const Color(
            //                             0xff000000), // Change color for selected date
            //                   ),
            //                 ),
            //                 const SizedBox(height: 2),
            //                 Text(
            //                   daysOfWeek[dates[index].weekday - 1],
            //                   style: const TextStyle(
            //                     fontWeight: FontWeight.w400,
            //                     color: Color(0xff94A3B8),
            //                     fontSize: 12,
            //                     height: 26 / 12,
            //                     letterSpacing: 0.3,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     }),
            //   ),
            // ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var tododata = data[index];
                  Color labelColor = hexToColor(tododata.labelColor??"");
                  print("Color:${labelColor}");// Convert hex to Color

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon or image on the left
                            Image.asset(
                              "assets/More-vertical.png",
                              fit: BoxFit.contain,
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 10),
                            // Red circular indicator
                            ClipOval(
                              child: Container(
                                width: w * 0.045,
                                height: w * 0.045,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: labelColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tododata.labelName ?? "",
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Color(0xff141516),
                                      height: 16.94 / 13,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: w * 0.5,
                                    child: Text(
                                      tododata.description ?? "",
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                        color: Color(0xff475569),
                                        height: 14.52 / 12.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Task date row
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        color: Color(0xff2FB035),
                                        size: 16,
                                      ),
                                      SizedBox(width: w * 0.01),
                                      Text(
                                        tododata.dateTime ?? "",
                                        style: TextStyle(
                                          color: Color(0xff2FB035),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Inter",
                                          height: 20 / 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: w * 0.04,
                              height: w * 0.04,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: const Color(0xff8856F4),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                  child: Image.asset(
                                "assets/crossblue.png",
                                fit: BoxFit.contain,
                                width: 5,
                                height: 5,
                                color: Color(0xff8856F4),
                              )),
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      Divider(
                        thickness: 1,
                        color: const Color(0xff94A3B8).withOpacity(0.3),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
