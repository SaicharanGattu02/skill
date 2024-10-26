import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
// import 'package:your_package/multi_select_dropdown.dart';
import 'package:skill/Model/ProjectsModel.dart';
import '../Model/CreateZoomMeeting.dart';
import '../Model/EmployeeListModel.dart';
import '../Model/MeetingProviders.dart';
import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/ShakeWidget.dart';

class AddMeetings extends StatefulWidget {
  const AddMeetings({super.key});

  @override
  _AddMeetingsState createState() => _AddMeetingsState();
}

class _AddMeetingsState extends State<AddMeetings> {
  final spinkits = Spinkits();
  final TextEditingController _meetingtitleController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _PriojectController = TextEditingController();
  final TextEditingController _meetingTypeController = TextEditingController();
  final controller = MultiSelectController<User>();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _meetinglinkController = TextEditingController();

  bool _loading = true;

  bool isProviderDropdownOpen = false;

  String _validateMeetingTitle = "";
  String _validateDescription = "";
  String _validateProjects = "";
  String _validateMeetingType = "";
  String _validateCollaborators = "";
  String _validateTime = "";
  String _validateStartDate = "";
  String _validateMeetingLink = "";
  String _validateClientEmail = "";
  String _validateProvider = "";

  String get dateAndTime {
    // Assume _dateController.text is in the format "YYYY-MM-DD"
    // and _timeController.text is in the format "hh:mm AM/PM"
    String date = _dateController.text; // e.g., "2024-10-15"
    String time = _timeController.text; // e.g., "12:00 PM"

    // Parse the time and convert to 24-hour format
    DateFormat inputFormat = DateFormat("hh:mm a");
    DateFormat outputFormat = DateFormat("HH:mm:ss");

    DateTime parsedTime = inputFormat.parse(time);
    String formattedTime = outputFormat.format(parsedTime);

    // Combine date and formatted time
    return "$date $formattedTime"; // e.g., "2024-10-15T12:00:00"
  }

  bool _isLoading = false;
  bool isLoading = false;
  final List<String> items = [
    'Internal',
    'External',
  ];

