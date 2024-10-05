import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill/Services/UserApi.dart';
import 'package:skill/utils/CustomAppBar.dart';

import '../Model/GetLeaveCountModel.dart';
import '../Model/GetLeaveModel.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Preferances.dart';
import '../utils/ShakeWidget.dart';

class Leave extends StatefulWidget {
  const Leave({super.key});

  @override
  State<Leave> createState() => _LeaveState();
}

class _LeaveState extends State<Leave> {


  bool _fromDateError = false;
  bool _toDateError = false;
  bool _reasonError = false;

  void _validateAndSubmit() {
  setState(() {
  _fromDateError = _fromController.text.isEmpty;
  _toDateError = _toController.text.isEmpty;
  _reasonError = _reasonController.text.isEmpty;
  });

  if (_fromDateError || _toDateError || _reasonError) {
  return;
  }

  // All fields are valid, proceed with the API call
  LeaveRequests();
  }



  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _leaveTypeController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  bool _loading = false;

  FocusNode _focusNodeLeavetype = FocusNode();
  FocusNode _focusNodeReason = FocusNode();

  String __validateReason = "";

  @override
  void initState() {
    super.initState();
    getleaves();
    getleavesCount();
  }

  Future<void> LeaveRequests() async {
    var data = await Userapi.LeaveRequest(
      _fromController.text,
      _toController.text,
      // _leaveTypeController.text,
      _reasonController.text,
    );
    if (data != null) {
      setState(() {
        if (data.success == 1) {
          CustomSnackBar.show(context, "${data.message}");
          Navigator.pop(context);
          getleaves();
        } else {
          CustomSnackBar.show(context, "${data.message}");
        }
      });
    } else {
      CustomSnackBar.show(context, "An error occurred. Please try again.");
    }
  }

  List<Data>? leaves;
  Future<void> getleaves() async {
    var Res = await Userapi.GetLeave();
    setState(() {
      if (Res != null) {
        _loading = false;
        if (Res.data != null) {
          leaves = Res.data ?? [];
        } else {
          print("GetLeave Failure>>${Res.message}");
        }
      }
    });
  }

