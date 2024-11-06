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
import '../utils/app_colors.dart';

class TODOLIST extends StatefulWidget {
  const TODOLIST({super.key});

  @override
  State<TODOLIST> createState() => _TODOLISTState();
}

class _TODOLISTState extends State<TODOLIST> {
  TextEditingController _labelnameController = TextEditingController();
  TextEditingController _labelcolorController = TextEditingController();
  FocusNode _focusNodeLabelName = FocusNode();

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

    GetToDoList();

    filteredData = data;

    _searchController.addListener(_filterTasks);


  }


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

  Future<void> GetToDoList() async {
    var res = await Userapi.TODOListApi("","","");
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
          GetToDoList();
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
          GetToDoList();
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
    super.dispose();
  }

  Future<void> reorderTodos(Map<String, int> todosOrder) async {
    var res = await Userapi.ReorderTodos(todosOrder);
    setState(() {
      if (res != null) {

      } else {
      }
    });
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
            SizedBox(
              height: w * 0.09,
              child: InkWell(
                onTap: () {
                  GetLabelColor();
                  _showAddLabel(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffffffff), width: 1),
                        // color: Color(0xff8856F4),
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
            ),
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
                      width: w * 0.6256,
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
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddToDo()));
                          if (res == true) {
                            setState(() {
                              _isLoading = true;
                              GetToDoList();
                            });
                          }
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
                              SizedBox(width: w * 0.01),
                              Text(
                                "Add To Do",
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
                      _isLoading
                          ? _buildShimmerList()
                          : (filteredData.length > 0)
                          ? // Assuming you have a list of TODOList objects called filteredData
              SizedBox(
                height: h * 0.78,
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
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      deleteToDoList(tododata.id ?? "");
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 8),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: tododata.labelColor != null
                                              ? hexToColor(tododata.labelColor ?? "")
                                              : Colors.grey,
                                          width: 3,
                                        ),
                                      ),
                                      child: isChecked
                                          ? Icon(
                                        Icons.check,
                                        size: 10,
                                        color: Colors.white,
                                      )
                                          : null,
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
                                      if(tododata.labelName!=null)...[
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/label.png",
                                              width: 18,
                                              height: 18,
                                              color: hexToColor(tododata.labelColor ?? ""),
                                            ),
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
                                      ],
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
                                          hintText: "Select Label",
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
                                    color: AppColors.primaryColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: Text(
                                    'Close',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
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
                                      ? "Please enter Label Name"
                                      : "";
                                  _validateLabelColor =
                                  _labelcolorController.text.isEmpty
                                      ? "Please Select a Label Color"
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
                                  color: AppColors.primaryColor,
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
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.05,
          child: TextField(
            controller: controller,
            onTap: () {
              _selectDate(context, controller);
              setState(() {
                // _validateDob="";
              });
            },
            decoration: InputDecoration(
              hintText: "Select Date",
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
                borderRadius: BorderRadius.circular(7.0),
                borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10, // Adjust the number of shimmer items as needed
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
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
                        const SizedBox(height: 5),
                        shimmerText(120, 11), // Shimmer for date/time
                        const SizedBox(height: 5),
                        shimmerText(120, 11), // Shimmer for date/time
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Divider after each item
            Divider(
              thickness: 1, // Divider thickness
              color: Colors.grey[300], // Divider color
            ),
          ],
        );
      },
    );
  }

}
