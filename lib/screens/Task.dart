import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skill/Providers/TaskProvider.dart';
import 'package:skill/Providers/ThemeProvider.dart';
import 'package:skill/utils/Mywidgets.dart';
import '../Model/DashboardTaksModel.dart';
import '../Services/UserApi.dart';
import '../utils/constants.dart';

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

  String formattedDate = "";
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _generateDates();
    formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    // GetTasksList(formattedDate);
    Provider.of<TaskProvider>(context, listen: false)
        .GetTasksList(formattedDate);
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

  Future<bool> willPop() async {
    Navigator.pop(context, true);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final taskProvider = Provider.of<TaskProvider>(context);

    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        backgroundColor: themeProvider.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: themeProvider.themeData == lightTheme
              ? Color(0xff8856F4)
              : themeProvider.containerColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xffffffff),
            ),
          ),
          title: Text(
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
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeProvider.containerColor,
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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: themeProvider.textColor,
                          fontFamily: "Inter",
                          height: 19.36 / 14,
                        ),
                      ),
                    ],
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
                    final taskProvider = Provider.of<TaskProvider>(context);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = dates[index];
                          formattedDate =
                              DateFormat('yyyy-MM-dd').format(selectedDate);
                          print("selectedDate: $formattedDate");
                          // data = [];
                          // filteredData = [];
                          // _isLoading=true;
                          taskProvider.isLoading;
                          taskProvider.data;
                          taskProvider.fillterData;
                          taskProvider.GetTasksList(formattedDate);
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
                                      : themeProvider.textColor,
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
                child: (_loading)
                    ? _buildShimmerList()
                    : taskProvider.data.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
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
                            itemCount: taskProvider.data.length,
                            itemBuilder: (context, index) {
                              final task = taskProvider.data[index];
                              List<String> collaboratorImages = [];
                              if (task.collaborators != null) {
                                collaboratorImages = task.collaborators!
                                    .map((collaborator) =>
                                        collaborator.image ?? "")
                                    .toList();
                              }
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffD0CBDB),
                                      width: 0.5),
                                  color: themeProvider.containerColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 1,
                                              bottom: 1),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Color(0xffFFAB00)
                                                  .withOpacity(0.10)),
                                          child: Text(
                                            task.status ?? "",
                                            style: TextStyle(
                                                color: const Color(0xffFFAB00),
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
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      task.title ?? "",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: themeProvider.textColor,
                                        overflow: TextOverflow.ellipsis,
                                        height: 21 / 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (task.description != "")
                                      Text(
                                        task.description ?? "",
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 16 / 12,
                                          color: themeProvider.themeData ==
                                                  lightTheme
                                              ? Color(0xff787486)
                                              : themeProvider.textColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        FlutterImageStack(
                                          imageList: collaboratorImages,
                                          totalCount: collaboratorImages.length,
                                          showTotalCount: true,
                                          extraCountTextStyle: TextStyle(
                                            color: Color(0xff8856F4),
                                          ),
                                          backgroundColor: Colors.white,
                                          itemRadius: 25,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Collaborators",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: themeProvider
                                                          .appThemeMode ==
                                                      lightTheme
                                                  ? Color(0xff64748B)
                                                  : themeProvider.textColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          // task.dateTime ?? "",
                                          "25/09/2024",
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
                                          // task.dateTime ?? "",
                                          "25/09/2024",
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: themeProvider.containerColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xffD0CBDB), width: 0.5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                shimmerText(60, 10, context),
                SizedBox(
                  height: 8,
                ),
                shimmerText(280, 10, context),
                SizedBox(
                  height: 8,
                ),
                shimmerText(280, 10, context),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    shimmerCircle(24, context),
                    shimmerCircle(24, context),
                    SizedBox(
                      width: 8,
                    ),
                    shimmerText(70, 10, context),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    shimmerText(40, 10, context),
                    SizedBox(
                      width: 8,
                    ),
                    shimmerText(55, 10, context),
                    Spacer(),
                    shimmerText(40, 10, context),
                    SizedBox(
                      width: 8,
                    ),
                    shimmerText(55, 10, context),
                  ],
                )
              ],
            ),
          );
        });
  }
}
