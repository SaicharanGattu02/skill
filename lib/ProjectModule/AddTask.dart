import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skill/Providers/ThemeProvider.dart';
import '../Model/EmployeeListModel.dart';
import '../Model/MileStoneModel.dart';
import '../Model/ProjectOverviewModel.dart';
import '../Model/ProjectPrioritiesModel.dart';
import '../Model/ProjectStatusModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/ShakeWidget.dart'; // For date formatting
import 'package:path/path.dart' as p;

import '../utils/app_colors.dart';
import '../utils/constants.dart'; // Import the path package

class AddTask extends StatefulWidget {
  final String projectId;
  final String taskid;
  final String title;

  AddTask(
      {Key? key,
      required this.projectId,
      required this.taskid,
      required this.title})
      : super(key: key); // Constructor

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool _loading = true;
  final spinkits = Spinkits();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mileStoneController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  final TextEditingController _milestoneSearchController =
      TextEditingController();
  final TextEditingController _assignedSearchController =
      TextEditingController();
  final TextEditingController _statusSearchController = TextEditingController();
  final TextEditingController _prioritySearchController =
      TextEditingController();

  final controller = MultiSelectController<User>();

  String _validateTitle = "";
  String _validateDescription = "";
  String _validateMileStone = "";
  String _validateAssignedTo = "";
  String _validateCollaborators = "";
  String _validateStatus = "";
  String _validatePriority = "";
  String _validateStartDate = "";
  String _validateDeadline = "";
  String _validatefile = "";

  bool _isLoading = false;

  bool isMilestoneDropdownOpen = false;
  String? selectedMilestoneValue;
  String? selectedMilestoneID;

  bool isAssignedtoDropdownOpen = false;
  String? selectedAssignedValue;
  String? selectedAssignedID;

  bool isStatusDropdownOpen = false;
  String? selectedStatusValue;
  String? selectedStatusID;

  bool isPriorityDropdownOpen = false;
  String? selectedPriorityValue;
  String? selectedPriorityID;

  bool isCollaboraterDropdownOpen = false;

  @override
  void initState() {
    super.initState();
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
    loadData(); // Start loading data when the widget initializes
  }

  String milestoneid = "";
  String assignedid = "";
  String statusid = "";
  String priorityid = "";

  Data? data = Data();
  List<Members> members = [];
  List<Members> filteredmembers = [];
  List<Members> filteredCollaboraters = [];
  List<String> selectedIds = [];
  List<String> selectedNames = [];

  Future<void> loadData() async {
    try {
      await Future.wait([
        GetProjectsOverviewData(),
        GetStatuses(),
        GetPriorities(),
        GetMileStone(),
      ]);
    } catch (e) {
      // Handle any errors that occur during the loading
      print("Error loading data: $e");
    } finally {
      setState(() {
        _loading = false; // Hide loader after all API calls complete
        if (widget.title == "Edit Task") {
          GetProjectTaskDetails();
        }
      });
    }
  }

  Future<void> GetProjectsOverviewData() async {
    var res = await Userapi.GetProjectsOverviewApi(widget.projectId);
    setState(() {
      if (res != null && res.data != null) {
        if (res.settings?.success == 1) {
          data = res.data;
          members = data?.members ?? [];
          filteredmembers = data?.members ?? [];
          filteredCollaboraters = data?.members ?? [];
          print("members: $members");
        } else {}
      }
    });
  }

  List<Statuses> statuses = [];
  List<Statuses> filteredstatuses = [];
  Future<void> GetStatuses() async {
    var res = await Userapi.GetProjectsStatusesApi();
    setState(() {
      if (res != null && res.data != null) {
        statuses = res.data ?? [];
        filteredstatuses = res.data ?? [];
      }
    });
  }

  List<Priorities> priorities = [];
  List<Priorities> filteredpriorities = [];
  Future<void> GetPriorities() async {
    var res = await Userapi.GetProjectsPrioritiesApi();
    setState(() {
      if (res != null && res.data != null) {
        priorities = res.data ?? [];
        filteredpriorities = res.data ?? [];
      }
    });
  }

