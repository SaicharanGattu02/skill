import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Model/MileStoneModel.dart';
import '../Model/ProjectOverviewModel.dart';
import '../Model/ProjectPrioritiesModel.dart';
import '../Model/ProjectStatusModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/ShakeWidget.dart'; // For date formatting
import 'package:path/path.dart' as p; // Import the path package


class TaskForm extends StatefulWidget {
  final String projectId; // Explicitly define the type

  TaskForm({Key? key, required this.projectId})
      : super(key: key); // Constructor

  @override
  _TaskFormState createState() => _TaskFormState();
}
bool _loading =true;
class User {
  final String name;
  final String id;

  User({required this.name, required this.id});

  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}

class _TaskFormState extends State<TaskForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mileStoneController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();
  final TextEditingController _colloratorsController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  final FocusNode _focusNodetitle = FocusNode();
  final FocusNode _focusNodedescription = FocusNode();
  final FocusNode _focusNodemileStone = FocusNode();
  final FocusNode _focusNodeassignedTo = FocusNode();
  final FocusNode _focusNodecollorators = FocusNode();
  final FocusNode _focusNodestatus = FocusNode();
  final FocusNode _focusNodepriority = FocusNode();

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
  @override
  void initState() {
    super.initState();

    _titleController.addListener(() {
      setState(() {
        _validateTitle = "";
      });
    });
    _descriptionController.addListener(() {
      setState(() {
        _validateDescription = "";
      });
    });
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
    _colloratorsController.addListener(() {
      setState(() {
        _validateCollaborators = "";
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
    GetProjectsOverviewData();
    GetStatuses();
    GetPriorities();
    GetMileStone();
  }

  String milestoneid="";
  String assignedid="";
  String statusid="";
  String priorityid="";

  var items;
  Data? data = Data();
  List<Members> members = [];
  List<String> selectedIds = []; // List to store selected user IDs

  Future<void> GetProjectsOverviewData() async {


    var res = await Userapi.GetProjectsOverviewApi(widget.projectId);
    setState(() {
      if (res != null && res.data != null) {

        _loading=false;
        data = res.data;
        members = data?.members ?? [];

        print("members:${members}");
        items = members.map((member) {

          return DropdownItem<User>(
            label: member.fullName ?? "",
            value: User(
              name: member.fullName ?? "",
              id: member.id ?? "",
            ),
          );
        }).toList();
        print("items:${items}");
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

  List<Milestones> milestones = [];
  Future<void> GetMileStone() async {
    var res = await Userapi.GetMileStoneApi(widget.projectId);
    setState(() {
      if (res != null) {
        if (res.data != null) {
          milestones = res.data ?? [];
          print(milestones);
        } else {
          print("Task Failure  ${res.settings?.message}");
        }
      }
    });
  }

  void _validateFields() {
    setState(() {
      _validateTitle =
          _titleController.text.isEmpty ? "Please enter a title" : "";
      _validateDescription = _descriptionController.text.isEmpty
          ? "Please enter a description"
          : "";
      _validateMileStone =
          _mileStoneController.text.isEmpty ? "Please enter a milestone" : "";
      _validateAssignedTo =
          _assignedToController.text.isEmpty ? "Please assign to someone" : "";
      _validateCollaborators =
          selectedIds.isEmpty ? "Please add collaborators" : "";
      _validateStatus =
          _statusController.text.isEmpty ? "Please set a status" : "";
      _validatePriority =
          _priorityController.text.isEmpty ? "Please set a priority" : "";
      _validateStartDate =
          _startDateController.text.isEmpty ? "Please enter a start date" : "";
      _validateDeadline =
          _deadlineController.text.isEmpty ? "Please enter a deadline" : "";
      _validatefile = _imageFile==null ? "Please choose file." : "";

      _isLoading = _validateTitle.isEmpty &&
          _validateDescription.isEmpty &&
          _validateMileStone.isEmpty &&
          _validateAssignedTo.isEmpty &&
          _validateCollaborators.isEmpty &&
          _validateStatus.isEmpty &&
          _validatePriority.isEmpty &&
          _validateStartDate.isEmpty &&
          _validateDeadline.isEmpty;

      if (_isLoading) {
        CreateTaskApi();
      }
    });
  }

  Future<void> CreateTaskApi() async {
    var data = await Userapi.CreateTask(
        widget.projectId,
        _titleController.text,
        _descriptionController.text,
        milestoneid,
        assignedid,
        statusid,
        priorityid,
        _startDateController.text,
        _deadlineController.text,
        selectedIds,
        File(_imageFile!.path));
    if (data != null) {
      if(data.settings.success==1){
        Navigator.pop(context,true);
        CustomSnackBar.show(context, "${data.settings.message}");
      }else{
        CustomSnackBar.show(context, "${data.settings.message}");
      }
    } else {

    }
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

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.75;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: 'Add Task',
        actions: [Container()],
      ),
      body:
      _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
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
                    _label(text: 'Title'),
                    SizedBox(height: 6),
                    _buildTextFormField(
                      controller: _titleController,
                      focusNode: _focusNodetitle,
                      hintText: 'Enter Project Name',
                      validationMessage: _validateTitle,
                    ),
                    SizedBox(height: 10),
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
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SafeArea(
                                    child: Wrap(
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(Icons.camera_alt),
                                          title: Text('Take a photo'),
                                          onTap: () {
                                            _pickImage(ImageSource.camera);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.photo_library),
                                          title: Text('Choose from gallery'),
                                          onTap: () {
                                            _pickImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child:
                            Container(
                              height: 35,
                              width: w * 0.35,
                              decoration: BoxDecoration(
                                color: Color(0xffF8FCFF),
                                border: Border.all(
                                  color: Color(0xff8856F4),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
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
                              (filename != "") ? filename : 'No File Chosen',
                              style: TextStyle(
                                color: Color(0xff3C3C3C),
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
                    _label(text: 'Milestone'),
                    SizedBox(height: 4),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.050,
                      child: TypeAheadField<Milestones>(
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: _mileStoneController,
                            focusNode: focusNode,
                            autofocus: true,
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
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: "Select your milestone",
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
                          return milestones
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
                            _mileStoneController.text = suggestion.title!;
                            // You can use suggestion.statusKey to send to the server
                             milestoneid = suggestion.id!;
                            // Call your API with the selected key here if needed
                            _validateMileStone = "";
                          });
                        },
                      ),
                    ),
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.050,
                      child: TypeAheadField<Members>(
                        builder: (context, controller, focusNode) {
                          return TextField(
                            focusNode: focusNode,
                            controller: _assignedToController,
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
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: "Select assigned to person",
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
                          return members
                              .where((item) => item.fullName!
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
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
                            _assignedToController.text = suggestion.fullName!;
                            // You can use suggestion.statusKey to send to the server
                            assignedid = suggestion.id!;
                            // Call your API with the selected key here if needed
                            _validateAssignedTo = "";
                          });
                        },
                      ),
                    ),
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
                    MultiDropdown<User>(
                      items: items,
                      controller: controller,
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
                          borderSide: const BorderSide(
                            color: Colors.black87,
                          ),
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
                          selectedIds = selectedItems.map((user) => user.id).toList();
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
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                    _label(text: 'Status'),
                    SizedBox(height: 4),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.050,
                      child: TypeAheadField<Statuses>(
                        builder: (context, controller, focusNode) {
                          return TextField(
                            focusNode: focusNode,
                            autofocus: true,
                            controller: _statusController,
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
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter your status",
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
                          return statuses
                              .where((item) => item.statusValue!
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
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
                            _statusController.text = suggestion.statusValue!;
                            // You can use suggestion.statusKey to send to the server
                            statusid = suggestion.statusKey!;
                            // Call your API with the selected key here if needed
                            _validateStatus = "";
                          });
                        },
                      ),
                    ),
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.050,
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
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffD0CBDB)),
                              ),
                            ),
                          );
                        },
                        suggestionsCallback: (pattern) {
                          return priorities
                              .where((item) => item.priorityValue!
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
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
                            priorityid = suggestion.priorityKey!;
                            // Call your API with the selected key here if needed
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
