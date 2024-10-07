import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill/screens/AddTaskScreen.dart';

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
    var h = MediaQuery.of(context).size.height;
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
            Navigator.pop(context); // Goes back to the previous screen
          },
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
          ),
        ),
        title: Row(
          children: [
            Text(
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
            Spacer(),
            InkWell(
              onTap: () {
                // Navigate to AddTaskScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(), // Replace with your target screen
                  ),
                );
              },
              child: Container(
                width: w * 0.05,
                height: w * 0.05,
                child: Center(
                  child: Image.asset(
                    "assets/circleadd.png",
                    fit: BoxFit.contain,
                    width: w * 0.093,
                    height: w * 0.093,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),


      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Search Bar Row
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: Row(
                children: [
                  Container(
                    width: w * 0.65,
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
                        _showAddTaskBottomSheet(context);
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
                              "Add Label",
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
            ),
            const SizedBox(height: 8),
            Container(
              width: w,
              height:h *0.85,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffFFFFFF), // Surrounding container color
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: data.length,
                shrinkWrap:
                    true, // Allow the ListView to take only the space it needs
                physics: AlwaysScrollableScrollPhysics(), // Disable scrolling in ListView
                itemBuilder: (context, index) {
                  var tododata = data[index];
                  Color labelColor = hexToColor(tododata.labelColor ?? "");

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
                            // Circular indicator
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
                            // Delete icon
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
                                ),
                              ),
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
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures the bottom sheet is scrollable
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Handles keyboard overlap
              left: 16.0,
              right: 16.0,
              top: 16.0),
          child: SingleChildScrollView( // Wrap the content in a scrollable view
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Label',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),



                    ),

                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Label Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: ['High', 'Medium', 'Low'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {},
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Dismiss the bottom sheet
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Save task logic here
                      },

                      child: Text('Add Label'),


                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
