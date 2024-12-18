import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill/Providers/MileStoneProvider.dart';

import '../Model/MileStoneModel.dart';
import '../Providers/ThemeProvider.dart';
import '../Services/UserApi.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/ShakeWidget.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class MileStone extends StatefulWidget {
  final String id;
  const MileStone({super.key, required this.id});

  @override
  State<MileStone> createState() => _MileStoneState();
}

class _MileStoneState extends State<MileStone> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _focusNodetitle = FocusNode();
  final spinkit = Spinkits();
  String title = "";
  String description = "";
  String deadline = "";
  bool isSaving = false;

  @override
  void initState() {
    GetMilestonesList();
    super.initState();
  }

  Future<void> GetMilestonesList() async {
    final milestoneProvider =
        Provider.of<MileStoneProvider>(context, listen: false);
    milestoneProvider.fetchMileStonesList(widget.id);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> GetMileStoneDetails(String id) async {
    var res = await Userapi.getmilestonedeatilsApi(id);
    setState(() {
      if (res?.data != null) {
        if (res?.settings?.success == 1) {
          _titleController.text = res?.data?.title ?? "";
          _deadlineController.text = res?.data?.dueDate ?? "";
          _descriptionController.text = res?.data?.description ?? "";
          _bottomSheet(context, "Edit", id);
        }
      } else {}
    });
  }

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Minimum date
      lastDate: DateTime(2101), // Maximum date
    );
    if (pickedDate != null) {
      controller.text =
          DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final milestoneProvider = Provider.of<MileStoneProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Row
              Row(
                children: [
                  SizedBox(
                    child: Center(
                      child: Container(
                        width: w * 0.53,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/search.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (v) {
                                  milestoneProvider
                                      .filterMileStones(_searchController.text);
                                },
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
                                    decorationColor: Color(0xff9E7BCA),
                                    fontFamily: "Nunito",
                                    overflow: TextOverflow.ellipsis),
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  // Add Milestone Button
                  SizedBox(
                    height: w * 0.09,
                    child: InkWell(
                      onTap: () {
                        return _bottomSheet(context, "Add", "");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: themeProvider.primaryColor,
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
                              "Add Milestones",
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
              SizedBox(height: 8),
              milestoneProvider.isLoading
                  ? _buildShimmerList(context)
                  : milestoneProvider.filteredMilestones.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.24,
                              ),
                              Image.asset(
                                'assets/nodata1.png', // Make sure to use the correct image path
                                width:
                                    150, // Adjust the size according to your design
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
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: milestoneProvider.filteredMilestones
                              .length, // Use filteredRooms instead of rooms
                          itemBuilder: (context, index) {
                            final milestone =
                                milestoneProvider.filteredMilestones[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: themeProvider.themeData == lightTheme
                                    ? Color(0xffffffff)
                                    : AppColors.darkmodeContainerColor,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/calendar.png",
                                        fit: BoxFit.contain,
                                        width: w * 0.06,
                                        height: w * 0.05,
                                        color: Color(0xff6C848F),
                                      ),
                                      Text(
                                        milestone.dueDate ?? "",
                                        style: TextStyle(
                                          color: themeProvider.themeData ==
                                                  lightTheme
                                              ? Color(0xff1D1C1D)
                                              : themeProvider.textColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          height: 19.41 / 15,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          GetMileStoneDetails(
                                              milestone.id ?? "");
                                        },
                                        child: Image.asset(
                                          "assets/edit.png",
                                          fit: BoxFit.contain,
                                          width: w * 0.06,
                                          height: w * 0.05,
                                          color: themeProvider.themeData ==
                                                  lightTheme
                                              ? themeProvider.primaryColor
                                              : themeProvider.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    milestone.title ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 19.36 / 16,
                                      color: themeProvider.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    milestone.description ?? "",
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 18.15 / 14,
                                      color:
                                          themeProvider.themeData == lightTheme
                                              ? Color(0xff6C848F)
                                              : themeProvider.textColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  LinearProgressIndicator(
                                    value: (milestone.totalTasks != 0)
                                        ? (milestone.tasksDone ?? 0) /
                                            (milestone.totalTasks ?? 1)
                                        : 0.0, // If totalTasks is 0, set progress to 0
                                    minHeight: 8,
                                    backgroundColor: const Color(0xffE0E0E0),
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xff2FB035),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Progress",
                                        style: TextStyle(
                                          color: themeProvider.themeData ==
                                                  lightTheme
                                              ? Color(0xff6C848F)
                                              : themeProvider.textColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                      Text(
                                        "${(((milestone.totalTasks != 0) ? (milestone.tasksDone ?? 0) / (milestone.totalTasks ?? 1) : 0.0) * 100).toStringAsFixed(0)}%", // Round to nearest integer
                                        style: TextStyle(
                                          color: themeProvider.themeData ==
                                                  lightTheme
                                              ? Color(0xff6C848F)
                                              : themeProvider.textColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      itemCount: 10, // Adjust the number of shimmer items as needed
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  shimmerRectangle(20, context), // Shimmer for calendar icon
                  const SizedBox(width: 8),
                  shimmerText(100, 15, context), // Shimmer for due date
                  const Spacer(),
                  shimmerRectangle(20, context), // Shimmer for edit icon
                ],
              ),
              const SizedBox(height: 20),
              shimmerText(150, 20, context), // Shimmer for milestone title
              const SizedBox(height: 4),
              shimmerText(
                  300, 14, context), // Shimmer for milestone description
              const SizedBox(height: 10),
              shimmerText(350, 14, context),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  shimmerText(60, 14, context), // Shimmer for "Progress" label
                  shimmerText(40, 14, context), // Shimmer for percentage
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _bottomSheet(
    BuildContext context,
    String mode,
    String id,
  ) {
    double h = MediaQuery.of(context).size.height * 0.55;
    double w = MediaQuery.of(context).size.width;
    final milestoneProvider = Provider.of<MileStoneProvider>(context);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                Future<void> PostMilestoneApi(String editId) async {
                  var res;
                  if (editId != "") {
                    res = await milestoneProvider.EditMileStone(
                        widget.id,
                        editId,
                        _titleController.text,
                        _descriptionController.text,
                        _deadlineController.text);
                  } else {
                    res = await milestoneProvider.AddMileStone(
                        _titleController.text,
                        _descriptionController.text,
                        widget.id,
                        _deadlineController.text);
                  }
                  if (res == 1) {
                    CustomSnackBar.show(
                        context, "MileStone Added Successfully!");
                    Navigator.pop(context);
                  } else {
                    CustomSnackBar.show(context, "MileStone Adding Failed!");
                  }
                }

                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    height: h,
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      color: themeProvider.containerColor,
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
                              ("${mode} Milestones"),
                              style: TextStyle(
                                color: themeProvider.textColor,
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
                                _label(text: 'Title'),
                                SizedBox(height: 6),
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.050,
                                  child: TextFormField(
                                    controller: _titleController,
                                    focusNode: _focusNodetitle,
                                    keyboardType: TextInputType.text,
                                    cursorColor: Color(0xff8856F4),
                                    decoration: InputDecoration(
                                      hintText: "Enter Title.",
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        height: 19.36 / 14,
                                        color: Color(0xffAFAFAF),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      filled: true,
                                      fillColor: themeProvider.fillColor,
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
                                if (title.isNotEmpty) ...[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(
                                        left: 8, bottom: 10, top: 5),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: ShakeWidget(
                                      key: Key("value"),
                                      duration: Duration(milliseconds: 700),
                                      child: Text(
                                        title,
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
                                  height: h * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    // border: Border.all(color: Color(0xffE8ECFF)
                                    // )
                                  ),
                                  child: TextFormField(
                                    cursorColor: Color(0xff8856F4),
                                    scrollPadding:
                                        const EdgeInsets.only(top: 5),
                                    controller: _descriptionController,
                                    textInputAction: TextInputAction.done,
                                    maxLines: 100,
                                    onTap: () {
                                      setState(() {
                                        description = "";
                                      });
                                    },
                                    onChanged: (v) {
                                      setState(() {
                                        description = "";
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 10, top: 10),
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
                                      fillColor: themeProvider.containerColor,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: themeProvider.themeData ==
                                                  lightTheme
                                              ? Color(0xffD0CBDB)
                                              : Color(0xffffffff),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: themeProvider.themeData ==
                                                  lightTheme
                                              ? Color(0xffD0CBDB)
                                              : Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (description.isNotEmpty) ...[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(
                                        left: 8, bottom: 10, top: 5),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: ShakeWidget(
                                      key: Key("value"),
                                      duration: Duration(milliseconds: 700),
                                      child: Text(
                                        description,
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
                                _label(text: 'Deadline'),
                                SizedBox(height: 4),
                                _buildDateField(_deadlineController),
                                if (deadline.isNotEmpty) ...[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(
                                        left: 8, bottom: 10, top: 5),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: ShakeWidget(
                                      key: Key("value"),
                                      duration: Duration(milliseconds: 700),
                                      child: Text(
                                        deadline,
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
                                SizedBox(height: 15),
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
                                  color: themeProvider.containerColor,
                                  border: Border.all(
                                    color: themeProvider.primaryColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: Text(
                                    'Close',
                                    style: TextStyle(
                                      color: themeProvider.primaryColor,
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
                                  isSaving = true;
                                  title = _titleController.text.isEmpty
                                      ? "Please enter title"
                                      : "";
                                  description =
                                      _descriptionController.text.isEmpty
                                          ? "Please enter a description"
                                          : "";
                                  deadline = _deadlineController.text.isEmpty
                                      ? "Please enter a deadline"
                                      : "";

                                  if (title.isEmpty &&
                                      description.isEmpty &&
                                      deadline.isEmpty) {
                                    if (isSaving) {
                                    } else {
                                      if (mode == "Edit") {
                                        PostMilestoneApi(id);
                                      } else {
                                        PostMilestoneApi("");
                                      }
                                    }
                                  } else {
                                    isSaving = false;
                                  }
                                });
                              },
                              child: Container(
                                height: 40,
                                width: w * 0.43,
                                decoration: BoxDecoration(
                                  color: themeProvider.primaryColor,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: isSaving
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
            },
          );
        }).whenComplete(() {
      _titleController.text = "";
      _descriptionController.text = "";
      _deadlineController.text = "";
      title = "";
      description = "";
      deadline = "";
    });
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
                  hintText: "Select Date from Date Picker",
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
                    color: Color(0xffAFAFAF),
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

  Widget _label({
    required String text,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Text(text,
            style: TextStyle(
                color: themeProvider.textColor,
                fontFamily: 'Inter',
                fontSize: 14,
                height: 16.36 / 14,
                fontWeight: FontWeight.w400));
      },
    );
  }
}
