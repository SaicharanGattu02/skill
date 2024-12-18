import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skill/Providers/MeetingProvider.dart';
import 'package:skill/Services/UserApi.dart';
import 'package:skill/screens/AddMeetings.dart';
import 'package:skill/utils/CustomAppBar.dart';
import '../Providers/ConnectivityProviders.dart';
import '../Providers/ThemeProvider.dart';
import '../Services/otherservices.dart';
import '../utils/Mywidgets.dart';
import '../utils/app_colors.dart';

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
    Provider.of<ConnectivityProviders>(context, listen: false)
        .initConnectivity();
    _scrollController = ScrollController();
    _generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
    formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    Provider.of<MeetingProvider>(context, listen: false)
        .getMeeting(formattedDate);
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    final index = dates.indexWhere((date) =>
        date.day == selectedDate.day &&
        date.month == selectedDate.month &&
        date.year == selectedDate.year);

    if (index != -1) {
      final double offset = index * 55.0;
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final meetingProvider = Provider.of<MeetingProvider>(context);
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
            connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, true);
              return Future.value(
                  false); // Returning false prevents the default back navigation behavior
            },
            child: Scaffold(
              backgroundColor: themeProvider.scaffoldBackgroundColor,
              appBar: CustomAppBar(
                title: 'Meetings',
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: () async {
                        var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMeetings(),
                          ),
                        );
                        if (res == true) {
                          setState(() {
                            _loading = true;
                          });
                          meetingProvider.getMeeting(formattedDate);
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
                                color: themeProvider.primaryColor,
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
                        Spacer(),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(dates.length, (index) {
                          final isSelected =
                              dates[index].day == selectedDate.day &&
                                  dates[index].month == selectedDate.month &&
                                  dates[index].year == selectedDate.year;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = dates[index];
                                formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(selectedDate);
                                print("selectedDate: $formattedDate");
                                _loading = true;
                                meetingProvider.getMeeting(formattedDate);
                              });
                              _scrollToSelectedDate();
                            },
                            child: ClipRect(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                      child: (meetingProvider.loading)
                          ? _buildShimmerList()
                          : meetingProvider.meetings.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
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
                                  itemCount: meetingProvider.meetings.length,
                                  itemBuilder: (context, index) {
                                    final task =
                                        meetingProvider.meetings[index];

                                    bool isLastItem = index ==
                                        meetingProvider.meetings.length - 1;

                                    return Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                "assets/meeting.png",
                                                width: 32,
                                                height: 32,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    task.title ?? "",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff141516),
                                                      height: 16 / 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    task.description ?? "",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff141516),
                                                      height: 16 / 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "Join the video conference call link:",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "Inter",
                                                      height: 16 / 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff4a4a4a),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: w * 0.6,
                                                    child: Text(
                                                      "${task.meetingLink ?? ""}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Inter",
                                                        height: 16 / 14,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            Color(0xffDE350B),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xffDE350B),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                          "assets/calendar.png",
                                                          width: 20,
                                                          height: 20),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        task.startDate ?? "",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff64748B),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Add divider only if it's not the last item
                                        if (!isLastItem)
                                          Divider(
                                            color: Color(0xff94A3B8)
                                                .withOpacity(0.3),
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
            ))
        : NoInternetWidget();
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: themeProvider.containerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          shimmerText(
                              50, 15, context), // Shimmer for "Today" label
                          const Spacer(),
                          shimmerRectangle(
                              24, context), // Shimmer for delete icon
                          const SizedBox(width: 8),
                          shimmerRectangle(
                              24, context), // Shimmer for edit icon
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          shimmerCircle(10, context), // Shimmer for status dot
                          const SizedBox(width: 8),
                          shimmerText(
                              150, 12, context), // Shimmer for start date
                          const SizedBox(width: 8),
                          shimmerCircle(
                              12, context), // Shimmer for meeting icon
                        ],
                      ),
                      const SizedBox(height: 8),
                      shimmerText(150, 12, context), // Shimmer for task title
                      const SizedBox(height: 8),
                      shimmerText(200, 12, context), // Shimmer for meeting link
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: themeProvider
                              .containerColor, // Shimmer background color
                        ),
                        child: shimmerText(100, 12,
                            context), // Shimmer for meeting link button
                      ),
                    ],
                  ),
                ),

                // Add divider after each item except the last one
                if (index != 9) // If it's not the last item
                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
