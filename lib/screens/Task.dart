import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:intl/intl.dart';
import '../Model/DashboardTaksModel.dart';
import '../Services/UserApi.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}
bool _loading= false;
class _TaskState extends State<Task> {
  final List<String> daysOfWeek = ['Mo', 'Tu', 'Wed', 'Th', 'Fr', 'Sa', 'Su'];



  List<DateTime> dates = [];
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();
  late ScrollController _scrollController;

  final List<String> imageList = [
    "assets/prashanth.png",
    "assets/prashanth.png",
    "assets/prashanth.png",
    "assets/prashanth.png",
    "assets/prashanth.png",
  ];
  String formattedDate="";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _generateDates();
    formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    GetTasksList(formattedDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }
  List<Data> data=[];
  List<Data> filteredData=[];
  Future<void> GetTasksList(String date) async {
    var res = await Userapi.gettaskaApi(date);
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          data = res.data ?? [];
          filteredData = data; // Initialize the filtered list to the full list
        } else {
          data = [];
          filteredData = [];
        }
      }
    });
  }
  @override  void dispose() {
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
  Future<bool> willPop() async{
    Navigator.pop(context,true);
    return false;
  }
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
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
        body:
        _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
        Container(
          width: w,
          margin: const EdgeInsets.only(top: 16,left: 16,right: 16),
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
                          data = [];
                          filteredData = [];
                          // _isLoading=true;
                          GetTasksList(formattedDate);
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
              if (data.length == 0) Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Image.asset(
                      'assets/nodata1.png', // Path to your no data image
                      width: 150,
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
                    SizedBox(height: h*0.2,)
                  ],
                ),
              ) else Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final task = data[index];
                    // Extracting image URLs from collaborators
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
                        border:
                            Border.all(color: const Color(0xffD0CBDB), width: 0.5),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 1, bottom: 1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color(0xffFFAB00).withOpacity(0.10)),
                                child: Text(
                                  task.status??"",
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1D1C1D),
                              overflow: TextOverflow.ellipsis,
                              height: 21 / 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if(task.description!="")
                          Text(
                            task.description ?? "",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
