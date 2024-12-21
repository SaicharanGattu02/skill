import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:skill/Providers/ThemeProvider.dart';
import 'package:skill/Services/UserApi.dart';
import '../Model/TaskKanBanModel.dart';
import '../Providers/KanbanProvider.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/constants.dart';

class Taskkanbanboard extends StatefulWidget {
  final String id;
  const Taskkanbanboard({super.key, required this.id});

  @override
  State<Taskkanbanboard> createState() => _TaskkanbanboardState();
}

class _TaskkanbanboardState extends State<Taskkanbanboard> {
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;
  bool showNoDataFoundMessage = false;
  List<Kanban> kanbandata = [];
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
      _loading = true;
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
      return data;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData == lightTheme
          ? Color(0xffEFE2FF).withOpacity(0.1)
          : themeProvider.containerColor,
      body:
      _loading?_buildShimmerList(context):Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Expanded(child: TaskRow(status: 'To Do', id: widget.id)),
          Expanded(child: TaskRow(status: 'In Progress', id: widget.id)),
          Expanded(child: TaskRow(status: 'Done', id: widget.id)),
        ],
      ),
    );
  }

  Widget _buildShimmerList(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      itemCount: 10, // Adjust the number of shimmer items as needed
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  shimmerRectangle(20, context), // Shimmer for calendar icon
                  const SizedBox(width: 8),
                  shimmerText(100, 15, context), // Shimmer for due date
                  const Spacer(),
                  shimmerRectangle(20, context), // Shimmer for edit icon
                ],
              ),
              const SizedBox(height: 20),
              shimmerText(150, 20, context), // Shimmer for milestone title
              const SizedBox(height: 4),
              shimmerText(
                  300, 14, context), // Shimmer for milestone description
              const SizedBox(height: 10),
              shimmerText(350, 14, context),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  shimmerText(60, 14, context), // Shimmer for "Progress" label
                  shimmerText(40, 14, context), // Shimmer for percentage
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class TaskRow extends StatefulWidget {
  final String status;
  final String id;

  TaskRow({
    required this.status,
    required this.id,
  });

  @override
  State<TaskRow> createState() => _TaskRowState();
}

class _TaskRowState extends State<TaskRow> {
  Future<void> UpdateTaskStatusApi(String ID, String newStatus) async {
    String? Status;
    if (newStatus == "To Do") {
      Status = "to_do";
    } else if (newStatus == "In Progress") {
      Status = "in_progress";
    } else {
      Status = "completed";
    }
    try {
      var res = await Userapi.TaskKanBanUpdate(ID, Status);
      if (res != null) {
        if (res.settings?.success == 1) {
          _fetchAllKanbanData();
        }
      }
    } catch (e) {
      print("Error updating task status: $e");
    }
  }

  Future<void> _fetchAllKanbanData() async {
    try {
      var results = await Future.wait([
        Userapi.GetTaskKanBan(widget.id, "to_do"),
        Userapi.GetTaskKanBan(widget.id, "in_progress"),
        Userapi.GetTaskKanBan(widget.id, "completed"),
      ]);

      // Get the provider instance
      final provider = Provider.of<KanbanProvider>(context, listen: false);

      // Process and set data in the provider
      provider.setTodoData(_processResponse(results[0]));
      provider.setInProgressData(_processResponse(results[1]));
      provider.setCompletedData(_processResponse(results[2]));
    } catch (error) {
      // Handle error appropriately
      print("Error fetching data: $error");
    } finally {
      // Set loading to false only after all APIs have been processed
      setState(() {
      });
    }
  }


