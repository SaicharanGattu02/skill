import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skill/Services/UserApi.dart';
import '../Model/TaskKanBanModel.dart';
import '../Providers/KanbanProvider.dart';
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
  List<Kanban> kanbandata=[];
  List<Kanban> filteredRooms = [];


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchAllKanbanData();
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
      filteredRooms = kanbandata.where((room) {
        String otherUser = room.title?.toLowerCase() ?? '';
        String message = room.id?.toLowerCase() ?? '';
        return otherUser.contains(query) || message.contains(query);
      }).toList();
    });
  }

  Future<void> _fetchAllKanbanData() async {
    setState(() {
      _loading = true; // Show loading spinner
    });

    try {
      var results = await Future.wait([
        Userapi.GetTaskKanBan(widget.id, "to_do"),
        Userapi.GetTaskKanBan(widget.id, "in_progress"),
        Userapi.GetTaskKanBan(widget.id, "completed"),
      ]);

      // Get the provider instance
      final provider = Provider.of<KanbanProvider>(context, listen: false);

      // Update the provider with the results
      provider.setTodoData(_processResponse(results[0]));
      provider.setInProgressData(_processResponse(results[1]));
      provider.setCompletedData(_processResponse(results[2]));

      showNoDataFoundMessage = provider.todoData.isEmpty &&
          provider.inProgressData.isEmpty &&
          provider.completedData.isEmpty;
    } catch (error) {
      // Handle error appropriately
      print("Error fetching data: $error");
    } finally {
      setState(() {
        _loading = false; // Hide loading spinner
      });
    }
  }


  List<Kanban> _processResponse(res) {
    if (res != null && res.settings?.success == 1) {
      var data = res.data ?? [];
      data.sort((a, b) => (b.title ?? '').compareTo(a.title ?? ''));
      return data; // Return sorted data
    }
    return [];
  }


  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffEFE2FF).withOpacity(0.1),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xff8856F4),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      width: w,
                      child: Center(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/search.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(
                                width: 10,
                              ),
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
                    ),
                    SizedBox(height: 8),
                    showNoDataFoundMessage
                        ? Center(child: Text("No data found"))
                        :

                    SizedBox(
                            height: h *
                                0.24, // Set a fixed height for the overall container
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
                                    Expanded(
                                      child: Text(
                                        "To Do",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff16192C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.008,
                                ),
                                Expanded(
                                  child: DottedBorder(
                                      color: Color(0xffCFB9FF),
                                      strokeWidth: 1,
                                      dashPattern: [5, 3],
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(7),
                                      child: Container(
                                          padding: EdgeInsets.all(16),
                                          width: w *
                                              0.87, // Specify a fixed width for each item
                                          decoration: BoxDecoration(
                                            color: Color(0xffEFE2FF),
                                          ),
                                          child:
                                        ListView.builder(
                                          physics: AlwaysScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: filteredRooms.length,
                                          itemBuilder: (context, index) {
                                            final kanBan = filteredRooms[index];
                                            String isoDate = kanBan.startDate ?? "";
                                            String isoDate1 = kanBan.endDate ?? "";
                                            String formattedDate = DateTimeFormatter.format(isoDate, includeDate: true, includeTime: false);
                                            String formattedDate1 = DateTimeFormatter.format(isoDate1, includeDate: true, includeTime: false);
                                  
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10), // Horizontal padding
                                              child:
                                              Column(
                                                children: [
                                                  SizedBox(height: 8),

                                                  if(kanBan.status=="To Do")...[

                                                    Container(
                                                    width: w * 0.75,
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
                                                            Expanded(
                                                              child: Text(
                                                                kanBan.title ?? "",
                                                                style: TextStyle(
                                                                  fontFamily: 'Inter',
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Color(0xff000000),
                                                                ),
                                                              ),
                                                            ),
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
                                                              formattedDate,
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
                                                              formattedDate1,
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
                                                        // FlutterImageStack(
                                                        //   imageList: _images,
                                                        //   totalCount: _images.length,
                                                        //   showTotalCount: true,
                                                        //   extraCountTextStyle: TextStyle(
                                                        //     color: Color(0xff8856F4),
                                                        //   ),
                                                        //   backgroundColor: Colors.white,
                                                        //   itemRadius: 35,
                                                        //   itemBorderWidth: 3,
                                                        // ),
                                                      ],
                                                    ),
                                                  ),]

                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                  
                                  
                                  
                                      )),
                                )


                              ],
                            ),
                          ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: h *
                          0.24, // Set a fixed height for the overall container
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
                              Expanded(
                                child: Text(
                                  "In Progress",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff16192C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: h * 0.008,
                          ),
                          Expanded(
                            child: DottedBorder(
                                color: Color(0xffCFB9FF),
                                strokeWidth: 1,
                                dashPattern: [5, 3],
                                borderType: BorderType.RRect,
                                radius: Radius.circular(7),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  width: w *
                                      0.87, // Specify a fixed width for each item
                                  decoration: BoxDecoration(
                                    color: Color(0xffEFE2FF),
                                  ),
                                  child:
                                  ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: filteredRooms.length,
                                    itemBuilder: (context, index) {
                                      final kanBan = filteredRooms[index];
                                      String isoDate = kanBan.startDate ?? "";
                                      String isoDate1 = kanBan.endDate ?? "";
                                      String formattedDate = DateTimeFormatter.format(isoDate, includeDate: true, includeTime: false);
                                      String formattedDate1 = DateTimeFormatter.format(isoDate1, includeDate: true, includeTime: false);

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10), // Horizontal padding
                                        child:
                                        Column(
                                          children: [
                                            SizedBox(height: 8),

                                            if(kanBan.status=="In Progress")...[

                                              Container(
                                                width: w * 0.75,
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
                                                        Expanded(
                                                          child: Text(
                                                            kanBan.title ?? "",
                                                            style: TextStyle(
                                                              fontFamily: 'Inter',
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: Color(0xff000000),
                                                            ),
                                                          ),
                                                        ),
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
                                                          formattedDate,
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
                                                          formattedDate1,
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
                                                    // FlutterImageStack(
                                                    //   imageList: _images,
                                                    //   totalCount: _images.length,
                                                    //   showTotalCount: true,
                                                    //   extraCountTextStyle: TextStyle(
                                                    //     color: Color(0xff8856F4),
                                                    //   ),
                                                    //   backgroundColor: Colors.white,
                                                    //   itemRadius: 35,
                                                    //   itemBorderWidth: 3,
                                                    // ),
                                                  ],
                                                ),
                                              ),]

                                          ],
                                        ),
                                      );
                                    },
                                  ),



                                )),
                          )


                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: h *
                          0.24, // Set a fixed height for the overall container
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
                              Expanded(
                                child: Text(
                                  "Completed",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff16192C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: h * 0.008,
                          ),
                          Expanded(
                            child: DottedBorder(
                                color: Color(0xffCFB9FF),
                                strokeWidth: 1,
                                dashPattern: [5, 3],
                                borderType: BorderType.RRect,
                                radius: Radius.circular(7),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  width: w *
                                      0.87, // Specify a fixed width for each item
                                  decoration: BoxDecoration(
                                    color: Color(0xffEFE2FF),
                                  ),
                                  child:
                                  ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: filteredRooms.length,
                                    itemBuilder: (context, index) {
                                      final kanBan = filteredRooms[index];
                                      String isoDate = kanBan.startDate ?? "";
                                      String isoDate1 = kanBan.endDate ?? "";
                                      String formattedDate = DateTimeFormatter.format(isoDate, includeDate: true, includeTime: false);
                                      String formattedDate1 = DateTimeFormatter.format(isoDate1, includeDate: true, includeTime: false);

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10), // Horizontal padding
                                        child:
                                        Column(
                                          children: [
                                            SizedBox(height: 8),

                                            if(kanBan.status=="Completed")...[

                                              Container(
                                                width: w * 0.75,
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
                                                        Expanded(
                                                          child: Text(
                                                            kanBan.title ?? "",
                                                            style: TextStyle(
                                                              fontFamily: 'Inter',
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: Color(0xff000000),
                                                            ),
                                                          ),
                                                        ),
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
                                                          formattedDate,
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
                                                          formattedDate1,
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
                                                    // FlutterImageStack(
                                                    //   imageList: _images,
                                                    //   totalCount: _images.length,
                                                    //   showTotalCount: true,
                                                    //   extraCountTextStyle: TextStyle(
                                                    //     color: Color(0xff8856F4),
                                                    //   ),
                                                    //   backgroundColor: Colors.white,
                                                    //   itemRadius: 35,
                                                    //   itemBorderWidth: 3,
                                                    // ),
                                                  ],
                                                ),
                                              ),]

                                          ],
                                        ),
                                      );
                                    },
                                  ),



                                )),
                          )

                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
    );
  }
}
