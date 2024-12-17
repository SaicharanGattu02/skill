import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skill/ProjectModule/TaskForm.dart';
import 'package:skill/Providers/TaskListProvider.dart';
import '../Model/MileStoneModel.dart';
import '../Model/ProjectOverviewModel.dart';
import '../Model/ProjectPrioritiesModel.dart';
import '../Model/ProjectStatusModel.dart';
import '../Model/TasklistModel.dart';
import '../Providers/MileStoneProvider.dart';
import '../Providers/ThemeProvider.dart';
import '../Services/UserApi.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/ShakeWidget.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'AddTask.dart';

class TaskList extends StatefulWidget {
  final String id1;
  const TaskList({super.key, required this.id1});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final spinkits = Spinkits();

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mileStoneController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  String _validateDeadline = "";
  String _validateMileStone = "";
  String _validateAssignedTo = "";
  String _validateStatus = "";
  String _validatePriority = "";

  List<Members> members = [];
  Data? assign;
  @override
  void initState() {
    super.initState();
    _mileStoneController.addListener(() {
      setState(() {
        _validateMileStone = "";
      });
    });
    _assignedToController.addListener(() {
      setState(() {
        _validateAssignedTo = "";
      });
    });
    _statusController.addListener(() {
      setState(() {
        _validateStatus = "";
      });
    });
    _priorityController.addListener(() {
      setState(() {
        _validatePriority = "";
      });
    });
    _deadlineController.addListener(() {
      setState(() {
        _validateDeadline = "";
      });
    });
    GetProjectsOverviewData();
    GetStatuses();
    GetPriorities();
    GetProjectTasks();
  }

  Future<void> GetProjectTasks() async {
    final tasklistProvider = Provider.of<TasklistProvider>(context, listen: false);
    tasklistProvider.fetchTasksList(widget.id1, milestoneid, statusid,
        assignedid, priorityid,_deadlineController.text);
    final milestoneProvider = Provider.of<MileStoneProvider>(context,listen: false);
    milestoneProvider.fetchMileStonesList(widget.id1);
  }

  String milestoneid = "";
  String assignedid = "";
  String statusid = "";
  String priorityid = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> GetProjectsOverviewData() async {
    var res = await Userapi.GetProjectsOverviewApi(widget.id1);
    setState(() {
      if (res != null && res.data != null) {
        if (res.settings?.success == 1) {
          assign = res.data;
          members = assign?.members ?? [];
          print("members: $members");
        } else {}
      }
    });
  }

  List<Statuses> statuses = [];
  Future<void> GetStatuses() async {
    var res = await Userapi.GetProjectsStatusesApi();
    setState(() {
      if (res != null && res.data != null) {
        statuses = res.data ?? [];
      }
    });
  }

