
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:skill/Model/ProjectsModel.dart';
import '../Model/EmployeeListModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/ShakeWidget.dart';
import 'GroupMembers.dart';

class AddMeetings extends StatefulWidget {

  const AddMeetings({super.key});

  @override
  _AddMeetingsState createState() => _AddMeetingsState();
}



class _AddMeetingsState extends State<AddMeetings> {

  final spinkits = Spinkits();
  final TextEditingController _meetingtitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _PriojectController = TextEditingController();
  final TextEditingController _meetingTypeController = TextEditingController();
  final MultiSelectController<Employeedata> _collabaratorsController = MultiSelectController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _meetinglinkController = TextEditingController();
  final List<MeetingTypess> meetingtypess = [
    MeetingTypess(meetingtypevalue: 'Internal'),
    MeetingTypess(meetingtypevalue: 'External'),

  ];


  final FocusNode _focusNodemeetingtitle = FocusNode();
  final FocusNode _focusNodedescription = FocusNode();
  final FocusNode _focusNodeProjects = FocusNode();
  final FocusNode _focusNodeMeetingtype = FocusNode();
  final FocusNode _focusNodeColabarators = FocusNode();
  final FocusNode _focusNodeTime = FocusNode();
  final FocusNode _focusNodeStartDate = FocusNode();
  final FocusNode _focusNodMeetingLink = FocusNode();


  String _validateMeetingTitle = "";
  String _validateDescription = "";
  String _validateProjects = "";
  String _validateMeetingType = "";
  String _validateCollaborators = "";
  String _validateTime = "";
  String _validateStartDate = "";
  String _validateMeetingLink = "";

