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
      return data; // Return sorted data
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF3ECFB),
      body: Column(
        children: [
          SizedBox(height: 8),
          Expanded(child: TaskRow(status: 'To Do')),
          Expanded(child: TaskRow(status: 'In Progress')),
          Expanded(child: TaskRow(status: 'Done')),
        ],
      ),
    );
  }
}

class TaskRow extends StatelessWidget {
  final String status;

  TaskRow({required this.status});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final provider = Provider.of<KanbanProvider>(context);
    List<Kanban> tasks;

    switch (status) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                status == "To Do"
                    ? "assets/box.png"
                    : status == "In Progress"
                        ? "assets/inprogress.png"
                        : "assets/done.png",
                fit: BoxFit.contain,
                width: w * 0.045,
                height: w * 0.05,
              ),
              SizedBox(width: w * 0.02),
              Text(status,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(width: w * 0.01),
              Text(
                  status == "To Do"
                      ? "(${tasks.length.toString()})"
                      : status == "In Progress"
                          ? "(${tasks.length.toString()})"
                          : "(${tasks.length.toString()})",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff6C848F))),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DottedBorder(
                color: Color(0xffCFB9FF),
                strokeWidth: 1,
                dashPattern: [5, 3],
                borderType: BorderType.RRect,
                radius: Radius.circular(7),
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffEFE2FF),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: (tasks.isEmpty)
                        ? Center(
                            child: Text(
                              "No data",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(
                                    0xff6C848F), // Customize color as needed
                              ),
                            ),
                          )
                        : Row(
                            children: tasks.map((task) {
                              String isoDate = task.startDate ?? "";
                              String isoDate1 = task.endDate ?? "";
                              String formattedDate = DateTimeFormatter.format(
                                  isoDate,
                                  includeDate: true,
                                  includeTime: false);
                              String formattedDate1 = DateTimeFormatter.format(
                                  isoDate1,
                                  includeDate: true,
                                  includeTime: false);

                              // Extracting image URLs from collaborators
                              List<String> collaboratorImages = [];
                              if (task.collaborators != null) {
                                collaboratorImages = task.collaborators!
                                    .map((collaborator) =>
                                        collaborator.image ?? "")
                                    .toList();
                              }
                              return Container(
                                width: w * 0.83,
                                margin: EdgeInsets.all(8.0),
                                child: LongPressDraggable<Kanban>(
                                  data: task,
                                  feedback: Card(
                                    child: Container(
                                      width: 200,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(7),
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
                                          FlutterImageStack(
                                            imageList: collaboratorImages,
                                            totalCount:
                                                collaboratorImages.length,
                                            showTotalCount: true,
                                            extraCountTextStyle: TextStyle(
                                              color: Color(0xff8856F4),
                                            ),
                                            backgroundColor: Colors.white,
                                            itemRadius: 30,
                                            itemBorderWidth: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Container(),
                                  child: DragTarget<Kanban>(
                                    onAccept: (draggedTask) {
                                      if (draggedTask.status != status) {
                                        Provider.of<KanbanProvider>(context,
                                                listen: false)
                                            .updateTaskStatus(
                                                draggedTask, status);
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return Card(
                                        elevation: 2,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
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
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff000000),
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
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff6C848F),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              FlutterImageStack(
                                                imageList: collaboratorImages,
                                                totalCount:
                                                    collaboratorImages.length,
                                                showTotalCount: true,
                                                extraCountTextStyle: TextStyle(
                                                  color: Color(0xff8856F4),
                                                ),
                                                backgroundColor: Colors.white,
                                                itemRadius: 30,
                                                itemBorderWidth: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
