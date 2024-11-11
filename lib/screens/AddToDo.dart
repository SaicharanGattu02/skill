import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Model/ProjectLabelModel.dart';
import '../Providers/ProfileProvider.dart';
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
  bool _isLoading = false;
  final spinkit = Spinkits();
  String formattedDate = "";
  DateTime selectedDate = DateTime.now();

  bool isLabelDropdownOpen=false;
  String? selectedLabelvalue;
  String? selectedLabelID;

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

  String? selectedValue;
  final List<String> items = [
    'Priority 1',
    'Priority 2',
    'Priority 3',
    'Priority 4',
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
  List<Label> filteredLabels = [];
  Future<void> GetLabel() async {
    var res = await Userapi.GetProjectsLabelApi();
    setState(() {
      _isLoading = false;
      if (res != null && res.label != null) {
        labels = res.label ?? [];
        filteredLabels = res.label ?? [];
      }
    });
  }

  Future<void> PostToDo() async {
    try {
      var res = await Userapi.PostProjectTodo(
        _taskNameController.text,
        _descriptionController.text,
        _DateController.text,
        selectedValue??"",
        selectedLabelID??"",
      );
      if (res != null && res.settings?.success == 1) {
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
          await profileProvider.fetchUserDetails();
          Navigator.pop(context, true);
        CustomSnackBar.show(context, "TODO Task Added Successfully!");
      } else {
        CustomSnackBar.show(context, "${res?.settings?.message}");
      }
    } catch (e) {
      // Handle general errors, like network failures or exceptions
      print("Error posting ToDo: $e");
      CustomSnackBar.show(context, "Error posting ToDo. Please try again.");
    }
  }

  void filterLabels(String query) {
    setState(() {
      filteredLabels = labels.where((provider) {
        return provider.name != null &&
            provider.name!.toLowerCase().contains(query.toLowerCase());
      }).toList();
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
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: CustomAppBar(
        title: 'Add To Do',
        actions: [Container()],
      ),
      body: Container(
        height: h*0.77,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.only(left: 16,right: 16,top: 16),
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
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Select Priority',
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
                            .map((String item) {
                          // Define a map of priority to color for the flag icon
                          final Map<String, Color> priorityColors = {
                            'Priority 1': Colors.red,      // Red for Priority 1
                            'Priority 2': Colors.orange,   // Orange for Priority 2
                            'Priority 3': Colors.green,    // Green for Priority 3
                            'Priority 4': Colors.blue,     // Blue for Priority 4
                          };

                          // Get the color for the current item
                          Color iconColor = priorityColors[item] ?? Colors.black; // Default to black if not found

                          return DropdownMenuItem<String>(
                            value: item,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag_outlined,
                                  color: iconColor, // Set the color of the flag icon based on the priority
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        })
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                            print(selectedValue);
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 45,
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 14, right: 14),
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
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLabelDropdownOpen =
                          !isLabelDropdownOpen;
                          filteredLabels = [];
                          filteredLabels = labels;

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
                            Text(selectedLabelvalue ??
                                "Select Label"),
                            Icon(isLabelDropdownOpen
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    if (isLabelDropdownOpen) ...[
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
                                child: TextFormField(
                                  onChanged: (query) =>
                                      filterLabels(query),
                                  decoration: InputDecoration(
                                    hintText: "Search Label",
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
                                  180, // Set a fixed height for the dropdown list
                                  child:filteredLabels.length>0?
                                  ListView.builder(
                                    itemCount: filteredLabels.length,
                                    itemBuilder: (context, index) {
                                      var data = filteredLabels[index];
                                      return ListTile(
                                        minTileHeight: 30,
                                        title: Row(
                                          children: [
                                            Image.asset(
                                              "assets/label.png",
                                              width: 18,
                                              height: 18,
                                              color: hexToColor(data.color ?? ""),
                                            ),
                                            SizedBox(width: 8,),
                                            Text(
                                              data.name ?? "",
                                              style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            isLabelDropdownOpen =
                                            false;
                                            selectedLabelvalue = data.name;
                                            selectedLabelID = data.id;
                                            _validateLabel="";
                                          });
                                        },
                                      );
                                    },
                                  ):Center(child: Text("No Data found!"))
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
      bottomNavigationBar:
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
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
