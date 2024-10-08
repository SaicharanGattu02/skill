import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill/Model/Get_Color_Response.dart';
import 'package:skill/screens/AddTaskScreen.dart';
import 'package:skill/utils/CustomSnackBar.dart';

import '../Model/ToDoListModel.dart';
import '../ProjectModule/UserDetailsModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  TextEditingController _taskNameController =TextEditingController();
  TextEditingController _descriptionController =TextEditingController();
  TextEditingController _startDateController =TextEditingController();

  FocusNode _focusNodeTaskName =FocusNode();
  FocusNode _focusNodedescription =FocusNode();

  final List<Map<String, String>> tasks = [
    {
      'date': 'September 23, 2024',
      'title': 'PRPL Application',
      'subtitle': 'Presentation of new products and cost structure'
    },
    {'date': 'September 24, 2024', 'title': 'Raay Project'},
    {'date': 'September 24, 2024', 'title': 'Dotclinic Project'},
    {
      'date': 'October 5, 2024',
      'title': 'Raay Project',
      'subtitle': 'Presentation of new products and cost structure'
    },
  ];

  List<TODOList> data = [];
  List<TODOList> filteredData = []; // For storing filtered tasks
  TextEditingController _searchController = TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    GetToDoList();
    // GetColorResponse();

    // Initialize filteredData to be the full data initially
    filteredData = data;

    // Listen to changes in the search bar input
    _searchController.addListener(_filterTasks);
  }

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime(2101), // Maximum date
    );
    if (pickedDate != null) {
      controller.text =
          DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
    }
  }
  Future<void> GetToDoList() async {
    var res = await Userapi.gettodolistApi();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          data = res.data ?? [];
          filteredData = data; // Initialize the filtered list to the full list
        }
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
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
     appBar:  CustomAppBar(
        title: 'Todo',
        actions: [],
        onPlusTap: () {
          // Show the bottom sheet on plus icon tap
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            // isDismissible: false,

            builder: (BuildContext context) {
              return _bottomSheet(context);
            },
          );
        },
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child:
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: w * 0.56,
                    height: h*0.043,
                    child: Container(
                      padding:  EdgeInsets.only(left: 14,right: 14,),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                      Row(
                        children: [
                          Image.asset(
                            "assets/search.png",
                            width: 20,
                            height: 17,
                            fit: BoxFit.contain,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _searchController, // Use the controller for search
                                decoration: InputDecoration(
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
                                style:  TextStyle(

                                  color: Color(0xff9E7BCA),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  decorationColor:  Color(0xff9E7BCA),

                                  fontFamily: "Nunito",

                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  SizedBox(
                    height: w * 0.09,
                    child: InkWell(
                      onTap: () {
                        _showAddTaskBottomSheet(context);
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
                              "Add Label",
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
            ),
            const SizedBox(height: 8),
            Container(
              width: w,
              height: h * 0.85,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(20),
              ),
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/More-vertical.png",
                              fit: BoxFit.contain,
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 10),
                            ClipOval(
                              child: Container(
                                width: w * 0.045,
                                height: w * 0.045,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    // color: labelColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tododata.labelName ?? "",
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
                                      overflow: TextOverflow.ellipsis,
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
            ),
          ],
        ),
      ),
    );
  }
  void _showAddTaskBottomSheet(BuildContext context) {

    // Getcolorcodes().then((response) {
    //   if (response != null) {
    //     _showBottomSheetWithColors(context, response);
    //   } else {
    //     print('Failed to load colors');
    //   }
    // });
  }

  void _showBottomSheetWithColors(BuildContext context, Get_Color_Response colorResponse) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures the bottom sheet is scrollable
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Handles keyboard overlap
              left: 16.0,
              right: 16.0,
              top: 16.0),
          child: SingleChildScrollView( // Wrap the content in a scrollable view
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Label',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Label Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<ColorItem>(
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: colorResponse.colorItem!.map((ColorItem colorItem) {
                          return DropdownMenuItem<ColorItem>(
                            value: colorItem,
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(int.parse(colorItem.colorCode ?? "")),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (ColorItem? selectedColor) {
                          // Handle color selection
                          print('Selected color: ${selectedColor?.colorName??""}');
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Dismiss the bottom sheet
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Save task logic here
                      },
                      child: Text('Add Label'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _bottomSheet(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.75;
    double w = MediaQuery.of(context).size.width;

    return Container(
      height: h, // Set the height to 70% of the screen
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
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
                    height: 18 / 16),
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
                      )),
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
                  _label(text: 'Task Name'),
                  SizedBox(height: 6),
                  _buildTextFormField(
                    controller: _taskNameController,
                    focusNode: _focusNodeTaskName,
                    hintText: 'Enter Task Name',
                    validationMessage: 'please enter task name',
                  ),
                  SizedBox(height: 10),
                  _label(text: 'Description'),
                  SizedBox(height: 4),
                  _buildTextFormField(
                    controller: _descriptionController,
                    focusNode: _focusNodedescription,
                    hintText: 'Type Description',
                    validationMessage: 'please type description',
                  ),
                  SizedBox(height: 10),

                  SizedBox(height: 10),
                  _label(text: 'Start Date'),
                  SizedBox(height: 4),
                  _buildDateField(
                    _startDateController,
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
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
              Spacer(),
              Container(
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
                  child: Text(
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
            ],
          ),
        ],
      ),
    );

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

  Widget _buildTextFormField(
      {required TextEditingController controller,
        required FocusNode focusNode,
        bool obscureText = false,
        required String hintText,
        required String validationMessage,
        TextInputType keyboardType = TextInputType.text,
        Widget? prefixicon,
        Widget? suffixicon}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.050,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        cursorColor: Color(0xff8856F4),
        decoration: InputDecoration(
          hintText: hintText,
          // prefixIcon: Container(
          //     width: 21,
          //     height: 21,
          //     padding: EdgeInsets.only(top: 10, bottom: 10, left: 6),
          //     child: prefixicon),
          suffixIcon: suffixicon,
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
            borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),
        ),
      ),
    );
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
                  hintText: "Select dob from date picker",
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