  List<Priorities> priorities = [];
  Future<void> GetPriorities() async {
    var res = await Userapi.GetProjectsPrioritiesApi();
    setState(() {
      if (res != null && res.data != null) {
        priorities = res.data ?? [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final tasklistProvider = Provider.of<TasklistProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: w * 0.55,
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
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v){
                              tasklistProvider
                                  .filterTasksList(_searchController.text);
                            },
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
                     Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTask(
                                title: 'Add Task',
                                projectId: widget.id1,
                                taskid: '',
                              ),
                            ));

                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
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
                  Spacer(),
                  InkWell(
                    onTap: () {
                      _bottomSheet(context);
                    },
                    child: Image.asset(
                      "assets/filter.png",
                      width: 25,
                      height: 25,
                      color: AppColors.primaryColor,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              tasklistProvider.isLoading
                  ? _buildShimmerList()
                  : tasklistProvider.filteredTasks.isEmpty
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
                          itemCount:  tasklistProvider.filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = tasklistProvider.filteredTasks[index];
                            List<String> collaboratorImages = [];
                            if (task.collaborators != null) {
                              collaboratorImages = task.collaborators!
                                  .map((collaborator) =>
                                      collaborator.image ?? "")
                                  .toList();
                            }
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: themeProvider.themeData == lightTheme
                                    ? Color(0xffffffff)
                                    : AppColors.darkmodeContainerColor,
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
                                        onTap: () async {
                                          var res = await tasklistProvider.deleteTask(task.id ?? "");
                                          if(res==1){
                                            CustomSnackBar.show(context, "Task Deleted Successfully!");
                                          }else{
                                            CustomSnackBar.show(context, "Task Deleted Failed!");
                                          }
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
                                        onTap: ()  {
                                         Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AddTask(
                                                      title: 'Edit Task',
                                                      projectId: widget.id1,
                                                      taskid: task.id ?? "")));
                                        },
                                        child: Container(
                                          child: Image.asset(
                                            "assets/edit.png",
                                            fit: BoxFit.contain,
                                            width: w * 0.06,
                                            height: w * 0.05,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    task.title ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          themeProvider.themeData == lightTheme
                                              ? Color(0xff1D1C1D)
                                              : themeProvider.textColor,
                                      height: 21 / 16,
                                    ),
                                  ),
                                  if (task.description != "") ...[
                                    const SizedBox(height: 8),
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
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // Adding the images before the collaborators text
                                      Text(
                                        "Assigned to :",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: themeProvider.themeData ==
                                                    lightTheme
                                                ? Color(0xff64748B)
                                                : themeProvider.textColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      if (task.assignedToImage != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: ClipOval(
                                            child: Image.network(
                                              // task.assignedToImage ?? "", // Network image
                                              task.assignedToImage.toString() ??
                                                  "",
                                              width: 20,
                                              height: 20,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 4),
                                      Text(
                                        task.assignedTo.toString() ?? "",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: themeProvider.themeData ==
                                                  lightTheme
                                              ? Color(0xff64748B)
                                              : themeProvider.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (collaboratorImages.length != 0) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        FlutterImageStack(
                                          imageList: collaboratorImages,
                                          totalCount: collaboratorImages.length,
                                          showTotalCount: true,
                                          extraCountTextStyle: TextStyle(
                                            color: Color(0xff8856F4),
                                            fontSize: 12,
                                          ),
                                          backgroundColor: Colors.white,
                                          itemRadius: 30,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Collaborators",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Start Date: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: themeProvider.themeData ==
                                                  lightTheme
                                              ? Color(0xff64748B)
                                              : themeProvider.textColor,
                                        ),
                                      ),
                                      Text(
                                        task.startDate ?? "",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff2EB67D),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "End Date: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: themeProvider.themeData ==
                                                  lightTheme
                                              ? Color(0xff64748B)
                                              : themeProvider.textColor,
                                        ),
                                      ),
                                      Text(
                                        task.endDate ?? "25/09/2024",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffDE350B),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      itemCount: 10, // Adjust the number of shimmer items as needed
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
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
                  shimmerText(20, 20, context), // Shimmer for status label
                  const Spacer(),
                  shimmerRectangle(24, context), // Shimmer for delete icon
                  const SizedBox(width: 8),
                  shimmerRectangle(24, context), // Shimmer for edit icon
                ],
              ),
              const SizedBox(height: 6),
              shimmerText(150, 16, context), // Shimmer for task title
              const SizedBox(height: 8),
              shimmerText(200, 12, context), // Shimmer for task description
              const SizedBox(height: 8),
              Row(
                children: [
                  shimmerCircle(24, context), // Shimmer for assigned user image
                  const SizedBox(width: 4),
                  shimmerText(
                      100, 12, context), // Shimmer for collaborators text
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  shimmerText(50, 12, context), // Shimmer for "Start Date:"
                  const SizedBox(width: 4),
                  shimmerText(90, 12, context), // Shimmer for start date value
                  const Spacer(),
                  shimmerText(50, 12, context), // Shimmer for "End Date:"
                  const SizedBox(width: 4),
                  shimmerText(90, 12, context), // Shimmer for end date value
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return Consumer<ThemeProvider>(builder: (context,themeProvider,child){
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child: TextField(
              controller: controller,
              readOnly: true,
              onTap: () {
                _selectDate(context, controller);
              },
              decoration: InputDecoration(
                hintText: "Select Date",
                suffixIcon: Container(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: Image.asset(
                      "assets/calendar.png",
                      color: themeProvider.textColor,
                      width: 16,
                      height: 16,
                      fit: BoxFit.contain,
                    )),
                hintStyle: TextStyle(
                  fontSize: 14,
                  letterSpacing: 0,
                  height: 1.2,
                  color: themeProvider.textColor,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor:themeProvider.fillColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(width: 1, color: Color(0xffD0CBDB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.0),
                  borderSide: BorderSide(width: 1, color: Color(0xffD0CBDB)),
                ),
              ),
            ),
          ),
        ],
      );
    },
    );
  }

  static Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }


   Widget _label(BuildContext context,{required String text}) {
    return Consumer<ThemeProvider>(builder: (context,themeProvider,child){
      return Text(
        text,
        style: TextStyle(
          color: themeProvider.textColor,
          fontSize: 14,
        ),
      );
    },

    );
  }

  void _bottomSheet(
    BuildContext context,
  ) {
    double h = MediaQuery.of(context).size.height * 0.7;
    double w = MediaQuery.of(context).size.width;
    final milestoneProvider = Provider.of<MileStoneProvider>(context,listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                        height: h,
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 20),
                        decoration: BoxDecoration(
                          color: themeProvider.containerColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: w * 0.1,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  'Filters',
                                  style: TextStyle(
                                    color:themeProvider.textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    height: 18 / 16,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pop(); // Close the BottomSheet when tapped
                                  },
                                  child: Container(
                                    width: w * 0.05,
                                    height: w * 0.05,
                                    decoration: BoxDecoration(
                                      color: Color(0xffE5E5E5),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        "assets/crossblue.png",
                                        fit: BoxFit.contain,
                                        width: w * 0.023,
                                        height: w * 0.023,
                                        color: Color(0xff8856F4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label(context,text: 'Milestone'),
                                    SizedBox(height: 4),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.050,
                                      child: TypeAheadField<Milestones>(
                                        controller: _mileStoneController,
                                        builder:
                                            (context, controller, focusNode) {
                                          return TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                            onTap: () {
                                              setState(() {
                                                _validateMileStone = "";
                                              });
                                            },
                                            onChanged: (v) {
                                              setState(() {
                                                _validateMileStone = "";
                                              });
                                            },
                                            style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 0,
                                              height: 1.2,
                                              color: themeProvider.textColor,
                                              fontWeight: FontWeight.w400,
                                            ),

                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 10),
                                              hintText: "Select Milestone",
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  letterSpacing: 0,
                                                  height: 1.2,
                                                  color: themeProvider.textColor,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              filled: true,
                                              fillColor:themeProvider.fillColor,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Color(0xffD0CBDB)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Color(0xffD0CBDB)),
                                              ),
                                            ),

                                            textAlignVertical: TextAlignVertical
                                                .center, // Vertically center the
                                          );
                                        },
                                        suggestionsCallback: (pattern) {
                                          return milestoneProvider.milestones
                                              .where((item) => item.title!
                                                  .toLowerCase()
                                                  .contains(
                                                      pattern.toLowerCase()))
                                              .toList();
                                        },
                                        decorationBuilder: (context, child) => Material(
                                          color: themeProvider.containerColor,
                                          type: MaterialType.card,
                                          elevation: 2,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          child: child,

                                        ),
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion.title!,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          );
                                        },
                                        onSelected: (suggestion) {
                                          setState(() {
                                            _mileStoneController.text =
                                                suggestion.title!;
                                            // You can use suggestion.statusKey to send to the server
                                            milestoneid = suggestion.id!;
                                            // Call your API with the selected key here if needed
                                            _validateMileStone = "";
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    _label(context,text: 'Priority'),
                                    SizedBox(height: 4),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.050,
                                      child: TypeAheadField<Priorities>(
                                        controller: _priorityController,
                                        builder:
                                            (context, controller, focusNode) {
                                          return TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                            onTap: () {
                                              setState(() {
                                                _validatePriority = "";
                                              });
                                            },
                                            onChanged: (v) {
                                              setState(() {
                                                _validatePriority = "";
                                              });
                                            },
                                            style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 0,
                                              height: 1.2,
                                              color: themeProvider.textColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Select Priority",
                                              hintStyle: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 0,
                                                height: 1.2,
                                                color: themeProvider.textColor,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              filled: true,
                                              fillColor:themeProvider.fillColor,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Color(0xffD0CBDB)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Color(0xffD0CBDB)),
                                              ),
                                            ),
                                          );
                                        },
                                        suggestionsCallback: (pattern) {
                                          return priorities
                                              .where((item) => item
                                                  .priorityValue!
                                                  .toLowerCase()
                                                  .contains(
                                                      pattern.toLowerCase()))
                                              .toList();
                                        },
                                        decorationBuilder: (context, child) => Material(
                                          color: themeProvider.containerColor,
                                          type: MaterialType.card,
                                          elevation: 2,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          child: child,

                                        ),
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion.priorityValue!,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          );
                                        },
                                        onSelected: (suggestion) {
                                          setState(() {
                                            _priorityController.text =
                                                suggestion.priorityValue!;
                                            // You can use suggestion.statusKey to send to the server
                                            priorityid =
                                                suggestion.priorityKey!;
                                            // Call your API with the selected key here if needed
                                            _validatePriority = "";
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    _label(context,text: 'Assign to'),
                                    SizedBox(height: 4),
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.050,
                                      child: TypeAheadField<Members>(
                                        controller: _assignedToController,
                                        builder:
                                            (context, controller, focusNode) {
                                          return TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                            onTap: () {
                                              setState(() {
                                                _validateAssignedTo = "";
                                              });
                                            },
                                            onChanged: (v) {
                                              setState(() {
                                                _validateAssignedTo = "";
                                              });
                                            },
                                            style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 0,
                                              height: 1.2,
                                              color: themeProvider.textColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Select Assigned to Person",
                                              hintStyle: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 0,
                                                height: 1.2,
                                                color: themeProvider.textColor,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              filled: true,
                                              fillColor:themeProvider.fillColor,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Color(0xffD0CBDB)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Color(0xffD0CBDB)),
                                              ),
                                            ),
                                          );
                                        },

                                        // suggestionsCallback: (pattern) {
                                        //   return members
                                        //       .where((item) => item.fullName!
                                        //       .toLowerCase()
                                        //       .contains(pattern.toLowerCase()))
                                        //       .toList();
                                        // },

                                        suggestionsCallback: (pattern) {
                                          var matches = members
                                              .where((item) => item.fullName!
                                                  .toLowerCase()
                                                  .contains(
                                                      pattern.toLowerCase()))
                                              .toList();

                                          if (matches.isEmpty) {
                                            _assignedToController.clear();
                                          }

                                          return matches;
                                        },
                                        decorationBuilder: (context, child) => Material(
                                          color: themeProvider.containerColor,
                                          type: MaterialType.card,
                                          elevation: 2,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          child: child,

                                        ),

                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion.fullName!,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          );
                                        },

                                        onSelected: (suggestion) {
                                          setState(() {
                                            _assignedToController.text =
                                                suggestion.fullName!;
                                            // You can use suggestion.statusKey to send to the server
                                            assignedid = suggestion.id!;
                                            // Call your API with the selected key here if needed
                                            _validateAssignedTo = "";
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    _label(context,text: 'Status'),
                                    SizedBox(height: 4),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.050,
                                      child: TypeAheadField<Statuses>(
                                        controller: _statusController,
                                        builder:
                                            (context, controller, focusNode) {
                                          return TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                            onTap: () {
                                              setState(() {
                                                _validateStatus = "";
                                              });
                                            },
                                            onChanged: (v) {
                                              setState(() {
                                                _validateStatus = "";
                                              });
                                            },
                                            style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 0,
                                              height: 1.2,
                                              color:themeProvider.textColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Select Status",
                                              hintStyle: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 0,
                                                height: 1.2,
                                                color: themeProvider.textColor,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              filled: true,
                                              fillColor: themeProvider.fillColor,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Color(0xffD0CBDB)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Color(0xffD0CBDB)),
                                              ),
                                            ),
                                          );
                                        },
                                        suggestionsCallback: (pattern) {
                                          return statuses
                                              .where((item) => item.statusValue!
                                                  .toLowerCase()
                                                  .contains(
                                                      pattern.toLowerCase()))
                                              .toList();
                                        },
                                        decorationBuilder: (context, child) => Material(
                                          color: themeProvider.containerColor,
                                          type: MaterialType.card,
                                          elevation: 2,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          child: child,

                                        ),
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion.statusValue!,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          );
                                        },
                                        onSelected: (suggestion) {
                                          setState(() {
                                            _statusController.text =
                                                suggestion.statusValue!;
                                            // You can use suggestion.statusKey to send to the server
                                            statusid = suggestion.statusKey!;
                                            // Call your API with the selected key here if needed
                                            _validateStatus = "";
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    _label(context,text: 'Deadline'),
                                    SizedBox(height: 4),
                                    _buildDateField(
                                      _deadlineController,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(18),
                              decoration: BoxDecoration(color: themeProvider.containerColor),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkResponse(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        statusid = "";
                                        priorityid = "";
                                        milestoneid = "";
                                        assignedid = "";
                                        _deadlineController.text = "";
                                        _statusController.text = "";
                                        _priorityController.text = "";
                                        _mileStoneController.text = "";
                                        _assignedToController.text = "";
                                        GetProjectTasks();
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: w * 0.35,
                                      decoration: BoxDecoration(
                                        color: themeProvider.containerColor,
                                        border: Border.all(
                                          color: Color(0xff8856F4),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Close',
                                          style: TextStyle(
                                            color: Color(0xff8856F4),
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkResponse(
                                    onTap: () {
                                      setState(() {
                                        GetProjectTasks();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: w * 0.35,
                                      decoration: BoxDecoration(
                                        color: Color(0xff8856F4),
                                        border: Border.all(
                                          color: Color(0xff8856F4),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Center(
                                        child:
                                        // _loading
                                        //     ? spinkits.getFadingCircleSpinner()
                                        //     :
                                        Text(
                                                'Save',
                                                style: TextStyle(
                                                  color: Color(0xffffffff),
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )));
              },
            );
          });
        });
  }
}
