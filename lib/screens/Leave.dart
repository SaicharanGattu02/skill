import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill/Services/UserApi.dart';
import 'package:skill/utils/CustomAppBar.dart';

import '../Model/GetLeaveCountModel.dart';
import '../Model/GetLeaveModel.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
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
  List<Data> rooms = [];
  List<Data> filteredRooms = [];
  bool isSelected = false;
  bool _isLoading = true;

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

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
  final TextEditingController _searchController = TextEditingController();

  FocusNode _focusNodeLeavetype = FocusNode();
  FocusNode _focusNodeReason = FocusNode();
  String _validateReason = "";
  String _validatefrom = "";
  String _validateto = "";

  @override
  void initState() {
    super.initState();
    getleaves();
    _searchController.addListener(_onSearchChanged);
    getleavesCount();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredRooms = rooms.where((room) {
        String otherUser =
            room.fromDate?.toLowerCase() ?? ''; // Handle null cases
        String message = room.dayCount?.toLowerCase() ?? '';
        return otherUser.contains(query) || message.contains(query);
      }).toList();
      print('Filtered rooms: ${filteredRooms.length}'); // Debug log
    });
  }

  Future<void> LeaveRequests() async {
    var data = await Userapi.LeaveRequest(
      _fromController.text,
      _toController.text,
      _reasonController.text,
    );
    if (data != null) {
      setState(() {
        if (data.success == 1) {
          CustomSnackBar.show(context, "${data.message}");
          Navigator.pop(context);
          getleaves();
          getleavesCount();
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
        if (Res.success == 1) {
          _isLoading = false;
          leaves = Res.data ?? [];
          rooms = leaves!; // Set the original data
          filteredRooms = rooms; // Initially filteredRooms is the same as rooms
        }
      }
    });
  }

  Count? data;
  Future<void> getleavesCount() async {
    var res = await Userapi.GetLeaveCount();
    setState(() {
      if (res != null) {
        if (res.success == 1) {
          // _isLoading = false;
          data = res.data;
          CustomSnackBar.show(context, "${res.message}");
        } else {
          CustomSnackBar.show(context, "${res.message}");
        }
      } else {
        CustomSnackBar.show(context, "An error occurred. Please try again.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: CustomAppBar(title: "Apply Leave", actions: [Container()]),
      body: _isLoading
          ? _buildShimmerLeaveRequests(w)
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // InkWell(onTap: (){
                  //
                  // },
                  //   child:
                  //   SizedBox(
                  //     width: w,
                  //     height: h*0.043,
                  //     child:
                  //     Container(
                  //       padding:  EdgeInsets.only(left: 14,right: 14,),
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xffffffff),
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //       child:
                  //       Row(
                  //         children: [
                  //           Image.asset(
                  //             "assets/search.png",
                  //             width: 20,
                  //             height: 17,
                  //             fit: BoxFit.contain,
                  //           ),
                  //           Expanded(
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: TextField(
                  //                 controller: _searchController,
                  //                 decoration: InputDecoration(
                  //                   border: InputBorder.none,
                  //                   hintText: 'Search',
                  //                   hintStyle: const TextStyle(
                  //                     overflow: TextOverflow.ellipsis,
                  //                     color: Color(0xff9E7BCA),
                  //                     fontWeight: FontWeight.w400,
                  //                     fontSize: 14,
                  //                     fontFamily: "Nunito",
                  //
                  //                   ),
                  //                 ),
                  //                 style:  TextStyle(
                  //
                  //                   color: Color(0xff9E7BCA),
                  //                   fontWeight: FontWeight.w400,
                  //                   fontSize: 16,
                  //                   decorationColor:  Color(0xff9E7BCA),
                  //
                  //                   fontFamily: "Nunito",
                  //
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                                  (data!.availableLeaves != null)
                                      ? data?.availableLeaves.toString() ?? "0"
                                      : "0",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    color: Color(0xff2FB035),
                                    fontWeight: FontWeight.w600,
                                    height: 19.36 / 18,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
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
                      // Unused Leaves Container
                      Container(
                        padding: EdgeInsets.all(10),
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
                                  (data!.unusedLeaves != null)
                                      ? data?.unusedLeaves.toString() ?? "0"
                                      : "0",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    color: Color(0xffEFA84E),
                                    fontWeight: FontWeight.w600,
                                    height: 19.36 / 18,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      // Pending Leaves Container
                      Container(
                        padding: EdgeInsets.all(10),
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
                                  (data?.pendingLeaves != null)
                                      ? data?.pendingLeaves.toString() ?? "0"
                                      : "0",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    color: Color(0xffEFA84E),
                                    fontWeight: FontWeight.w600,
                                    height: 19.36 / 18,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: w * 0.020),
                      // Rejected Leaves Container
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
                                  (data?.rejectedLeaves != null)
                                      ? data?.rejectedLeaves.toString() ?? "0"
                                      : "0",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    color: Color(0xffDE350B),
                                    fontWeight: FontWeight.w600,
                                    height: 19.36 / 18,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
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
                            ),
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
                          _bottomSheetApplyLeave(context);
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
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 1, 8, 1),
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

  Widget _buildShimmerLeaveRequests(double width) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              shimmerLeaveStatusCard(width * 0.44),
              SizedBox(width: width * 0.020),
              shimmerLeaveStatusCard(width * 0.44),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              shimmerLeaveStatusCard(width * 0.44),
              SizedBox(width: width * 0.020),
              shimmerLeaveStatusCard(width * 0.44),
            ],
          ),
        ),
        const SizedBox(height: 10), // Add some spacing before the list
        // Use Expanded to make the list take remaining space
        Expanded(
          child: ListView.builder(
            itemCount: 2, // Number of shimmer items
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background for shimmer container
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerText(150, 16), // Title shimmer
                      const SizedBox(height: 4),
                      shimmerText(200, 14), // Subtitle shimmer
                      const SizedBox(height: 8),
                      shimmerText(180, 12), // Date and time shimmer
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: shimmerRoundedContainer(
                            80, 28), // Shimmer for trailing button
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget shimmerLeaveStatusCard(double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white, // Placeholder color
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          shimmerRectangle(50), // Shimmer for task name
          const SizedBox(height: 10),
          shimmerText(150, 11), // Shimmer for description
          const SizedBox(height: 10),
          shimmerText(80, 11), // Shimmer for date/time
        ],
      ),
    );
  }

  void _bottomSheetApplyLeave(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.55;
    double w = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: h,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
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
                            _label(text: 'From Date'),
                            SizedBox(height: 4),
                            _buildDateField(
                              _fromController,
                            ),
                            if (_validatefrom.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validatefrom,
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
                            _label(text: 'To Date'),
                            SizedBox(height: 4),
                            _buildDateField(
                              _toController,
                            ),
                            if (_validateto.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateto,
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
                            _label(text: 'Reason'),
                            SizedBox(height: 4),
                            Container(
                              height: h * 0.2,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Color(0xffE8ECFF))),
                              child: TextFormField(
                                cursorColor: Color(0xff8856F4),
                                scrollPadding: const EdgeInsets.only(top: 5),
                                controller: _reasonController,
                                textInputAction: TextInputAction.done,
                                maxLines: 100,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 10, top: 10),
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
                            if (_validateReason.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateReason,
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
                                // Icon(Icons.close, color: Color(0xff8856F4)),
                                // SizedBox(width: 8),
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
                        InkResponse(
                          onTap: () {
                            setState(() {
                              _validatefrom = _fromController.text.isEmpty
                                  ? "Please select a from date"
                                  : "";
                              _validateto = _toController.text.isEmpty
                                  ? "Please select a from date"
                                  : "";
                              _validateReason = _reasonController.text.isEmpty
                                  ? "Please enter a reason"
                                  : "";

                              _isLoading = _validatefrom.isEmpty &&
                                  _validateto.isEmpty &&
                                  _validateReason.isEmpty;

                              if (_isLoading) {
                                LeaveRequests();
                              }
                            });
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
                                // Image.asset(
                                //   'assets/container_correct.png', // Replace with your apply icon path
                                //   width: 16,
                                //   height: 16,
                                // ),
                                // SizedBox(width: 8),
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
          });
        }).whenComplete(() {
      _fromController.text = "";
      _toController.text = "";
      _reasonController.text = "";

      _validatefrom = "";
      _validateto = "";
      _validateReason = "";
    });
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
                  hintText: "Select Date from Date Picker",
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
}
