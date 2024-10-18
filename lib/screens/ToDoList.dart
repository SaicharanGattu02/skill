import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import 'package:skill/Model/ProjectLabelColorModel.dart';
import 'package:skill/utils/CustomSnackBar.dart';

import '../Model/ProjectLabelModel.dart';
import '../Model/ToDoListModel.dart';
import '../Model/UserDetailsModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/ShakeWidget.dart';

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _DateController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();
  TextEditingController _labelController = TextEditingController();
  TextEditingController _labelnameController = TextEditingController();
  TextEditingController _labelcolorController = TextEditingController();

  FocusNode _focusNodeTaskName = FocusNode();
  FocusNode _focusNodeLabelName = FocusNode();
  FocusNode _focusNodedescription = FocusNode();
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

  bool isChecked =false;

  bool _isLoading = true;
  final spinkit = Spinkits();
  String formattedDate = "";
  @override
  void initState() {
    super.initState();
    _taskNameController.addListener(() {
      setState(() {
        _validtaskName = "";
      });
    });
    _descriptionController.addListener(() {
      setState(() {
        _validdescription = "";
      });
    });
    _DateController.addListener(() {
      setState(() {
        _validDate = "";
      });
    });
    _priorityController.addListener(() {
      setState(() {
        _validatePriority = "";
      });
    });

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

  final List<Priorities> priorities = [
    Priorities(priorityValue: 'Priority 1', priorityKey: '1'),
    Priorities(priorityValue: 'Priority 2', priorityKey: '2'),
    Priorities(priorityValue: 'Priority 3', priorityKey: '3'),
    Priorities(priorityValue: 'Priority 4', priorityKey: '4'),
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
      _isLoading = false;
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

  Future<void> deleteToDoList(String id) async {
    var res = await Userapi.deleteTask(id);
    setState(() {
      _isLoading = false;
      if (res != null) {
        if (res.settings?.success == 1) {
          GetToDoList(formattedDate);
          CustomSnackBar.show(context, "${res.settings?.message}");
        } else {
          CustomSnackBar.show(context, "${res.settings?.message}");
        }
      }
    });
  }

  Future<void> PostToDo() async {
    var res = await Userapi.PostProjectTodo(_taskNameController.text,
        _descriptionController.text, _DateController.text, priorityid, labelid);
    setState(() {
      _isLoading = false;
      if (res != null) {
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

  void _filterTasks() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredData = data.where((task) {
        return (task.labelName?.toLowerCase().contains(query) ?? false) ||
            (task.description?.toLowerCase().contains(query) ?? false) ||
            (task.dateTime?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose(); // Dispose of the controller
    super.dispose();
  }

  // Function to convert hex color string to Color
  Color hexToColor(String hexColor) {
    final buffer = StringBuffer();
    if (hexColor.length == 6 || hexColor.length == 7) {
      buffer.write('FF'); // Add alpha if missing
      buffer.write(hexColor.replaceFirst('#', ''));
    } else {
      throw FormatException("Invalid hex color format");
    }
    return Color(int.parse(buffer.toString(), radix: 16));
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

    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: CustomAppBar(
        title: 'Todo',
        actions: [],
        onPlusTap: () {
          GetLabel();
          _bottomSheet(context);
        },
      ),
      body:
          // _isLoading
          //     ? Center(
          //         child: spinkit.getFadingCircleSpinner(color: Color(0xff9E7BCA)))
          //     :
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
                    children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: w * 0.58,
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
                  SizedBox(width: 10),
                  SizedBox(
                    height: w * 0.09,
                    child: InkWell(
                      onTap: () {
                        GetLabelColor();
                        _showAddLabel(context);
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
                            SizedBox(width: w * 0.01),
                            Text(
                              "Add Label",
                              style: TextStyle(
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: "Inter",
                                height: 16.94 / 12,
                                letterSpacing: 0.59,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
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
                                formattedDate =
                                    DateFormat('yyyy-MM-dd').format(selectedDate);
                                print("selectedDate: $formattedDate");
                                data = [];
                                filteredData = [];
                                // _isLoading=true;
                                GetToDoList(formattedDate);
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
                    SizedBox(
                      height: 15,
                    ),
                    (filteredData.length > 0)
                        ? SizedBox(
                            height: h*0.7,
                            child: ListView.builder(
                              itemCount: filteredData.length,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var tododata = filteredData[index];
                                // Color labelColor = hexToColor(tododata.labelColor ?? "");
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "assets/More-vertical.png",
                                            fit: BoxFit.contain,
                                            width: 20,
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                deleteToDoList(tododata.id ?? "");
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:8,right: 8), // Increase padding for larger tap area
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tododata.taskName ?? "",
                                                  style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                    color: Color(0xff141516),
                                                    height: 16.94 / 13,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                SizedBox(
                                                  width: w * 0.5,
                                                  child: Text(
                                                    tododata.description ?? "",
                                                    style: const TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 11,
                                                      color: Color(0xffB1B5C3),
                                                      height: 12.89 / 11,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  tododata.dateTime ?? "",
                                                  style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 11,
                                                    color: Color(0xffB1B5C3),
                                                    height: 13.31 / 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      color: Color(0xffF1F1F1),
                                    ),
                                  ],
                                );
                              },
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
                                SizedBox(height: h*0.3,)
                              ],
                            ),
                          )
                  ],
                )),
                    ],
                  ),
          ),
    );
  }

  void _showAddLabel(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.45;
    double w = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: h,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
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
                          "Add Label",
                          style: TextStyle(
                            color: Color(0xff1C1D22),
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
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label(text: 'Label Name'),
                            SizedBox(height: 6),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.050,
                              child: TextFormField(
                                controller: _labelnameController,
                                focusNode: _focusNodeLabelName,
                                keyboardType: TextInputType.text,
                                cursorColor: Color(0xff8856F4),
                                decoration: InputDecoration(
                                  hintText: "Enter Label Name",
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0,
                                    height: 19.36 / 14,
                                    color: Color(0xffAFAFAF),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffFCFAFF),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xffd0cbdb)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xffd0cbdb)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xffd0cbdb)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xffd0cbdb)),
                                  ),
                                ),
                              ),
                            ),
                            if (_validateLabelName.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    left: 8, bottom: 10, top: 5),
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    'Please enter label name',
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              SizedBox(height: 15),
                            ],
                            _label(text: 'Color'),
                            SizedBox(height: 4),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.050,
                              child: TypeAheadField<LabelColor>(
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    focusNode: focusNode,
                                    controller: _labelcolorController,
                                    onTap: () {
                                      setState(() {
                                        _validateLabelColor = "";
                                      });
                                    },
                                    onChanged: (v) {
                                      setState(() {
                                        _validateLabelColor = "";
                                      });
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      height: 1.2,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Select label",
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 0,
                                        height: 1.2,
                                        color: Color(0xffAFAFAF),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffFCFAFF),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xffD0CBDB)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xffD0CBDB)),
                                      ),
                                    ),
                                  );
                                },
                                suggestionsCallback: (pattern) {
                                  return labelcolor
                                      .where((item) => item.colorName!
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()))
                                      .toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Color(
                                              int.parse(suggestion.colorCode!
                                                  .replaceFirst('#', '0xFF')),
                                              // This replaces '#' with '0xFF' to make it a valid color value
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          (suggestion.colorName!),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onSelected: (suggestion) {
                                  setState(() {
                                    _labelcolorController.text =
                                        suggestion.colorName!;
                                    labelColorid = suggestion.colorCode!;
                                    print("labelColorid:${labelColorid}");
                                    _validateLabelColor = "";
                                  });
                                },
                              ),
                            ),
                            if (_validateLabelColor.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateLabelColor,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: w * 0.43,
                            decoration: BoxDecoration(
                              color: Color(0xffF8FCFF),
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
                              _validateLabelName =
                                  _labelnameController.text.isEmpty
                                      ? "Please enter label name"
                                      : "";
                              _validateLabelColor =
                                  _labelcolorController.text.isEmpty
                                      ? "Please select a label color"
                                      : "";

                              _isLoading = _validateLabelName.isEmpty &&
                                  _validateLabelColor.isEmpty;

                              if (_isLoading) {
                                PostToDoAddLabel();
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            width: w * 0.43,
                            decoration: BoxDecoration(
                              color: Color(0xff8856F4),
                              border: Border.all(
                                color: Color(0xff8856F4),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? spinkit.getFadingCircleSpinner()
                                  : Text(
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
                  ],
                ),
              ),
            );
          });
        }).whenComplete(() {
      _labelnameController.text = "";
      _labelcolorController.text = "";

      _validateLabelColor = "";
      _validateLabelName = "";
    });
  }

  void _bottomSheet(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.65;
    double w = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: h,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
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
                          "Add To Do List",
                          style: TextStyle(
                            color: Color(0xff1C1D22),
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
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label(text: 'Name'),
                            SizedBox(height: 6),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.050,
                              child: TextFormField(
                                controller: _taskNameController,
                                focusNode: _focusNodeTaskName,
                                keyboardType: TextInputType.text,
                                cursorColor: Color(0xff8856F4),
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0,
                                    height: 19.36 / 14,
                                    color: Color(0xffAFAFAF),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffFCFAFF),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xffd0cbdb)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xffd0cbdb)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xffd0cbdb)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xffd0cbdb)),
                                  ),
                                ),
                              ),
                            ),
                            if (_validtaskName.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    left: 8, bottom: 10, top: 5),
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    'Please enter task name',
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              SizedBox(height: 15),
                            ],
                            _label(text: 'Description'),
                            SizedBox(height: 4),
                            Container(
                              height: h * 0.1,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Color(0xffE8ECFF))),
                              child: TextFormField(
                                cursorColor: Color(0xff8856F4),
                                scrollPadding: const EdgeInsets.only(top: 5),
                                controller: _descriptionController,
                                textInputAction: TextInputAction.done,
                                maxLines: 100,
                                onTap: () {
                                  setState(() {
                                    _validdescription = "";
                                  });
                                },
                                onChanged: (v) {
                                  setState(() {
                                    _validdescription = "";
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 10, top: 10),
                                  hintText: "Description",
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 0,
                                    height: 1.2,
                                    color: Color(0xffAFAFAF),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xffFCFAFF),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xffD0CBDB)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xffD0CBDB)),
                                  ),
                                ),
                              ),
                            ),
                            if (_validdescription.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    left: 8, bottom: 10, top: 5),
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    'Please type description',
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              SizedBox(height: 15),
                            ],
                            SizedBox(height: 10),
                            _label(text: 'Date'),
                            SizedBox(height: 4),
                            _buildDateField(
                              _DateController,
                            ),
                            if (_validDate.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    left: 8, bottom: 10, top: 5),
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    'Please select date',
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              SizedBox(height: 15),
                            ],
                            _label(text: 'Priority'),
                            SizedBox(height: 4),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.050,
                              child: TypeAheadField<Priorities>(
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    focusNode: focusNode,
                                    controller: _priorityController,
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
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Select priority",
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 0,
                                        height: 1.2,
                                        color: Color(0xffAFAFAF),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffFCFAFF),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xffD0CBDB)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xffD0CBDB)),
                                      ),
                                    ),
                                  );
                                },
                                suggestionsCallback: (pattern) {
                                  return priorities
                                      .where((item) => item.priorityValue
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()))
                                      .toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(
                                      suggestion.priorityValue,
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
                                        suggestion.priorityValue;
                                    priorityid = suggestion.priorityKey;
                                    _validatePriority = "";
                                  });
                                },
                              ),
                            ),
                            if (_validatePriority.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validatePriority,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            _label(text: 'Label'),
                            SizedBox(height: 4),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.050,
                              child: TypeAheadField<Label>(
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    focusNode: focusNode,
                                    controller: _labelController,
                                    onTap: () {
                                      setState(() {
                                        _validateLabel = "";
                                      });
                                    },
                                    onChanged: (v) {
                                      setState(() {
                                        _validateLabel = "";
                                      });
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      height: 1.2,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Select label",
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 0,
                                        height: 1.2,
                                        color: Color(0xffAFAFAF),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffFCFAFF),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xffD0CBDB)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xffD0CBDB)),
                                      ),
                                    ),
                                  );
                                },
                                suggestionsCallback: (pattern) {
                                  return labels
                                      .where((item) => item.name!
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()))
                                      .toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(
                                      suggestion.name!,
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
                                    _labelController.text = suggestion.name!;
                                    // You can use suggestion.statusKey to send to the server
                                    labelid = suggestion.id!;
                                    print("labelid:${labelid}");
                                    // Call your API with the selected key here if needed
                                    _validateLabel = "";
                                  });
                                },
                              ),
                            ),
                            if (_validateLabel.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateLabel,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: w * 0.43,
                            decoration: BoxDecoration(
                              color: Color(0xffF8FCFF),
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
                              _validtaskName = _taskNameController.text.isEmpty
                                  ? "Please enter title"
                                  : "";
                              // _validdescription =
                              //     _descriptionController.text.isEmpty
                              //         ? "Please enter a description"
                              //         : "";
                              _validDate = _DateController.text.isEmpty
                                  ? "Please select date"
                                  : "";
                              // _validatePriority =
                              //     _priorityController.text.isEmpty
                              //         ? "Please select a priority"
                              //         : "";
                              // _validateLabel = _labelController.text.isEmpty
                              //     ? "Please select a label"
                              //     : "";

                              _isLoading = _validtaskName.isEmpty &&
                                  // _validdescription.isEmpty &&
                                  // _validatePriority.isEmpty &&
                                  // _validateLabel.isEmpty &&
                                  _validDate.isEmpty;

                              if (_isLoading) {
                                PostToDo();
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            width: w * 0.43,
                            decoration: BoxDecoration(
                              color: Color(0xff8856F4),
                              border: Border.all(
                                color: Color(0xff8856F4),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? spinkit.getFadingCircleSpinner()
                                  : Text(
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
                  ],
                ),
              ),
            );
          });
        }).whenComplete(() {
      _taskNameController.text = "";
      _descriptionController.text = "";
      _DateController.text = "";
      _priorityController.text = "";
      _labelController.text = "";
      _validtaskName = "";
      _validdescription = "";
      _validDate = "";
      _validatePriority = "";
      _validateLabel = "";
    });
  }

  Widget _label({
    required String text,
  }) {
    return Text(text,
        style: TextStyle(
            color: Color(0xff141516),
            fontFamily: 'Inter',
            fontSize: 14,
            height: 16.36 / 14,
            fontWeight: FontWeight.w400));
  }

  Widget _buildDateField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            _selectDate(context, controller);
            setState(() {
              // _validateDob="";
            });
          },
          child: AbsorbPointer(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Select date",
                  suffixIcon: Container(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Image.asset(
                        "assets/calendar.png",
                        color: Color(0xff000000),
                        width: 16,
                        height: 16,
                        fit: BoxFit.contain,
                      )),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    letterSpacing: 0,
                    height: 1.2,
                    color: Color(0xffAFAFAF),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: Color(0xffFCFAFF),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
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