  String? selectedValue;
  String? selectedprovidervalue;
  String? selectedproviderkey;
  @override
  void initState() {
    super.initState();
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
    controller.addListener(() {
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
    loadData();
  }

  Future<void> loadData() async {
    try {
      await Future.wait([
        GetUsersdata(),
        GetProjectsData(),
        GetMeetingProviders(),
      ]);
    } catch (e) {
      // Handle any errors that occur during the loading
      print("Error loading data: $e");
    } finally {
      setState(() {
        _loading = false; // Hide loader after all API calls complete
      });
    }
  }

  String projectid = "";
  final spinkit = Spinkits();

  List<Employeedata> employeeData = [];
  List<String> selectedIds = [];
  Future<void> GetUsersdata() async {
    var res = await Userapi.GetEmployeeList();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          employeeData = res.data ?? [];
          print("employeeData:${employeeData}");
        }
      }
    });
  }

  List<Data> projectsData = [];
  List<Data> filteredProjectsData = [];
  Future<void> GetProjectsData() async {
    var res = await Userapi.GetProjectsList();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          projectsData = res.data ?? [];
        }
      }
    });
  }

  List<Providers> providers = [];
  List<Providers> filteredProviders = [];
  Future<void> GetMeetingProviders() async {
    var res = await Userapi.fetchMeetingProviders();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          providers = res.data ?? [];
          filteredProviders = res.data ?? [];
        } else {}
      }
    });
  }

  Future<void> AddMeeting() async {
    print("Date Time:${dateAndTime}");
    String? meeting_type;
    setState(() {
      if(selectedValue=="External"){
        meeting_type="external";
      }else if(selectedValue=="Internal"){
        meeting_type="internal";
      }
    });
    var res = await Userapi.postAddMeeting(
        _meetingtitleController.text,
        _descriptionController.text,
        projectid,
        meeting_type!,
        selectedIds,
        dateAndTime,
        _meetinglinkController.text,
       _clientEmailController.text
    );
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          _isLoading = false;
          Navigator.pop(context, true);
          CustomSnackBar.show(context, "${res.settings?.message}");
        } else {
          _isLoading = false;
          CustomSnackBar.show(context, "${res.settings?.message}");
        }
      }
    });
  }

  String meeting_url = "";
  bool meeting_created = false;
  MeetingData? meetingData;
  Future<void> CreateZoomMeeting() async {
    var res = await Userapi.createZoomMeeting(
      _meetingtitleController.text,
      _descriptionController.text,
      dateAndTime,
      dateAndTime,
      _meetingTypeController.text,
      _clientEmailController.text,
    );
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          meetingData = res.data;
          meeting_created = true;
          isLoading = false;
          CustomSnackBar.show(context, "${res.settings?.message}");
        } else {
          isLoading = false;
          CustomSnackBar.show(context, "${res.settings?.message}");
        }
      }
    });
  }

  void _validateFields() {
    setState(() {
      _validateMeetingTitle = _meetingtitleController.text.isEmpty
          ? "Please enter a meetingtitle"
          : "";
      _validateDescription = _descriptionController.text.isEmpty
          ? "Please enter a description"
          : "";
      _validateProjects =
          _PriojectController.text.isEmpty ? "Please select a project" : "";
      _validateMeetingType =
          selectedValue == "" ? "Please select a meeting type" : "";
      // _validateCollaborators =
      //     selectedIds.isEmpty ? "Please add collaborators" : "";
      // _validateCollaborators =
      //     selectedIds.length == 0 ? "Please select  a collabarators" : "";
      _validateStartDate =
          _dateController.text.isEmpty ? "Please select a date" : "";
      _validateTime =
          _timeController.text.isEmpty ? "Please select a time" : "";
      // Validate meeting link only if provider is not Zoom
      if (selectedprovidervalue != "Zoom") {
        _validateMeetingLink = _meetinglinkController.text.isEmpty ? "Please enter a meeting link" : "";
      } else {
        _validateMeetingLink = ""; // Clear validation message if provider is Zoom
      }

      _isLoading = _validateMeetingTitle.isEmpty &&
          _validateDescription.isEmpty &&
          _validateProjects.isEmpty &&
          _validateMeetingType.isEmpty &&
          // _validateCollaborators.isEmpty &&
          _validateStartDate.isEmpty &&
          _validateTime.isEmpty &&
          _validateMeetingLink.isEmpty;

      if (_isLoading) {
        AddMeeting();
      }
    });
  }

  void _validateFields1() {
    setState(() {
      _validateMeetingTitle = _meetingtitleController.text.isEmpty
          ? "Please enter a meetingtitle"
          : "";
      _validateDescription = _descriptionController.text.isEmpty
          ? "Please enter a description"
          : "";
      _validateMeetingType =
          selectedValue == "" ? "Please select a meeting type" : "";
      // _validateCollaborators = selectedIds.length == 0 ? "Please select  a collabarators" : "";
      _validateStartDate =
          _dateController.text.isEmpty ? "Please select a date" : "";
      _validateTime =
          _timeController.text.isEmpty ? "Please select a time" : "";
      _validateClientEmail = _clientEmailController.text.isEmpty
          ? "Please enter a valid email."
          : "";

      isLoading = _validateMeetingTitle.isEmpty &&
          _validateDescription.isEmpty &&
          _validateMeetingType.isEmpty &&
          // _validateCollaborators.isEmpty &&
          _validateStartDate.isEmpty &&
          _validateClientEmail.isEmpty &&
          _validateTime.isEmpty;

      if (isLoading) {
        CreateZoomMeeting();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void filterProviders(String query) {
    setState(() {
      filteredProviders = providers.where((provider) {
        return provider.providerValue != null &&
            provider.providerValue!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void filterProjects(String query) {
    setState(() {
      filteredProjectsData = projectsData.where((provider) {
        return provider.name != null &&
            provider.name!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void closeDropdown() {
    setState(() {
      isProviderDropdownOpen = false; // Close the dropdown
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.75;
    double w = MediaQuery.of(context).size.width;

    var data = employeeData.map((employee) {
      return DropdownItem<User>(
        label: employee.fullName ?? "",
        value: User(
          name: employee.fullName ?? "",
          id: employee.id ?? "",
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: 'Add Meeting',
        actions: [Container()],
      ),
      body: _loading
          ? Center(
              child: spinkit.getFadingCircleSpinner(color: Color(0xff8856F4)))
          : InkResponse(
              onTap: closeDropdown, // Close dropdown on tapping anywhere
              child: Container(
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
                              hintText: 'Meeting Title',
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
                              height:
                                  MediaQuery.of(context).size.height * 0.050,
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
                                      hintText: "Select project",
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
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: const Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Select meeting type',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Inter",
                                          color: Color(0xffAFAFAF),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: items
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                    _validateMeetingType = "";
                                    print(selectedValue);
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 45,
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      color: Color(0xffD0CBDB),
                                    ),
                                    color: Color(0xffFCFAFF),
                                  ),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    size: 25,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.black,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white,
                                  ),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all(6),
                                    thumbVisibility:
                                        MaterialStateProperty.all(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
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
                            if (selectedValue == "External") ...[
                              _label(text: 'Email of joinee'),
                              SizedBox(height: 4),
                              _buildTextFormField(
                                controller: _clientEmailController,
                                hintText: 'Email of joinee',
                                validationMessage: _validateClientEmail,
                              ),
                            ],
                            _label(text: 'Collaborators'),
                            SizedBox(height: 4),
                            MultiDropdown<User>(
                              items: data,
                              controller: controller,
                              enabled: true,
                              searchEnabled: true,
                              chipDecoration: const ChipDecoration(
                                  backgroundColor: Color(0xffE8E4EF),
                                  wrap: true,
                                  runSpacing: 2,
                                  spacing: 10,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
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
                                  borderSide: const BorderSide(
                                      color: Color(0xffd0cbdb)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(
                                      color: Color(0xffd0cbdb)),
                                ),
                              ),
                              dropdownDecoration: const DropdownDecoration(
                                marginTop: 2,
                                maxHeight: 400,
                                header: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Select collaborators from the list',
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
                                disabledIcon: Icon(Icons.lock,
                                    color: Colors.grey.shade300),
                              ),
                              onSelectionChange: (selectedItems) {
                                setState(() {
                                  selectedIds = selectedItems
                                      .map((user) => user.id)
                                      .toList();
                                  _validateCollaborators = "";
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
                              const SizedBox(
                                height: 15,
                              ),
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
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            _label(text: 'Providers'),
                            SizedBox(height: 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isProviderDropdownOpen =
                                      !isProviderDropdownOpen;
                                  filteredProviders = [];
                                  filteredProviders = providers;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    border:
                                        Border.all(color: Color(0xffD0CBDB)),
                                    color: Color(0xffFCFAFF)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(selectedprovidervalue ??
                                        "Select a Provider"),
                                    Icon(isProviderDropdownOpen
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                            if (isProviderDropdownOpen) ...[
                              SizedBox(height: 5),
                              Card(
                                elevation:
                                    4, // Optional elevation for shadow effect
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Optional rounded corners
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      8.0), // Padding inside the card
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Align items to the start
                                    children: [
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          onChanged: (query) =>
                                              filterProviders(query),
                                          decoration: InputDecoration(
                                            hintText: "Search providers",
                                            hintStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Inter"),
                                            filled: true,
                                            fillColor: Color(0xffffffff),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Color(0xff000000)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Color(0xff000000)),
                                            ),
                                            contentPadding: EdgeInsets.all(8.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              10), // Space between TextField and ListView
                                      Container(
                                        height:
                                            150, // Set a fixed height for the dropdown list
                                        child: ListView.builder(
                                          itemCount: filteredProviders.length,
                                          itemBuilder: (context, index) {
                                            var data = filteredProviders[index];
                                            return ListTile(
                                              minTileHeight: 30,
                                              title: Text(
                                                data.providerValue ?? "",
                                                style: TextStyle(
                                                    fontFamily: "Inter",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  isProviderDropdownOpen =
                                                      false;
                                                  selectedprovidervalue =
                                                      data.providerValue;
                                                  selectedproviderkey = data.providerKey;
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (_validateProvider.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateProvider,
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
                            if (meetingData?.content?.meetingUrl != "") ...[
                              Text(
                                  "Created Zoom Link :\n ${meetingData?.content?.meetingUrl}")
                            ],
                            if (selectedprovidervalue == "Zoom" &&
                                !meeting_created) ...[
                              InkResponse(
                                onTap: () {
                                  _validateFields1();
                                  // if(isLoading){
                                  //
                                  // }else{
                                  //   setState(() {
                                  //     isLoading=true;
                                  //   });
                                  //   _validateFields1();
                                  // }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(
                                            0xff8856F4), // Replace with your desired color
                                        borderRadius: BorderRadius.circular(
                                            7), // Set border radius
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: isLoading
                                          ? spinkits.getFadingCircleSpinner()
                                          : Text(
                                              "Create Meeting",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (selectedprovidervalue == "Others") ...[
                              _label(text: 'Meeting Link'),
                              SizedBox(height: 6),
                              _buildTextFormField(
                                controller: _meetinglinkController,
                                hintText: 'Meeting link',
                                validationMessage: _validateMeetingLink,
                              ),
                            ],
                            SizedBox(height: 10),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white),
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
                _validateFields();
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
                      ? spinkits.getFadingCircleSpinner()
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

  Widget _buildTextFormField(
      {required TextEditingController controller,
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
            keyboardType: keyboardType,
            obscureText: obscureText,
            readOnly: !meeting_created,
            cursorColor: Color(0xff8856F4),
            onTap: () {
              closeDropdown();
            },
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
        Container(
          height: MediaQuery.of(context).size.height * 0.05,
          child: TextField(
            controller: controller,
            readOnly: true,
            onTap: () {
              _selectDate(context, controller);
              closeDropdown();
            },
            decoration: InputDecoration(
              hintText: "Select start date",
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
                borderRadius: BorderRadius.circular(7.0),
                borderSide: BorderSide(width: 1, color: Color(0xffD0CBDB)),
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
        Container(
          height: MediaQuery.of(context).size.height * 0.05,
          child: TextField(
            controller: controller,
            readOnly: true,
            onTap: () {
              _selectTime(context, controller);
              closeDropdown();
            },
            decoration: InputDecoration(
              hintText: "Select time",
              suffixIcon: Icon(
                Icons.access_time,
                size: 18,
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
                borderRadius: BorderRadius.circular(7.0),
                borderSide: BorderSide(width: 1, color: Color(0xffD0CBDB)),
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

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
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
