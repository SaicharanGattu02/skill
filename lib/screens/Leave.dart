import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skill/Services/UserApi.dart';
import 'package:skill/utils/CustomAppBar.dart';

import '../Model/GetLeaveCountModel.dart';
import '../Model/GetLeaveModel.dart';


class Leave extends StatefulWidget {
  const Leave({super.key});

  @override
  State<Leave> createState() => _LeaveState();
}

class _LeaveState extends State<Leave> {
  bool _loading =true;
  @override
  void initState() {
    super.initState();
    getleaves();
    getleavesCount();
  }

  List<Data>? leaves;
  Future<void> getleaves() async {
    var Res = await Userapi.GetLeave();
    setState(() {

      if (Res != null) {
        _loading=false;
        if (Res.data != null) {
          leaves = Res.data ?? [];
        } else {
          print("GetLeave Failure>>${Res.message}");
        }
      }
    });
  }
  Count data= Count();
  Future<void> getleavesCount() async {
    var Res = await Userapi.GetLeaveCount();
    setState(() {
      if (Res != null) {
        if (Res.data != null) {
          _loading=false;
          data=Res.data!;
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
      body:
      _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                                data?.availableLeaves.toString()??"N/A",
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
                            data?.unusedLeaves.toString()??"N/A",
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
                            data?.rejectedLeaves.toString()??"N/A",
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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
                ],
              ),
              SizedBox(height: 12),
              ListView.builder(
                itemCount: leaves?.length ?? 0,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling for ListView
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
                                padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                decoration: BoxDecoration(
                                  color: const Color(0x1A13925D),
                                  borderRadius: BorderRadius.circular(100),
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
                                "From: ${leave?.fromDate.toString()??""}",
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
            ],
          ),
        ),
      ),
    );
  }
}
