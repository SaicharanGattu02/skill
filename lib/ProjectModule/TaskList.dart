import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:intl/intl.dart';
import 'package:skill/ProjectModule/TaskForm.dart';
import '../Model/TasklistModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';

class TaskList extends StatefulWidget {
  final String id1;
  const TaskList({super.key, required this.id1});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();
  List<Data> data = []; // Original list of Data objects
  List<Data> filteredData = []; // Filtered list for search

  @override
  void initState() {
    super.initState(); // Add this to properly initialize the state
    GetProjectTasks();
    // Initialize filteredData with all data
    filteredData = List.from(data);
    _searchController.addListener(filterData); // Add listener for search
  }

  void filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredData = data.where((item) {
        return (item.title?.toLowerCase().contains(query) ?? false) ||
            (item.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(filterData); // Remove listener
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  Future<void> GetProjectTasks() async {
    var Res = await Userapi.GetTask(widget.id1);
    setState(() {
      if (Res?.data != null) {
        if (Res?.settings?.success == 1) {
          data = Res?.data ?? [];
          filteredData = Res?.data ?? [];
          _loading = false;
        } else {
          _loading = false;
          CustomSnackBar.show(context, Res?.settings?.message ?? "");
        }
      } else {
        print("Task Failure  ${Res?.settings?.message}");
      }
    });
  }

  Future<void> DelateTask(String id) async {
    var res = await Userapi.ProjectDelateTask(id);
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          _loading = true;
          data=[];
          filteredData=[];
          GetProjectTasks();
          CustomSnackBar.show(context, "${res.settings?.message}");
        } else {
          CustomSnackBar.show(context, "${res.settings?.message}");
        }
      } else {
        CustomSnackBar.show(context, "${res?.settings?.message}");
      }
    });
  }

  final spinkit = Spinkits();

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: w * 0.63,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
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
                        Spacer(),
                        SizedBox(
                          height: w * 0.09,
                          child: InkWell(
                            onTap: () async {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskForm(
                                      title: 'Add Task',
                                      projectId: widget.id1,
                                      taskid: '',
                                    ),
                                  ));
                              if (res == true) {
                                setState(() {
                                  GetProjectTasks();
                                });
                              }
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
                                    "Add Task",
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
                    SizedBox(height: 8),
                    _loading?_buildShimmerList():
                    filteredData.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.24,
                                ),
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
                            physics:
                                NeverScrollableScrollPhysics(), // Ensures the list doesn't scroll inside the scroll view
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final task = filteredData[index];
                              // Extracting image URLs from collaborators
                              List<String> collaboratorImages = [];
                              if (task.collaborators != null) {
                                collaboratorImages = task.collaborators!.map((collaborator) => collaborator.image ?? "").toList();
                              }
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 1),
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
                                              fontFamily: "Inter",
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            DelateTask(task.id ?? "");
                                          },
                                          child: Image.asset(
                                            "assets/delate.png",
                                            fit: BoxFit.contain,
                                            width: w * 0.04,
                                            height: w * 0.05,
                                            color: Color(0xffDE350B),
                                          ),
                                        ),
                                        SizedBox(
                                          width: w * 0.04,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            var res = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskForm(
                                                            title: 'Edit Task',
                                                            projectId:
                                                            widget.id1,
                                                            taskid: task.id ??
                                                                "")));
                                            if (res == true) {
                                              setState(() {
                                                _loading=true;
                                                GetProjectTasks();
                                              });
                                            }
                                          },
                                          child: Container(
                                            child: Image.asset(
                                              "assets/edit.png",
                                              fit: BoxFit.contain,
                                              width: w * 0.06,
                                              height: w * 0.05,
                                              color: Color(0xff8856F4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      task.title ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff1D1C1D),
                                        height: 21 / 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
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
                                        // Adding the images before the collaborators text
                                        if (task.assignedToImage != null)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 4.0),
                                            child: ClipOval(
                                              child: Image.network(
                                                // task.assignedToImage ?? "", // Network image
                                                task.assignedToImage
                                                        .toString() ??
                                                    "",
                                                width: 24,
                                                height: 24,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(width: 4),
                                        Text(
                                          task.assignedTo.toString() ?? "",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    FlutterImageStack(
                                      imageList: collaboratorImages,
                                      totalCount: collaboratorImages.length,
                                      showTotalCount: true,
                                      extraCountTextStyle: TextStyle(
                                        color: Color(0xff8856F4),
                                      ),
                                      backgroundColor: Colors.white,
                                      itemRadius: 35,
                                      itemBorderWidth: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Start Date: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff64748B),
                                          ),
                                        ),
                                        Text(
                                          task.startDate ?? "",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff64748B),
                                          ),
                                        ),
                                        const Spacer(),
                                        const Text(
                                          "End Date: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff64748B),
                                          ),
                                        ),
                                        Text(
                                          task.endDate ?? "25/09/2024",
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
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10, // Adjust the number of shimmer items as needed
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  shimmerText(20, 20), // Shimmer for status label
                  const Spacer(),
                  shimmerRectangle(24), // Shimmer for delete icon
                  const SizedBox(width: 8),
                  shimmerRectangle(24), // Shimmer for edit icon
                ],
              ),
              const SizedBox(height: 6),
              shimmerText(150, 16), // Shimmer for task title
              const SizedBox(height: 8),
              shimmerText(200, 12), // Shimmer for task description
              const SizedBox(height: 8),
              Row(
                children: [
                  shimmerCircle(24), // Shimmer for assigned user image
                  const SizedBox(width: 4),
                  shimmerText(100, 12), // Shimmer for collaborators text
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  shimmerText(50, 12), // Shimmer for "Start Date:"
                  const SizedBox(width: 4),
                  shimmerText(90, 12), // Shimmer for start date value
                  const Spacer(),
                  shimmerText(50, 12), // Shimmer for "End Date:"
                  const SizedBox(width: 4),
                  shimmerText(90, 12), // Shimmer for end date value
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}