  Count data = Count();
  Future<void> getleavesCount() async {
    var Res = await Userapi.GetLeaveCount();
    setState(() {
      if (Res != null) {
        if (Res.data != null) {
          _loading = false;
          data = Res.data!;
          print("getleavesCount res>>${Res}");
        } else {
          print("getleavesCount Failure>>${Res}");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: CustomAppBar(title: "Apply Leave", actions: []),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
              color: Color(0xff8856F4),
            ))
          : Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/search.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Search",
                        style: TextStyle(
                            color: Color(0xff9E7BCA),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            fontFamily: "Nunito"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      width: w * 0.44,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xff2EB67D).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: w * 0.09,
                            height: w * 0.09,
                            decoration: BoxDecoration(
                              color: Color(0xffffffff).withOpacity(0.50),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                                child: Text(
                              data?.availableLeaves.toString() ?? "N/A",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                color: Color(0xff2FB035),
                                fontWeight: FontWeight.w600,
                                height: 19.36 / 18,
                                letterSpacing: 0.14,
                              ),
                            )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: w * 0.2,
                            child: Text(
                              "Available Leaves",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w500,
                                height: 19.36 / 14,
                                letterSpacing: 0.12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: w * 0.020),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      width: w * 0.44,
                      decoration: BoxDecoration(
                        color: Color(0xff538DFF).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: w * 0.09,
                            height: w * 0.09,
                            decoration: BoxDecoration(
                              color: Color(0xffffffff).withOpacity(0.50),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                                child: Text(
                              data?.unusedLeaves.toString() ?? "N/A",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                color: Color(0xffEFA84E),
                                fontWeight: FontWeight.w600,
                                height: 19.36 / 18,
                                letterSpacing: 0.14,
                              ),
                            )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Previous Unused Leaves",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w500,
                              height: 19.36 / 14,
                              letterSpacing: 0.12,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      width: w * 0.44,
                      decoration: BoxDecoration(
                        color: Color(0x1AEFA84E).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: w * 0.09,
                            height: w * 0.09,
                            decoration: BoxDecoration(
                              color: Color(0xffffffff).withOpacity(0.50),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                                child: Text(
                              data?.pendingLeaves.toString() ?? "N/A",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                color: Color(0xffEFA84E),
                                fontWeight: FontWeight.w600,
                                height: 19.36 / 18,
                                letterSpacing: 0.14,
                              ),
                            )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Pending Leaves Requests",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w500,
                              height: 19.36 / 14,
                              letterSpacing: 0.12,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: w * 0.020),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: w * 0.44,
                      decoration: BoxDecoration(
                        color: Color(0x1ADE350B).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: w * 0.09,
                            height: w * 0.09,
                            decoration: BoxDecoration(
                              color: Color(0xffffffff).withOpacity(0.50),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                                child: Text(
                              data?.rejectedLeaves.toString() ?? "N/A",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                color: Color(0xffDE350B),
                                fontWeight: FontWeight.w600,
                                height: 19.36 / 18,
                                letterSpacing: 0.14,
                              ),
                            )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: w * 0.25,
                            child: Text(
                              "Rejected Leaves",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w500,
                                height: 19.36 / 14,
                                letterSpacing: 0.12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Text('Leaves List',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            height: 19.36 / 16,
                            color: Color(0xff16192C))),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return _bottomSheet(context);
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14, vertical: 11),
                        decoration: BoxDecoration(
                          color: Color(0xff8856F4),
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x4D5089C4),
                              offset: Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Apply Leave",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.w500,
                                height: 19.36 / 14,
                                letterSpacing: 0.12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: leaves?.length ?? 0,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final leave = leaves?[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          width: w,
                          padding:
                              const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    leave?.leaveType ?? "",
                                    style: const TextStyle(
                                      color: Color(0xff1D1C1D),
                                      fontSize: 18,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        8, 1, 8, 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0x1A13925D),
                                      borderRadius:
                                          BorderRadius.circular(100),
                                    ),
                                    child: Text(
                                      leave?.status ?? "",
                                      style: TextStyle(
                                        color: leave?.status == 'Approved'
                                            ? const Color(0xff13925D)
                                            : leave?.status == 'Pending'
                                                ? const Color(0xffEFA84E)
                                                : const Color(0xffDE350B),
                                        fontSize: 12,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                leave?.reason ?? "",
                                style: const TextStyle(
                                  color: Color(0xff787486),
                                  fontSize: 12,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${leave?.dayCount ?? ""} Days",
                                style: const TextStyle(
                                  color: Color(0xff1D1C1D),
                                  fontSize: 12,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      color: Color(0xff5F6368), size: 12),
                                  const SizedBox(width: 4),
                                  Text(
                                    "From: ${leave?.fromDate.toString() ?? ""}",
                                    style: const TextStyle(
                                      color: Color(0xff371F41),
                                      fontSize: 12,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.calendar_today,
                                      color: Color(0xff5F6368), size: 12),
                                  const SizedBox(width: 4),
                                  Text(
                                    "To: ${leave?.toDate ?? 0}",
                                    style: const TextStyle(
                                      color: Color(0xff371F41),
                                      fontSize: 12,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }


  Widget _bottomSheet(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.6;
    double w = MediaQuery.of(context).size.width;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        height: h,
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
                  "Apply Leave",
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
                    Navigator.of(context).pop(); // Close the BottomSheet
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
                    _label(text: 'From Date'),
                    SizedBox(height: 4),
                    _buildDateField(_fromController),
                    SizedBox(height: 10),
                    _label(text: 'To Date'),
                    SizedBox(height: 4),
                    _buildDateField(_toController),
                    SizedBox(height: 10),
                    _label(text: 'Reason'),
                    SizedBox(height: 4),
                    Container(
                      height: h * 0.18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xffE8ECFF)),
                      ),
                      child: TextFormField(
                        cursorColor: Color(0xff8856F4),
                        scrollPadding: const EdgeInsets.only(top: 5),
                        controller: _reasonController,
                        textInputAction: TextInputAction.done,
                        maxLines: 100,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 10, top: 10),
                          hintText: "Type Reason",
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
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: w * 0.43,
                    decoration: BoxDecoration(
                      color: Color(0xffF8FCFF),
                      border: Border.all(
                        color: Color(0xff8856F4),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, color: Color(0xff8856F4)),
                        SizedBox(width: 8),
                        Text(
                          'Close',
                          style: TextStyle(
                            color: Color(0xff8856F4),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(

                  onTap: () {
                    _validateAndSubmit(); // Call the validation and submission method
                  },
                  child: Container(
                    height: 45,
                    width: w * 0.43,
                    decoration: BoxDecoration(
                      color: Color(0xff8856F4),
                      border: Border.all(
                        color: Color(0xff8856F4),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/container_correct.png', // Replace with your apply icon path
                          width: 16,
                          height: 16,
                        ),
                        SizedBox(width: 8),
                        Text(

                          'Apply Leave',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                          ),

                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
}