  List<Milestones> milestones = [];
  List<Milestones> filteredMilestones = [];

  Future<void> GetMileStone() async {
    var res = await Userapi.GetMileStoneApi(widget.projectId);
    setState(() {
      if (res['success']) {
        milestones = res['response'].data ?? []; // Adjust based on your model
        filteredMilestones =
            res['response'].data ?? []; // Adjust based on your model
      } else {
        CustomSnackBar.show(
            context,
            res['response'] ??
                "Unknown error occurred"); // Show snackbar with the error
      }
    });
  }

  Future<void> GetProjectTaskDetails() async {
    try {
      var res = await Userapi.GetTaskDetail(widget.taskid);
      setState(() {
        if (res?.taskDetail != null) {
          if (res?.settings?.success == 1) {
            _titleController.text = res?.taskDetail?.title ?? "";
            _descriptionController.text = res?.taskDetail?.description ?? "";
            selectedMilestoneID = res?.taskDetail?.milestone ?? "";
            selectedAssignedID = res?.taskDetail?.assignedToId ?? "";
            selectedStatusID = res?.taskDetail?.status ?? "";
            selectedPriorityID = res?.taskDetail?.priority ?? "";

            final milestone = milestones.firstWhere(
              (m) => m.id == selectedMilestoneID,
              orElse: () => milestones[0],
            );
            selectedMilestoneValue = milestone.title;

            final assigned = members.firstWhere(
              (m) => m.id == selectedAssignedID,
              orElse: () => members[0],
            );
            selectedAssignedValue = assigned.fullName;

            final status = statuses.firstWhere(
              (m) => m.statusKey == selectedStatusID,
              orElse: () => statuses[0],
            );

            selectedStatusValue = status.statusValue;

            final priority = priorities.firstWhere(
              (m) => m.priorityKey == selectedPriorityID,
              orElse: () => priorities[0],
            );
            selectedPriorityValue = priority.priorityValue;
            _startDateController.text = res?.taskDetail?.startDate ?? "";
            _deadlineController.text = res?.taskDetail?.endDate ?? "";

            // Ensure that `members` is a list containing all available collaborators
            if (res?.taskDetail?.collaborators != null) {
              // Step 1: Populate selectedIds with IDs of the collaborators
              selectedIds = res!.taskDetail!.collaborators!
                  .map((collab) => collab.id)
                  .whereType<String>()
                  .toList();
              // Step 2: Populate selectedNames directly by filtering `members`
              selectedNames = members
                  .where((member) => selectedIds.contains(member.id))
                  .map((member) => member.fullName ?? '')
                  .toList();
            }

            print("Selected Collaborators' IDs: $selectedIds");
          } else {
            CustomSnackBar.show(
                context, res?.settings?.message ?? "Unknown error occurred.");
          }
        } else {
          print("Task GetTaskDetail: ${res?.settings?.message}");
        }
      });
    } catch (e) {
      print("Error fetching task details: $e");
      CustomSnackBar.show(
          context, "An error occurred while fetching task details.");
    }
  }

  void _validateFields() {
    setState(() {
      _validateTitle =
          _titleController.text.isEmpty ? "Please enter a title" : "";
      // _validateDescription = _descriptionController.text.isEmpty
      //     ? "Please enter a description"
      //     : "";
      _validateMileStone =
          selectedMilestoneValue == null ? "Please enter a milestone" : "";
      _validateAssignedTo =
          selectedAssignedValue == null ? "Please assign to someone" : "";
      // _validateCollaborators =
      // selectedIds.isEmpty ? "Please add collaborators" : "";
      // _validateStatus =
      // selectedStatusValue==null ? "Please set a status" : "";
      // _validatePriority =
      // selectedPriorityValue==null ? "Please set a priority" : "";
      _validateStartDate =
          _startDateController.text.isEmpty ? "Please enter a start date" : "";
      _validateDeadline =
          _deadlineController.text.isEmpty ? "Please enter a deadline" : "";
      // _validatefile = _imageFile==null ? "Please choose file." : "";

      _isLoading = _validateTitle.isEmpty &&
          // _validateDescription.isEmpty &&
          _validateMileStone.isEmpty &&
          _validateAssignedTo.isEmpty &&
          // _validateCollaborators.isEmpty &&
          // _validateStatus.isEmpty &&
          // _validatePriority.isEmpty &&
          _validateStartDate.isEmpty &&
          _validateDeadline.isEmpty;

      if (_isLoading) {
        CreateTaskApi();
      }
    });
  }

