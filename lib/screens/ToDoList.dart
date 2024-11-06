import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:skill/Model/ProjectLabelColorModel.dart';
import 'package:skill/screens/AddToDo.dart';
import 'package:skill/utils/CustomSnackBar.dart';
import '../Model/ProjectLabelModel.dart';
import '../Model/ToDoListModel.dart';
import '../Model/UserDetailsModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/ShakeWidget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../utils/app_colors.dart';

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  TextEditingController _labelnameController = TextEditingController();
  TextEditingController _labelcolorController = TextEditingController();
  FocusNode _focusNodeLabelName = FocusNode();
  late ScrollController _scrollController;
  String _validtaskName = "";
  String _validdescription = "";
  String _validDate = "";
  String _validatePriority = "";
  String _validateLabel = "";
  String _validateLabelName = "";
  String _validateLabelColor = "";
  String priorityid = "";
  String labelid = "";
  String labelColorid = "";

  bool isChecked = false;

  bool _isLoading = true;
  final spinkit = Spinkits();
  String formattedDate = "";

  @override
  void initState() {
    super.initState();

    _labelnameController.addListener(() {
      setState(() {
        _validateLabelName = "";
      });
    });

    formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    GetToDoList(formattedDate);

    filteredData = data;

    _searchController.addListener(_filterTasks);

    _scrollController = ScrollController();
    _generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }


  final List<TodoPriorities> priorities = [
    TodoPriorities(priorityValue: 'Priority 1', priorityKey: '1'),
    TodoPriorities(priorityValue: 'Priority 2', priorityKey: '2'),
    TodoPriorities(priorityValue: 'Priority 3', priorityKey: '3'),
    TodoPriorities(priorityValue: 'Priority 4', priorityKey: '4'),
  ];

  List<Label> labels = [];
  Future<void> GetLabel() async {
    var res = await Userapi.GetProjectsLabelApi();
    setState(() {
      _isLoading = false;
      if (res != null && res.label != null) {
        labels = res.label ?? [];
      }
    });
  }

  List<LabelColor> labelcolor = [];
  Future<void> GetLabelColor() async {
    var res = await Userapi.GetProjectsLabelColorApi();
    setState(() {
      _isLoading = false;
      if (res != null && res.data != null) {
        labelcolor = res.data ?? [];
      }
    });
  }

  List<TODOList> data = [];
  List<TODOList> filteredData = [];
  TextEditingController _searchController = TextEditingController();

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
    );
    if (pickedDate != null) {
      controller.text =
          DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
    }
  }

  Future<void> GetToDoList(String date) async {
    var res = await Userapi.gettodolistApi(date);
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          _isLoading = false;
          data = res.data ?? [];
          filteredData = data.reversed.toList(); // Initialize the filtered list to the full list
        } else {
          _isLoading = false;
          data = [];
          filteredData = [];
        }
      }
    });
  }

  Future<void> deleteToDoList(String id) async {
    var res = await Userapi.deleteTask(id);
    setState(() {
      _isLoading = false;
      if (res != null) {
        if (res.settings?.success == 1) {
          GetToDoList(formattedDate);
          CustomSnackBar.show(context, "Deleted successfully!");
        } else {
          CustomSnackBar.show(context, "${res.settings?.message}");
        }
      }
    });
  }

  Future<void> PostToDoAddLabel() async {
    var res = await Userapi.PostProjectTodoAddLabel(
        _labelnameController.text, labelColorid);
    setState(() {
      if (res != null) {
        _isLoading = false;
        if (res.settings?.success == 1) {
          GetToDoList(formattedDate);
          Navigator.pop(context, true);
          CustomSnackBar.show(context, "${res.settings?.message}");
        } else {
          CustomSnackBar.show(context, "${res.settings?.message}");
        }
      } else {
        _isLoading = false;
      }
    });
  }

  Future<void> reorderTodos(Map<String, int> todosOrder) async {
    var res = await Userapi.ReorderTodos(todosOrder);
    setState(() {
      if (res != null) {

      } else {
      }
    });
  }

  void _filterTasks() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredData = data.where((task) {
        return (task.labelName?.toLowerCase().contains(query) ?? false) ||
            (task.description?.toLowerCase().contains(query) ?? false) ||
            (task.taskName?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose(); // Dispose of the controller
    super.dispose();
  }

  Color hexToColor(String? hexColor) {
    // Return a default grey color if hexColor is null or empty
    if (hexColor == null || hexColor.isEmpty) {
      return Color(0xFF808080); // Hex for grey with full opacity
    }

    // Ensure the color starts with '#' for correct format
    if (!hexColor.startsWith('#')) {
      hexColor = '#$hexColor'; // Add '#' if it's missing
    }

    // Ensure the color is valid (either 7 characters for #RRGGBB or 9 for #RRGGBBAA)
    if (hexColor.length == 7 || hexColor.length == 9) {
      final buffer = StringBuffer();
      buffer.write('FF'); // Add alpha if it's missing (default to full opacity)
      buffer.write(hexColor.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } else {
      // Return default grey if the format is invalid
      return Color(0xFF808080); // Hex for grey with full opacity
    }
  }

  final List<String> daysOfWeek = ['Mo', 'Tu', 'Wed', 'Th', 'Fr', 'Sa', 'Su'];

  List<DateTime> dates = [];
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Perform any logic before popping the screen
        Navigator.pop(context, true); // This will pop the screen and pass 'true' back.
        return Future.value(false); // Returning false prevents the default back navigation behavior
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF3ECFB),
        appBar: CustomAppBar(
          title: 'Todo',
          actions: [
            Container()
            // SizedBox(
            //   height: w * 0.09,
            //   child: InkWell(
            //     onTap: () {
            //       GetLabelColor();
            //       _showAddLabel(context);
            //     },
            //     child: Padding(
            //       padding: EdgeInsets.only(right: 10),
            //       child: Container(
            //         padding: EdgeInsets.symmetric(horizontal: 10),
            //         decoration: BoxDecoration(
            //             border: Border.all(color: Color(0xffffffff), width: 1),
            //             // color: Color(0xff8856F4),
            //             borderRadius: BorderRadius.circular(6)),
            //         child: Row(
            //           children: [
            //             Image.asset(
            //               "assets/circleadd.png",
            //               fit: BoxFit.contain,
            //               width: w * 0.045,
            //               height: w * 0.05,
            //               color: Color(0xffffffff),
            //             ),
            //             SizedBox(width: w * 0.01),
            //             Text(
            //               "Add Label",
            //               style: TextStyle(
            //                 color: Color(0xffffffff),
            //                 fontWeight: FontWeight.w500,
            //                 fontSize: 12,
            //                 fontFamily: "Inter",
            //                 height: 16.94 / 12,
            //                 letterSpacing: 0.59,
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: w * 0.9,
                      height: h * 0.043,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/search.png",
                              width: 20,
                              height: 17,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 10),
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
                                  fontFamily: "Nunito",
                                ),
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(width: 10),
                    // SizedBox(
                    //   height: w * 0.09,
                    //   child: InkWell(
                    //     onTap: () async {
                    //       var res = await Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => AddToDo()));
                    //       if (res == true) {
                    //         setState(() {
                    //           _isLoading = true;
                    //           GetToDoList(formattedDate);
                    //         });
                    //       }
                    //     },
                    //     child: Container(
                    //       padding: EdgeInsets.symmetric(horizontal: 10),
                    //       decoration: BoxDecoration(
                    //           color: AppColors.primaryColor,
                    //           borderRadius: BorderRadius.circular(6)),
                    //       child: Row(
                    //         children: [
                    //           Image.asset(
                    //             "assets/circleadd.png",
                    //             fit: BoxFit.contain,
                    //             width: w * 0.045,
                    //             height: w * 0.05,
                    //             color: Color(0xffffffff),
                    //           ),
                    //           SizedBox(width: w * 0.01),
                    //           Text(
                    //             "Add To Do",
                    //             style: TextStyle(
                    //               color: Color(0xffffffff),
                    //               fontWeight: FontWeight.w500,
                    //               fontSize: 12,
                    //               fontFamily: "Inter",
                    //               height: 16.94 / 12,
                    //               letterSpacing: 0.59,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                  width: w,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Row(
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
                                    color: AppColors.primaryColor,
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                                  data = [];
                                  filteredData = [];
                                  _isLoading = true;
                                  GetToDoList(formattedDate);
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
                      _isLoading
                          ? _buildShimmerList()
                          : (filteredData.length > 0)
                              ? SizedBox(
                        height: h * 0.65,
                        child: ReorderableListView(
                          onReorder: (oldIndex, newIndex) async {
                            // Adjust the newIndex if it's greater than the oldIndex to ensure correct reordering
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            // Move the item in the list to its new position
                            final tododata = filteredData.removeAt(oldIndex);
                            filteredData.insert(newIndex, tododata);
                            // Create the todos_order object based on the new order
                            Map<String, int> todosOrder = {};
                            for (int i = 0; i < filteredData.length; i++) {
                              todosOrder[filteredData[i].id ?? ""] = i + 1;
                            }
                            // Now, send the update to the API
                            await reorderTodos(todosOrder);

                            setState(() {
                              // The list is now reordered and the state is updated
                            });
                          },
                          children: List.generate(filteredData.length, (index) {
                            var tododata = filteredData[index];
                            return Column(
                              key: ValueKey(tododata.id ?? index), // Ensure each item has a unique key for efficient reordering
                              children: [
                                ReorderableDragStartListener(
                                  index: index,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/More-vertical.png",
                                          fit: BoxFit.contain,
                                          width: 20,
                                          height: 20,
                                        ),
                                        // The InkWell here should not interfere with the reorder gesture.
                                        // It’s better to move the delete action outside of the draggable area.
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              deleteToDoList(tododata.id ?? "");
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8, right: 8), // Increase padding for larger tap area
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: tododata.labelColor != null
                                                      ? hexToColor(tododata.labelColor ?? "")
                                                      : Colors.grey, // Border color
                                                  width: 3,
                                                ),
                                              ),
                                              child: isChecked
                                                  ? Icon(
                                                Icons.check,
                                                size: 10,
                                                color: Colors.white, // Color of the check icon
                                              )
                                                  : null, // Use null instead of SizedBox.shrink() when unchecked
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tododata.taskName ?? "",
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Color(0xff141516),
                                                  height: 16.94 / 13,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              if (tododata.description != "")
                                                Text(
                                                  tododata.description ?? "",
                                                  style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    color: Color(0xff4a4a4a),
                                                    height: 12.89 / 11,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Image.asset("assets/label.png", width: 18, height: 18,color: hexToColor(tododata.labelColor ?? ""),),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    tododata.labelName ?? "",
                                                    style: const TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      height: 13.31 / 11,
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Image.asset("assets/calendar.png", width: 18, height: 18),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    tododata.dateTime ?? "",
                                                    style: const TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      color: Color(0xff2FB035),
                                                      height: 13.31 / 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                const Divider(
                                  thickness: 1,
                                  color: Color(0xffE1E1E1),
                                  height: 1,
                                ),
                              ],
                            );
                          }),
                        ),
                      )
                          : Center(
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
                                      SizedBox(
                                        height: h * 0.3,
                                      )
                                    ],
                                  ),
                                )
                    ],
                  )),
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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerRectangle(20), // Shimmer for the icon
              const SizedBox(width: 8),
              shimmerCircle(20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerText(150, 13), // Shimmer for task name
                    const SizedBox(height: 5),
                    shimmerText(200, 11), // Shimmer for description
                    const SizedBox(height: 5),
                    shimmerText(120, 11), // Shimmer for date/time
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
