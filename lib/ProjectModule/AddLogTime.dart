
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:skill/utils/CustomSnackBar.dart';
import '../Model/ProjectUserTasksModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';
import '../utils/ShakeWidget.dart';
import '../utils/app_colors.dart'; // For date formatting


class Addlogtime extends StatefulWidget {
  final projectId;
  Addlogtime({Key? key,required this.projectId}) : super(key: key); // Constructor

  @override
  _AddlogtimeState createState() => _AddlogtimeState();
}

class _AddlogtimeState extends State<Addlogtime> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _endtTimeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();

  String _validateStartDate = "";
  String _validateDeadline = "";
  String _validatenote = "";
  String _validatestarttime = "";
  String _validateendtime = "";
  String _validatetask = "";

  String taskid="";
  final spinkit=Spinkits();

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    projecttasklist();

    _startDateController.addListener(() {
      setState(() {
        _validateStartDate = "";
      });
    });

    _deadlineController.addListener(() {
      setState(() {
        _validateDeadline = "";
      });
    });
  }

  List<Data> tasks = [];
  Future<void> projecttasklist() async {
    var res = await Userapi.getprojectusertasksApi(widget.projectId);
    setState(() {
      if (res != null) {
        if (res.data != null) {
          tasks = res.data??[];
        } else {
          print("No data found");
        }
      } else {
        print("Failed to fetch data");
      }
    });
  }

  Future<void>Addlogtime() async {
    var data = await Userapi.AddLogtimeApi("${_startDateController.text} ${_startTimeController.text}","${_deadlineController.text} ${_endtTimeController.text}",_noteController.text,taskid,widget.projectId);
    if (data != null) {
      if(data.settings?.success==1){
        Navigator.pop(context,true);

        CustomSnackBar.show(context, "${data.settings?.message}");
      }else{
        CustomSnackBar.show(context, "${data.settings?.message}");
      }
    } else {

    }
  }

  Future<void> _selectstartTime(BuildContext context, String startDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      // Check if the start date is valid using yyyy-MM-dd format
      DateTime? selectedDate;
      try {
        selectedDate = DateFormat('yyyy-MM-dd').parse(startDate);
      } catch (e) {
        CustomSnackBar.show(context, "Invalid date format. Please use yyyy-MM-dd.");
        return;
      }

      final selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Check if the selected time is in the past
      if (selectedDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day)) &&
          selectedDateTime.isBefore(now)) {
        CustomSnackBar.show(context, "Selected time cannot be in the past.");
        _startTimeController.clear();
        return;
      }

      // If the selected date is today, do not allow past times
      if (selectedDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day)) &&
          selectedDateTime.isBefore(DateTime(now.year, now.month, now.day, now.hour, now.minute))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You cannot select a time that is in the past for today.'),
          ),
        );
        _startTimeController.clear();
        return;
      }
      // Update the time field if everything is valid
      setState(() {
        _startTimeController.text = DateFormat('HH:mm').format(selectedDateTime);
        if(_startTimeController.text!=""){
          _validatestarttime="";
        }
      });
    }
  }
  Future<void> _selectEndTime(BuildContext context, String endDate, String startDate, String startTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final now = DateTime.now();

      // Check if the end date is valid using yyyy-MM-dd format
      DateTime? selectedEndDate;
      try {
        selectedEndDate = DateFormat('yyyy-MM-dd').parse(endDate);
      } catch (e) {
        CustomSnackBar.show(context, "Invalid end date format. Please use yyyy-MM-dd.");
        return;
      }

      // Create a DateTime object for the selected end date and time
      final selectedEndDateTime = DateTime(
        selectedEndDate.year,
        selectedEndDate.month,
        selectedEndDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Check if the selected end date is in the past
      if (selectedEndDate.isBefore(DateTime(now.year, now.month, now.day))) {
        CustomSnackBar.show(context, "Selected end date cannot be in the past.");
        _endtTimeController.clear();
        return;
      }

      DateTime startDateTime;
      try {
        final DateTime parsedStartDate = DateFormat('yyyy-MM-dd').parse(startDate);
        final TimeOfDay parsedStartTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(startTime));
        startDateTime = DateTime(parsedStartDate.year, parsedStartDate.month, parsedStartDate.day, parsedStartTime.hour, parsedStartTime.minute);
      } catch (e) {
        CustomSnackBar.show(context, "Invalid start time format. Please ensure it's correct.");
        return;
      }

      // Check if the end date is today and if the end time is before the start time
      if (selectedEndDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
        if (selectedEndDateTime.isBefore(startDateTime)) {
          CustomSnackBar.show(context, "End time cannot be before start time.");
          _endtTimeController.clear();
          return;
        }
      }

      // Update the end time field if everything is valid
      setState(() {
        _endtTimeController.text = DateFormat('HH:mm').format(selectedEndDateTime);
        if(_endtTimeController.text!=""){
          _validateendtime="";
        }
      });
    }
  }
  void _validateFields() {
    setState(() {
      _validateStartDate =
          _startDateController.text.isEmpty ? "Please enter a start date" : "";
      _validateDeadline =
          _deadlineController.text.isEmpty ? "Please enter a end date." : "";
      _validatenote = _noteController.text.isEmpty ? "Please enter a note" : "";
      _validatestarttime =
          _startTimeController.text.isEmpty ? "Please select start time" : "";
      _validateendtime =
          _endtTimeController.text.isEmpty ? "Please select end time" : "";
      _validatetask = taskid=="" ? "Please select task" : "";

      _isLoading = _validateStartDate.isEmpty &&
          _validateDeadline.isEmpty &&
          _validatestarttime.isEmpty &&
          _validateendtime.isEmpty &&
          _validatetask.isEmpty &&
          _validatenote.isEmpty;

      if (_isLoading) {
        Addlogtime();
      }else{

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.75;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: 'Add Log Time',
        actions: [Container()],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(7))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    _label(text: 'Task'),
                    SizedBox(height: 4),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.050,
                      child: TypeAheadField<Data>(
                        controller: _taskController,
                        builder: (context, controller, focusNode) {
                          return TextField(
                            focusNode: focusNode,
                            controller: controller,
                            onTap: () {
                              setState(() {
                                _validatetask = "";
                              });
                            },
                            onChanged: (v) {
                              setState(() {
                                _validatetask = "";
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
                              hintText: "Select task",
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
                          );
                        },
                        suggestionsCallback: (pattern) {
                          return tasks
                              .where((item) => item.title!
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                              .toList();
                        },
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
                            _taskController.text = suggestion.title!;
                            // You can use suggestion.statusKey to send to the server
                            taskid = suggestion.id!;
                            // Call your API with the selected key here if needed
                            _validatetask = "";
                          });
                        },
                      ),
                    ),
                    if (_validatetask.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validatetask,
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
                    _label(text: 'Start Date'),
                    SizedBox(height: 4),
                    _buildDateField(
                      _startDateController,_validateStartDate
                    ),
                    if (_validateStartDate.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateStartDate,
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
                    _label(text: 'Start Time'),
                    SizedBox(height: 4),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: TextFormField(
                        controller: _startTimeController,
                        cursorColor: Colors.black,
                        readOnly: true,
                        onTap: () {
                          setState(() {
                            _validatestarttime="";
                            if (_startDateController.text.isEmpty) {
                              CustomSnackBar.show(context, "Please first select start date");
                            } else {
                              _selectstartTime(context,_startDateController.text);
                            }
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Select Start time",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            letterSpacing: 0,
                            height: 1.2,
                            color: Color(0xffAFAFAF),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          suffixIcon:Icon(Icons.timer_outlined,size: 22,),
                          filled: true,
                          fillColor: Color(0xffFCFAFF),
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
                    if (_validatestarttime.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validatestarttime,
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
                    _label(text: 'End Date'),
                    SizedBox(height: 4),
                    _buildDateField(
                      _deadlineController,_validateDeadline
                    ),
                    if (_validateDeadline.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateDeadline,
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
                    _label(text: 'End Time'),
                    SizedBox(height: 4),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: TextFormField(
                        controller: _endtTimeController,
                        cursorColor: Colors.black,
                        readOnly: true,
                        onTap: () {
                          if (_deadlineController.text.isEmpty ||
                              _startDateController.text.isEmpty ||
                              _startTimeController.text.isEmpty) {
                            CustomSnackBar.show(context, "Please fill in all the fields above.");
                          } else {
                            _selectEndTime(context, _deadlineController.text, _startDateController.text, _startTimeController.text);
                          }
                        },

                        decoration: InputDecoration(
                          hintText: "Select end time",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            letterSpacing: 0,
                            height: 1.2,
                            color: Color(0xffAFAFAF),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          suffixIcon:Icon(Icons.timer_outlined,size: 22,),
                          filled: true,
                          fillColor: Color(0xffFCFAFF),
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
                    if (_validateendtime.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateendtime,
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
                    _label(text: 'Note'),
                    SizedBox(height: 4),
                    Container(
                      height: h * 0.13,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xffE8ECFF))),
                      child: TextFormField(
                        cursorColor: Color(0xff8856F4),
                        scrollPadding: const EdgeInsets.only(top: 5),
                        controller: _noteController,
                        textInputAction: TextInputAction.done,
                        onTap: (){
                          setState(() {
                            _validatenote="";
                          });
                        },
                        onChanged: (v){
                          setState(() {
                            _validatenote="";
                          });
                        },
                        maxLines: 100,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: 10, top: 10),
                          hintText: "Type Note",
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
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffD0CBDB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffD0CBDB)),
                          ),
                        ),
                      ),
                    ),
                    if (_validatenote.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validatenote,
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
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            InkResponse(
              onTap: (){
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
                _validateFields();
              },
              child: Container(
                height: 40,
                width: w * 0.43,
                decoration: BoxDecoration(
                  color:AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: _isLoading?spinkit.getFadingCircleSpinner():
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
    );
  }

  Widget _buildDateField(TextEditingController controller,String validation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            _selectDate(context, controller);
            setState(() {
              validation="";
            });
          },
          child: AbsorbPointer(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Select date from date picker",
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
                    borderSide: BorderSide(width: 1, color: Color(0xffD0CBDB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(width: 1, color: Color(0xffD0CBDB)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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

  static Widget _label({required String text}) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xff141516),
        fontSize: 14,
      ),
    );
  }

  static Widget _buildButton(String text, VoidCallback onPressed, Color color) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(7),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color:
                color == Color(0xffF8FCFF) ? Color(0xff8856F4) : Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
