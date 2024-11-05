import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import '../Model/ProjectLabelModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/ShakeWidget.dart';
import '../utils/app_colors.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({super.key});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _DateController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();
  TextEditingController _labelController = TextEditingController();

  String _validtaskName = "";
  String _validdescription = "";
  String _validDate = "";
  String _validatePriority = "";
  String _validateLabel = "";

  FocusNode _focusNodeTaskName = FocusNode();
  String priorityid = "";
  String labelid = "";
  bool _isLoading = false;
  final spinkit = Spinkits();
  String formattedDate = "";
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _setInitialDate();
    GetLabel();
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
  }

  void _setInitialDate() {
    setState(() {
      formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      _DateController.text = formattedDate;
    });
  }

  final List<TodoPriorities> priorities = [
    TodoPriorities(priorityValue: 'Priority 1', priorityKey: '1'),
    TodoPriorities(priorityValue: 'Priority 2', priorityKey: '2'),
    TodoPriorities(priorityValue: 'Priority 3', priorityKey: '3'),
    TodoPriorities(priorityValue: 'Priority 4', priorityKey: '4'),
  ];

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

  Future<void> PostToDo() async {
    var res = await Userapi.PostProjectTodo(_taskNameController.text,
        _descriptionController.text, _DateController.text, priorityid, labelid);
    setState(() {
      _isLoading = false;
      if (res != null) {
        if (res.settings?.success == 1) {
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

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.75;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: CustomAppBar(
        title: 'Add To Do',
        actions: [Container()],
      ),
      body:

      Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: h,
          // margin: EdgeInsets.all(16),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        height: MediaQuery.of(context).size.height * 0.050,
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
                          margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
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
                      if (_validdescription.isNotEmpty) ...[
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ShakeWidget(
                            key: Key("value"),
                            duration: Duration(milliseconds: 700),
                            child: Text(
                              _validdescription,
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
                          margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
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
                        height: MediaQuery.of(context).size.height * 0.050,
                        child: TypeAheadField<TodoPriorities>(
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
                                hintText: "Select Priority",
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
                              _priorityController.text = suggestion.priorityValue;
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
                        height: MediaQuery.of(context).size.height * 0.050,
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
                                  borderRadius: BorderRadius.circular(7.0),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar:
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
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
                      color:AppColors.primaryColor,
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
                  _validDate =
                      _DateController.text.isEmpty ? "Please select date" : "";
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
}