  Future<void> CreateTaskApi() async {
    var data;
    if (widget.title == "Edit Task") {
      data = await Userapi.updateTask(
          widget.taskid,
          _titleController.text,
          _descriptionController.text,
          selectedMilestoneID!,
          selectedAssignedID!,
          selectedStatusID!,
          selectedPriorityID!,
          _startDateController.text,
          _deadlineController.text,
          selectedIds,
          filepath);
    } else {
      data = await Userapi.CreateTask(
          widget.projectId,
          _titleController.text,
          _descriptionController.text,
          selectedMilestoneID ?? "",
          selectedAssignedID ?? "",
          selectedStatusID ?? "",
          selectedPriorityID ?? "",
          _startDateController.text,
          _deadlineController.text,
          selectedIds,
          filepath);
    }
    print("Task data:${data}");
    setState(() {
      if (data != null) {
        if (data.settings.success == 1) {
          _loading = false;
          Navigator.pop(context, true);
          CustomSnackBar.show(context, "${data.settings.message}");
        } else {
          _loading = false;
          CustomSnackBar.show(context, "${data.settings.message}");
        }
      } else {}
    });
  }

  XFile? _imageFile;
  File? filepath;
  String filename = "";

  Future<void> _pickImage(ImageSource source) async {
    // Check and request camera/gallery permissions
    if (source == ImageSource.camera) {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        await Permission.camera.request();
      }
    } else if (source == ImageSource.gallery) {
      var status = await Permission.photos.status;
      if (!status.isGranted) {
        await Permission.photos.request();
      }
    }
    // After permissions are handled, proceed to pick an image
    final ImagePicker picker = ImagePicker();
    XFile? selected = await picker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });

    if (selected != null) {
      // Get the file path and filename
      setState(() {
        filepath = File(selected.path);
        filename = p.basename(selected.path);
      });
      print("Selected Image: ${selected.path}");
    } else {
      print('User canceled the file picking');
    }
  }

  void filterMilestones(String query) {
    setState(() {
      filteredMilestones = milestones.where((provider) {
        return provider.title != null &&
            provider.title!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void filterMembers(String query) {
    setState(() {
      filteredmembers = members.where((provider) {
        return provider.fullName != null &&
            provider.fullName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void filterStatuses(String query) {
    setState(() {
      filteredstatuses = statuses.where((provider) {
        return provider.statusValue != null &&
            provider.statusValue!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void filterPriorities(String query) {
    setState(() {
      filteredpriorities = priorities.where((provider) {
        return provider.priorityValue != null &&
            provider.priorityValue!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void FilterCollaboraters(String query) {
    setState(() {
      filteredCollaboraters = members.where((provider) {
        return provider.fullName != null &&
            provider.fullName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void closeDropdown() {
    setState(() {
      isPriorityDropdownOpen = false;
      isStatusDropdownOpen = false;
      isAssignedtoDropdownOpen = false;
      isMilestoneDropdownOpen = false;
    });
  }

  void toggleSelection(String id, String name) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
        selectedNames.remove(name);
      } else {
        selectedIds.add(id);
        selectedNames.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.75;
    double w = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    print("Selected IDS :${selectedIds}");
    print("members :${members}");
    var items = members.map((member) {
      return DropdownItem<User>(
        label: member.fullName ?? "",
        value: User(
          name: member.fullName ?? "",
          id: member.id ?? "",
        ),
        selected: selectedIds.contains(member.id), // Mark as selected
      );
    }).toList();

    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: widget.title,
        actions: [Container()],
      ),
      body: _loading
          ? Center(
              child: spinkits.getFadingCircleSpinner(color: Color(0xff8856F4)))
          : GestureDetector(
              onTap: closeDropdown,
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: themeProvider.containerColor,
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
                            _label(text: 'Title'),
                            SizedBox(height: 6),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.050,
                              child: TextFormField(
                                controller: _titleController,
                                keyboardType: TextInputType.text,
                                cursorColor: themeProvider.curserColor,
                                onTap: () {
                                  closeDropdown();
                                  setState(() {
                                    _validateTitle = "";
                                  });
                                },
                                onChanged: (v) {
                                  setState(() {
                                    _validateTitle = "";
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  hintText: "Title",
                                  hintStyle: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                    letterSpacing: 0,
                                    height: 19.36 / 14,
                                    color: themeProvider.decorationColor,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  filled: true,
                                  fillColor: themeProvider.containerColor,
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
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ),
                            if (_validateTitle.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    left: 8, bottom: 10, top: 5),
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateTitle,
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
                            DottedBorder(
                              color: Color(0xffD0CBDB),
                              strokeWidth: 1,
                              dashPattern: [2, 2],
                              borderType: BorderType.RRect,
                              radius: Radius.circular(8),
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      closeDropdown();
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SafeArea(
                                            child: Wrap(
                                              children: <Widget>[
                                                ListTile(
                                                  leading:
                                                      Icon(Icons.camera_alt),
                                                  title: Text('Take a photo'),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.camera);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      Icon(Icons.photo_library),
                                                  title: Text(
                                                      'Choose from gallery'),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.gallery);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 35,
                                      width: w * 0.35,
                                      decoration: BoxDecoration(
                                        color: themeProvider.containerColor,
                                        border: Border.all(
                                          color: Color(0xff8856F4),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Choose File',
                                          style: TextStyle(
                                            color: Color(0xff8856F4),
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Center(
                                    child: Text(
                                      (filename != "")
                                          ? filename
                                          : 'No File Chosen',
                                      style: TextStyle(
                                        color: themeProvider.textColor,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_validatefile.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validatefile,
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
                            _label(text: 'Description'),
                            SizedBox(height: 4),
                            Container(
                              height: h * 0.13,
                              child: TextFormField(
                                cursorColor: Color(0xff8856F4),
                                scrollPadding: EdgeInsets.only(top: 5),
                                controller: _descriptionController,
                                textInputAction: TextInputAction.done,
                                maxLines: 100,
                                onTap: () {
                                  closeDropdown();
                                  setState(() {
                                    _validateDescription = "";
                                  });
                                },
                                onChanged: (v) {
                                  setState(() {
                                    _validateDescription = "";
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
                                    color: themeProvider.textColor,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  filled: true,
                                  fillColor: themeProvider.containerColor,
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
                            _label(text: 'Milestone'),
                            SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMilestoneDropdownOpen =
                                      !isMilestoneDropdownOpen;
                                  filteredMilestones = [];
                                  filteredMilestones = milestones;

                                  isAssignedtoDropdownOpen = false;
                                  isStatusDropdownOpen = false;
                                  isPriorityDropdownOpen = false;
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
                                    color: themeProvider.containerColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(selectedMilestoneValue ??
                                        "Select milestone"),
                                    Icon(isMilestoneDropdownOpen
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                            if (isMilestoneDropdownOpen) ...[
                              SizedBox(height: 5),
                              Card(
                                color: themeProvider.containerColor,
                                elevation:
                                    2, // Optional elevation for shadow effect
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
                                        child: TextFormField(
                                          controller:
                                              _milestoneSearchController,
                                          onChanged: (query) =>
                                              filterMilestones(query),
                                          decoration: InputDecoration(
                                            hintText: "Search milestone",
                                            hintStyle: TextStyle(
                                                fontSize: 15,
                                                color: themeProvider.textColor,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Inter"),
                                            filled: true,
                                            fillColor:
                                                themeProvider.containerColor,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              borderSide: BorderSide(
                                                  width: 0.5,
                                                  color:themeProvider.themeData==lightTheme? Color(0xffD0CBDB) : Color(0xffffffff),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              borderSide: BorderSide(
                                                  width: 0.5,
                                                  color:themeProvider.themeData==lightTheme? Color(0xffD0CBDB) : Color(0xffffffff),
                                                  ),
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
                                              180, // Set a fixed height for the dropdown list
                                          child: filteredMilestones.length > 0
                                              ? ListView.builder(
                                                  itemCount:
                                                      filteredMilestones.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var data =
                                                        filteredMilestones[
                                                            index];
                                                    return ListTile(
                                                      minTileHeight: 30,
                                                      title: Text(
                                                        data.title ?? "",
                                                        style: TextStyle(
                                                            fontFamily: "Inter",
                                                            fontSize: 15,
                                                            color: themeProvider
                                                                .textColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          isMilestoneDropdownOpen =
                                                              false;
                                                          selectedMilestoneValue =
                                                              data.title;
                                                          selectedMilestoneID =
                                                              data.id;
                                                          _validateMileStone =
                                                              "";
                                                        });
                                                      },
                                                    );
                                                  },
                                                )
                                              : Center(
                                                  child: Text(
                                                  "No Data found!",
                                                  style: TextStyle(
                                                      color: themeProvider
                                                          .textColor),
                                                ))),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (_validateMileStone.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateMileStone,
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
                            _label(text: 'Assign to'),
                            SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isAssignedtoDropdownOpen =
                                      !isAssignedtoDropdownOpen;
                                  filteredmembers = [];
                                  filteredmembers = members;

                                  isMilestoneDropdownOpen = false;
                                  isPriorityDropdownOpen = false;
                                  isStatusDropdownOpen = false;
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
                                    color: themeProvider.containerColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(selectedAssignedValue ??
                                        "Select assigned to"),
                                    Icon(isAssignedtoDropdownOpen
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                            if (isAssignedtoDropdownOpen) ...[
                              SizedBox(height: 5),
                              Card(
                                color: themeProvider.containerColor,
                                elevation:
                                    2, // Optional elevation for shadow effect
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
                                          controller: _assignedSearchController,
                                          onChanged: (query) =>
                                              filterMembers(query),
                                          decoration: InputDecoration(
                                            hintText: "Search member",
                                            hintStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Inter"),
                                            filled: true,
                                            fillColor:
                                                themeProvider.containerColor,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              borderSide: BorderSide(
                                                  width: 0.5,
                                                color:themeProvider.themeData==lightTheme? Color(0xffD0CBDB) : Color(0xffffffff),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              borderSide: BorderSide(
                                                  width: 0.5,
                                                                                                color:themeProvider.themeData==lightTheme? Color(0xffD0CBDB) : Color(0xffffffff),
    ),
                                            ),
                                            contentPadding: EdgeInsets.all(8.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              10), // Space between TextField and ListView
                                      Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  themeProvider.containerColor),
                                          height:
                                              180, // Set a fixed height for the dropdown list
                                          child: filteredmembers.length > 0
                                              ? ListView.builder(
                                                  itemCount:
                                                      filteredmembers.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var data =
                                                        filteredmembers[index];
                                                    return ListTile(
                                                      minTileHeight: 30,
                                                      title: Text(
                                                        data.fullName ?? "",
                                                        style: TextStyle(
                                                            fontFamily: "Inter",
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          isAssignedtoDropdownOpen =
                                                              false;
                                                          selectedAssignedValue =
                                                              data.fullName;
                                                          selectedAssignedID =
                                                              data.id;
                                                          _validateAssignedTo =
                                                              "";
                                                        });
                                                      },
                                                    );
                                                  },
                                                )
                                              : Center(
                                                  child: Text(
                                                  "No Data found!",
                                                  style: TextStyle(
                                                      color: themeProvider
                                                          .textColor),
                                                ))),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (_validateAssignedTo.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateAssignedTo,
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
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isCollaboraterDropdownOpen =
                                        !isCollaboraterDropdownOpen;
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
                                    color: themeProvider.containerColor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isCollaboraterDropdownOpen =
                                                !isCollaboraterDropdownOpen;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start, // Center content horizontally
                                          children: [
                                            Expanded(
                                              child: selectedNames.isNotEmpty
                                                  ? Wrap(
                                                      alignment: WrapAlignment
                                                          .start, // Center align chips
                                                      spacing:
                                                          4.0, // Space between chips
                                                      children: selectedNames
                                                          .map((name) {
                                                        return Chip(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          label: Text(
                                                            name,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "Inter"),
                                                          ),
                                                          deleteIcon: Icon(
                                                              Icons.clear,
                                                              size: 18),
                                                          onDeleted: () {
                                                            setState(() {
                                                              isCollaboraterDropdownOpen =
                                                                  false;
                                                              int index =
                                                                  selectedNames
                                                                      .indexOf(
                                                                          name);
                                                              selectedIds
                                                                  .removeAt(
                                                                      index);
                                                              selectedNames
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                        );
                                                      }).toList(),
                                                    )
                                                  : Text(
                                                      "Select collaborator",
                                                      style: TextStyle(
                                                          color: themeProvider
                                                              .textColor),
                                                    ),
                                            ),
                                            Icon(
                                              isCollaboraterDropdownOpen
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            if (isCollaboraterDropdownOpen) ...[
                              SizedBox(height: 5),
                              Card(
                                color: themeProvider.containerColor,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          onChanged: (query) {
                                            FilterCollaboraters(query);
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Search member",
                                            filled: true,
                                            fillColor:
                                                themeProvider.containerColor,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              borderSide: BorderSide(
                                                width: 0.5,
                                                color:themeProvider.themeData==lightTheme? Color(0xffD0CBDB) : Color(0xffffffff),

                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              borderSide: BorderSide(
                                                width: 0.5,
                                                  color:themeProvider.themeData==lightTheme? Color(0xffD0CBDB) : Color(0xffffffff),

                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(8.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: 180,
                                        child: filteredCollaboraters.length > 0
                                            ? ListView.builder(
                                                itemCount: filteredCollaboraters
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  var data =
                                                      filteredCollaboraters[
                                                          index];
                                                  bool isSelected = selectedIds
                                                      .contains(data.id);
                                                  return ListTile(
                                                    minVerticalPadding: 0,
                                                    title: Text(
                                                      data.fullName ?? "",
                                                      style: TextStyle(
                                                        fontFamily: "Inter",
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    trailing: Checkbox(
                                                      value: isSelected,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isCollaboraterDropdownOpen =
                                                              false;
                                                          _validateCollaborators =
                                                              "";
                                                        });
                                                        toggleSelection(
                                                            data.id!,
                                                            data.fullName!);
                                                      },
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        isCollaboraterDropdownOpen =
                                                            false;
                                                        _validateCollaborators =
                                                            "";
                                                      });
                                                      toggleSelection(data.id!,
                                                          data.fullName!);
                                                    },
                                                  );
                                                },
                                              )
                                            : Center(
                                                child: Text(
                                                "No Data found!",
                                                style: TextStyle(
                                                    color: themeProvider
                                                        .textColor),
                                              )),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            _label(text: 'Status'),
                            SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isStatusDropdownOpen = !isStatusDropdownOpen;
                                  filteredstatuses = [];
                                  filteredstatuses = statuses;

                                  isMilestoneDropdownOpen = false;
                                  isAssignedtoDropdownOpen = false;
                                  isPriorityDropdownOpen = false;
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
                                    color: themeProvider.containerColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        selectedStatusValue ?? "Select status"),
                                    Icon(isStatusDropdownOpen
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                            if (isStatusDropdownOpen) ...[
                              SizedBox(height: 5),
                              Card(
                                color: themeProvider.containerColor,
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
                                          controller: _statusSearchController,
                                          onChanged: (query) =>
                                              filterStatuses(query),
                                          decoration: InputDecoration(
                                            hintText: "Search status",
                                            hintStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Inter"),
                                            filled: true,
                                            fillColor:
                                                themeProvider.containerColor,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              borderSide: BorderSide(
                                                width: 0.5,
                                                color:themeProvider.themeData==lightTheme? Color(0xffD0CBDB) : Color(0xffffffff),
                                              ),
                                              ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              borderSide: BorderSide(
                                                width: 0.5,
                                                color:themeProvider.themeData==lightTheme? Color(0xffD0CBDB) : Color(0xffffffff),
                                              ),
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
                                              180, // Set a fixed height for the dropdown list
                                          child: filteredstatuses.length > 0
                                              ? ListView.builder(
                                                  itemCount:
                                                      filteredstatuses.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var data =
                                                        filteredstatuses[index];
                                                    return ListTile(
                                                      minTileHeight: 30,
                                                      title: Text(
                                                        data.statusValue ?? "",
                                                        style: TextStyle(
                                                            fontFamily: "Inter",
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          isStatusDropdownOpen =
                                                              false;
                                                          selectedStatusValue =
                                                              data.statusValue;
                                                          selectedStatusID =
                                                              data.statusKey;
                                                          _validateStatus = "";
                                                        });
                                                      },
                                                    );
                                                  },
                                                )
                                              : Center(
                                                  child:
                                                      Text("No Data found!"))),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (_validateStatus.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateStatus,
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
                            _label(text: 'Priority'),
                            SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPriorityDropdownOpen =
                                      !isPriorityDropdownOpen;
                                  filteredpriorities = [];
                                  filteredpriorities = priorities;

                                  isMilestoneDropdownOpen = false;
                                  isAssignedtoDropdownOpen = false;
                                  isStatusDropdownOpen = false;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    border: Border.all(
                                      color:themeProvider.themeData==lightTheme? Color(0xffD0CBDB) : Color(0xffffffff),
                                    ),
                                    color: themeProvider.containerColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(selectedPriorityValue ??
                                        "Select priority"),
                                    Icon(isPriorityDropdownOpen
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                            if (isPriorityDropdownOpen) ...[
                              SizedBox(height: 5),
                              Card(
                                color: themeProvider.containerColor,
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
                                          controller: _prioritySearchController,
                                          onChanged: (query) =>
                                              filterPriorities(query),
                                          decoration: InputDecoration(
                                            hintText: "Search priority",
                                            hintStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Inter"),
                                            filled: true,
                                            fillColor:
                                                themeProvider.containerColor,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              borderSide: BorderSide(
                                                width: 0.5,
                                                color:themeProvider.themeData==lightTheme? Color(0xffD0CBDB) : Color(0xffffffff),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              borderSide: BorderSide(
                                                width: 0.5,
                                                color:themeProvider.themeData==lightTheme? Color(0xffD0CBDB) : Color(0xffffffff),
                                              ),
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
                                              180, // Set a fixed height for the dropdown list
                                          child: filteredpriorities.length > 0
                                              ? ListView.builder(
                                                  itemCount:
                                                      filteredpriorities.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var data =
                                                        filteredpriorities[
                                                            index];
                                                    return ListTile(
                                                      minTileHeight: 30,
                                                      title: Text(
                                                        data.priorityValue ??
                                                            "",
                                                        style: TextStyle(
                                                            fontFamily: "Inter",
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          isPriorityDropdownOpen =
                                                              false;
                                                          selectedPriorityValue =
                                                              data.priorityValue;
                                                          selectedPriorityID =
                                                              data.priorityKey;
                                                          _validatePriority =
                                                              "";
                                                        });
                                                      },
                                                    );
                                                  },
                                                )
                                              : Center(
                                                  child: Text(
                                                  "No Data found!",
                                                  style: TextStyle(
                                                      color: themeProvider
                                                          .textColor),
                                                ))),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                            _label(text: 'Start Date'),
                            SizedBox(height: 4),
                            _buildDateField(
                              _startDateController,
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
                            _label(text: 'Deadline'),
                            SizedBox(height: 4),
                            _buildDateField(
                              _deadlineController,
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
        decoration: BoxDecoration(color: themeProvider.containerbcColor),
        child: Row(
          children: [
            InkResponse(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: w * 0.43,
                decoration: BoxDecoration(
                  color: themeProvider.containerbcColor,
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

  Widget _buildDateField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.05,
              child: TextField(
                controller: controller,
                readOnly: true,
                onTap: () {
                  _selectDate(context, controller);
                },
                decoration: InputDecoration(
                  hintText: "Select date",
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
                  fillColor: themeProvider.containerColor,
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
            );
          },
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
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
