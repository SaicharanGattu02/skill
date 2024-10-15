import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:intl/intl.dart';
import 'package:skill/Services/UserApi.dart';
import '../Model/TaskKanBanModel.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';

class TaskKanBan extends StatefulWidget {
  final String id;
  const TaskKanBan({super.key, required this.id});

  @override
  State<TaskKanBan> createState() => _TaskKanBanState();
}

class _TaskKanBanState extends State<TaskKanBan> {
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;
  bool showNoDataFoundMessage = false;
  List<Data> data = [];
  List<Data> filteredRooms = [];

  final List<String> _images = [
    'https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
    'https://images.unsplash.com/photo-1612594305265-86300a9a5b5b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1612626256634-991e6e977fc1?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1712&q=80',
    'https://images.unsplash.com/photo-1593642702749-b7d2a804fbcf?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    GetKanBan();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredRooms = data.where((room) {
        String otherUser = room.title?.toLowerCase() ?? '';
        String message = room.id?.toLowerCase() ?? '';
        return otherUser.contains(query) || message.contains(query);
      }).toList();
    });
  }

  Future<void> GetKanBan() async {

    var res = await Userapi.GetTaskKanBan(widget.id);

    setState(() {
      _loading = false;
      if (res != null && res.settings?.success == 1) {
        data = res.data ?? [];
        print("data>>${data}");
        data.sort((a, b) => (b.title ?? '').compareTo(a.title ?? ''));
        filteredRooms = data; // Initialize with all data
        showNoDataFoundMessage = data.isEmpty;
      } else {
        showNoDataFoundMessage = true;
      }
    });
  }
final spinkit=Spinkits();
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffEFE2FF).withOpacity(0.1),
      body: _loading
          ? Center(
        child:spinkit.getFadingCircleSpinner(color: Color(0xff9E7BCA))
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
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
                  ),
                ],
              ),
              SizedBox(height: 8),
              filteredRooms.isEmpty
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

                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredRooms.length,
                itemBuilder: (context, index) {
                  final kanBan = filteredRooms[index];
                  String isoDate = kanBan.startDate ?? "";
                  String isoDate1 = kanBan.endDate ?? "";
                  String formattedDate = DateTimeFormatter.format(isoDate, includeDate: true, includeTime: false);
                  String formattedDate1 = DateTimeFormatter.format(isoDate1, includeDate: true, includeTime: false);

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: DottedBorder(
                      color: Color(0xffCFB9FF),
                      strokeWidth: 1,
                      dashPattern: [5, 3],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(7),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xffEFE2FF),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/box.png",
                                  fit: BoxFit.contain,
                                  width: w * 0.045,
                                  height: w * 0.05,
                                  color: Color(0xff000000),
                                ),
                                SizedBox(width: w * 0.02),
                                Text(
                                  kanBan.status ?? "",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff16192C),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        kanBan.title ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                      Spacer(),
                                      Image.asset(
                                        "assets/More-vertical.png",
                                        fit: BoxFit.contain,
                                        width: w * 0.045,
                                        height: w * 0.06,
                                        color: Color(0xff6C848F),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/calendar.png",
                                        fit: BoxFit.contain,
                                        width: w * 0.045,
                                        height: w * 0.06,
                                        color: Color(0xff6C848F),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "$formattedDate",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff6C848F),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Image.asset(
                                        "assets/calendar.png",
                                        fit: BoxFit.contain,
                                        width: w * 0.045,
                                        height: w * 0.06,
                                        color: Color(0xff6C848F),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "$formattedDate1",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff6C848F),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  FlutterImageStack(
                                    imageList: _images,
                                    totalCount: _images.length,
                                    showTotalCount: true,
                                    // totalCountTextStyle: TextStyle(
                                    //   color: Color(0xff8856F4),
                                    // ),
                                    extraCountTextStyle: TextStyle(
                                      color: Color(0xff8856F4),
                                    ),
                                    backgroundColor: Colors.white,
                                    itemRadius: 35,
                                    itemBorderWidth: 3,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