  String get dateAndTime {
    return "${_dateController.text} ${_timeController.text}".trim();
  }

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    GetSerachUsersdata();
    GetProjectsData();
    _meetingtitleController.addListener(() {
      setState(() {
        _validateMeetingTitle = "";
      });
    });
    _descriptionController.addListener(() {
      setState(() {
        _validateDescription = "";
      });
    });
    _PriojectController.addListener(() {
      setState(() {
        _validateProjects = "";
      });
    });
    _meetingTypeController.addListener(() {
      setState(() {
        _validateMeetingType = "";
      });
    });
    _collabaratorsController.addListener(() {
      setState(() {
        _validateCollaborators = "";
      });
    });
    _timeController.addListener(() {
      setState(() {
        _validateTime = "";
      });
    });
    _dateController.addListener(() {
      setState(() {
        _validateStartDate = "";
      });
    });
    _meetinglinkController.addListener(() {
      setState(() {
        _validateMeetingLink = "";
      });
    });



  }


  String projectid="";



  List<Employeedata> employeeData = [];
  List<String> selectedIds = [];


  Future<void> GetSerachUsersdata() async {
    var res = await Userapi.GetEmployeeList();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          employeeData = res.data ?? [];
        }
      }
    });
  }
  List<Data> projectsData = [];

  Future<void> GetProjectsData() async {
    var res = await Userapi.GetProjectsList();
    setState(() {
      if (res != null ) {

        if (res.settings?.success == 1) {
          projectsData=res.data??[];
          print("projectsDatadata>>${projectsData}");
        } else {
          _isLoading = false;
        }
      } else {
        _isLoading = false; // Handle empty or null response
      }
    });
  }

  void _validateFields() {
    setState(() {
      _validateMeetingTitle =
      _meetingtitleController.text.isEmpty ? "Please enter a meetingtitle" : "";
      _validateDescription = _descriptionController.text.isEmpty
          ? "Please enter a description"
          : "";
      _validateProjects =
      _PriojectController.text.isEmpty ? "Please select a project" : "";
      _validateMeetingType =
      _meetingTypeController.text.isEmpty ? "Please select a meeting type" : "";
      _validateCollaborators =
      selectedIds.isEmpty ? "Please add collaborators" : "";
      _validateCollaborators =
      _collabaratorsController.disabledItems.isEmpty ? "Please select  a collabarators" : "";
      _validateStartDate =
      _dateController.text.isEmpty ? "Please select a date" : "";
      _validateTime =
      _timeController.text.isEmpty ? "Please select a time" : "";

      _validateMeetingLink=_meetinglinkController.text.isEmpty ? "Please enter a meeting link" : "";


      _isLoading = _validateMeetingTitle.isEmpty &&
          _validateDescription.isEmpty &&
          _validateProjects.isEmpty &&
          _validateMeetingType.isEmpty &&
          _validateCollaborators.isEmpty &&
          _validateStartDate.isEmpty &&
          _validateTime.isEmpty &&
          _validateMeetingLink.isEmpty;


      if (_isLoading) {
        // CreateTaskApi();
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.75;
    double w = MediaQuery.of(context).size.width;

    List<DropdownItem<Employeedata>> dropdownItems = employeeData
        .map((employee) => DropdownItem<Employeedata>(
      value: employee,
      label: employee.fullName??""

    ))
        .toList();



    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: 'Add Meeting',
        actions: [Container()],
      ),
      body:
      // _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
      Container(
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
                    _label(text: 'Meeting Title'),
                    SizedBox(height: 6),
                    _buildTextFormField(
                      controller: _meetingtitleController,
                      focusNode: _focusNodemeetingtitle,
                      hintText: 'Enter Meeting Name',
                      validationMessage: _validateMeetingTitle,
                    ),
                    SizedBox(height: 10),
                    _label(text: 'Description'),
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
                        controller: _descriptionController,
                        textInputAction: TextInputAction.done,
                        maxLines: 100,
                        decoration: InputDecoration(
                          contentPadding:
                          const EdgeInsets.only(left: 10, top: 10),
                          hintText: "Type Description",
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
                    if (_validateDescription.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateDescription,
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


                    _label(text: 'Projects'),
                    SizedBox(height: 4),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.050,
                      child: TypeAheadField<Data>(
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: _PriojectController,
                            focusNode: focusNode,
                            onTap: () {
                              setState(() {
                                _validateProjects = "";
                              });
                            },
                            onChanged: (v) {
                              setState(() {
                                _validateProjects = "";
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
                              hintText: "Select your projects",
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
                          return projectsData
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
                            _PriojectController.text = suggestion.name!;
                            // You can use suggestion.statusKey to send to the server
                            projectid = suggestion.id!;
                            // Call your API with the selected key here if needed
                            _validateProjects = "";
                          });
                        },
                      ),
                    ),
                    if (_validateProjects.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateProjects,
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


                    _label(text: 'Meeting Type'),
                    SizedBox(height: 4),
                    Container(
                      height:
                      MediaQuery.of(context).size.height * 0.050,
                      child: TypeAheadField<MeetingTypess>(
                        builder: (context, controller, focusNode) {
                          return TextField(
                            focusNode: focusNode,
                            controller: _meetingTypeController,
                            onTap: () {
                              setState(() {
                                _validateMeetingType = "";
                              });
                            },
                            onChanged: (v) {
                              setState(() {
                                _validateMeetingType = "";
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
                              hintText: "Select meeting type",
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
                          return meetingtypess
                              .where((item) => item.meetingtypevalue
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                              .toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(
                              suggestion.meetingtypevalue,
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
                            _meetingTypeController.text =
                                suggestion.meetingtypevalue;
                            _validateMeetingType = "";
                          });
                        },
                      ),
                    ),
                    if (_validateMeetingType.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateMeetingType,
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

                    _label(text: 'Collaborators'),
                    SizedBox(height: 4),
                    MultiDropdown<Employeedata>(
                      items: dropdownItems,
                      controller: _collabaratorsController,
                      enabled: true,
                      searchEnabled: true,
                      chipDecoration: const ChipDecoration(
                          backgroundColor: Color(0xffE8E4EF),
                          wrap: true,
                          runSpacing: 2,
                          spacing: 10,
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      fieldDecoration: FieldDecoration(
                        hintText: 'Collaborators',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0,
                          height: 1.2,
                          color: Color(0xffAFAFAF),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        showClearIcon: false,
                        backgroundColor: Color(0xfffcfaff),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide:
                          const BorderSide(color: Color(0xffd0cbdb)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide:    const BorderSide(color: Color(0xffd0cbdb)),
                        ),
                      ),
                      dropdownDecoration: const DropdownDecoration(
                        marginTop: 2,
                        maxHeight: 500,
                        header: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Select members from the list',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter"),
                          ),
                        ),
                      ),
                      dropdownItemDecoration: DropdownItemDecoration(
                        selectedIcon: const Icon(Icons.check_box,
                            color: Color(0xff8856F4)),
                        disabledIcon:
                        Icon(Icons.lock, color: Colors.grey.shade300),
                      ),
                      // onSelectionChange: (selectedItems) {
                      //   debugPrint("OnSelectionChange: $selectedItems");
                      // },
                      onSelectionChange: (selectedItems) {
                        setState(() {
                          // Extract only the IDs and store them in selectedIds
                          // selectedIds = selectedItems.map(() => user.id).toList();
                          _validateCollaborators="";
                        });
                        debugPrint("Selected IDs: $selectedIds");
                      },
                    ),
                    if (_validateCollaborators.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateCollaborators,
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
                      const SizedBox(height: 15),
                    ],

                    _label(text: 'Start Date'),
                    SizedBox(height: 4),
                    _buildDateField(
                      _dateController,
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
                      const SizedBox(height: 15,),
                    ],
                    SizedBox(height: 10),
                    _label(text: 'Time'),

                    SizedBox(height: 4),
                    _buildTimeField(_timeController),
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
                      const SizedBox(height: 15,),
                    ],
                    _label(text: 'Meeting Link'),
                    SizedBox(height: 6),
                    _buildTextFormField(
                      controller: _meetinglinkController,
                      focusNode: _focusNodMeetingLink,
                      hintText: 'Enter Meeting link',
                      validationMessage: _validateMeetingLink,
                    ),
                    SizedBox(height: 10),
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
            InkResponse(
              onTap: () {
                _validateFields();
              },
              child:
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
                child:
                Center(
                  child:
                  // _isLoading?spinkits.getFadingCircleSpinner():

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

  Widget _buildTextFormField(
      {required TextEditingController controller,
        required FocusNode focusNode,
        bool obscureText = false,
        required String hintText,
        required String validationMessage,
        TextInputType keyboardType = TextInputType.text,
        Widget? prefixicon,
        Widget? suffixicon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                borderSide:
                const BorderSide(width: 1, color: Color(0xffd0cbdb)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide:
                const BorderSide(width: 1, color: Color(0xffd0cbdb)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide:
                const BorderSide(width: 1, color: Color(0xffd0cbdb)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide:
                const BorderSide(width: 1, color: Color(0xffd0cbdb)),
              ),
            ),
          ),
        ),
        if (validationMessage.isNotEmpty) ...[
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
            width: MediaQuery.of(context).size.width * 0.6,
            child: ShakeWidget(
              key: Key("value"),
              duration: Duration(milliseconds: 700),
              child: Text(
                validationMessage,
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
        ]
      ],
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            _selectDate(context, controller);
            setState(() {});
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
  // Method to build the time field
  Widget _buildTimeField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            _selectTime(context, controller);
          },
          child: AbsorbPointer(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Select time from time picker",
                  suffixIcon: Container(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: Icon(Icons.access_time)
                  ),
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
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }
  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Format the selected time and update the controller
      String formattedTime = pickedTime.format(context);
      controller.text = formattedTime;
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