  List<Kanban> _processResponse(res) {
    if (res != null && res.settings?.success == 1) {
      var data = res.data ?? [];
      return data; // Return sorted data
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<KanbanProvider>(context);
    List<Kanban> tasks;
    switch (widget.status) {
      case 'To Do':
        tasks = provider.todoData;
        break;
      case 'In Progress':
        tasks = provider.inProgressData;
        break;
      case 'Done':
        tasks = provider.completedData;
        break;
      default:
        tasks = [];
    }

    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Image.asset(
                  widget.status == "To Do"
                      ? "assets/box.png"
                      : widget.status == "In Progress"
                          ? "assets/inprogress.png"
                          : "assets/done.png",
                  fit: BoxFit.contain,
                  width: w * 0.045,
                  height: w * 0.05,
                  color:themeProvider.themeData==lightTheme?Color(0xff6C848F):themeProvider.textColor ,
                ),
                SizedBox(width: w * 0.02),
                Text(widget.status,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                SizedBox(width: w * 0.01),
                Text("(${tasks.length.toString()})",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color:themeProvider.themeData==lightTheme?Color(0xff6C848F):themeProvider.textColor
                   )),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DottedBorder(
                color: Color(0xffCFB9FF),
                strokeWidth: 1,
                dashPattern: [5, 3],
                borderType: BorderType.RRect,
                radius: Radius.circular(7),
                child: DragTarget<Kanban>(
                  onAccept: (draggedTask) {
                    if (draggedTask.status != widget.status) {
                      Provider.of<KanbanProvider>(context, listen: false)
                          .updateTaskStatus(draggedTask, widget.status);
                      UpdateTaskStatusApi(draggedTask.id!, widget.status);
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: double.infinity,
                      height: w * 0.4,
                      decoration: BoxDecoration(
                        color: themeProvider.containerColor,
                      ),
                      child: tasks.isEmpty
                          ? Center(
                              child: Lottie.asset(
                                'assets/animations/nodata1.json',
                                height: 100,
                                width: 100,
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Scrollbar(
                                thumbVisibility: true,
                                radius: Radius.circular(10),
                                child: Row(
                                  children: tasks.map((task) {
                                    String formattedStartDate =
                                        DateTimeFormatter.format(
                                            task.startDate ?? "",
                                            includeDate: true,
                                            includeTime: false);
                                    String formattedEndDate =
                                        DateTimeFormatter.format(
                                            task.endDate ?? "",
                                            includeDate: true,
                                            includeTime: false);

                                    List<String> collaboratorImages = task
                                            .collaborators
                                            ?.map((collaborator) =>
                                                collaborator.image ?? "")
                                            .toList() ??
                                        [];
                                    return Container(
                                      width: w * 0.83,
                                      margin: EdgeInsets.all(8.0),
                                      child: LongPressDraggable<Kanban>(
                                        data: task,
                                        feedback: Card(
                                          child: Container(
                                            width: w * 0.8,
                                            height: w * 0.32,
                                            decoration: BoxDecoration(
                                              color: themeProvider.containerColor,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        task.title ?? "",
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: themeProvider
                                                              .textColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Image.asset(
                                                      "assets/More-vertical.png",
                                                      width: w * 0.045,
                                                      height: w * 0.06,
                                                      color: Color(0xff6C848F),
                                                    ),
                                                  ],
                                                ),
                                                if (collaboratorImages.length !=
                                                    0) ...[
                                                  SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      FlutterImageStack(
                                                        imageList:
                                                            collaboratorImages,
                                                        totalCount:
                                                            collaboratorImages
                                                                .length,
                                                        showTotalCount: true,
                                                        extraCountTextStyle:
                                                            TextStyle(
                                                          color:
                                                              Color(0xff8856F4),
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                        itemRadius: 25,
                                                        itemBorderWidth: 3,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        "Collaborators",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff6C848F),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                        childWhenDragging: Container(),
                                        child: Card(
                                          elevation: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                                bottom: 5),
                                            decoration: BoxDecoration(
                                              color: themeProvider.containerColor,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        task.title ?? "",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: themeProvider
                                                              .textColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Image.asset(
                                                      "assets/More-vertical.png",
                                                      width: w * 0.045,
                                                      height: w * 0.06,
                                                      color: Color(0xff6C848F),
                                                    ),
                                                  ],
                                                ),
                                                if (collaboratorImages.length !=
                                                    0) ...[
                                                  SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      FlutterImageStack(
                                                        imageList:
                                                            collaboratorImages,
                                                        totalCount:
                                                            collaboratorImages
                                                                .length,
                                                        showTotalCount: true,
                                                        extraCountTextStyle:
                                                            TextStyle(
                                                          color:
                                                              Color(0xff8856F4),
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                        itemRadius: 25,
                                                        itemBorderWidth: 3,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        "Collaborators",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: themeProvider
                                                                      .themeData ==
                                                                  lightTheme
                                                              ? Color(0xff6C848F)
                                                              : themeProvider
                                                                  .textColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/calendar.png",
                                                      width: w * 0.045,
                                                      height: w * 0.06,
                                                      color: themeProvider
                                                                  .themeData ==
                                                              lightTheme
                                                          ? Color(0xff6C848F)
                                                          : themeProvider
                                                              .textColor,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      formattedStartDate,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: themeProvider
                                                                    .themeData ==
                                                                lightTheme
                                                            ? Color(0xff6C848F)
                                                            : themeProvider
                                                                .textColor,
                                                      ),
                                                    ),
                                                    SizedBox(width: 15),
                                                    Image.asset(
                                                      "assets/calendar.png",
                                                      width: w * 0.045,
                                                      height: w * 0.06,
                                                      color: themeProvider
                                                                  .themeData ==
                                                              lightTheme
                                                          ? Color(0xff6C848F)
                                                          : themeProvider
                                                              .textColor,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      formattedEndDate,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: themeProvider
                                                                    .themeData ==
                                                                lightTheme
                                                            ? Color(0xff6C848F)
                                                            : themeProvider
                                                                .textColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
