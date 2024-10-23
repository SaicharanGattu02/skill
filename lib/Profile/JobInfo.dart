import 'package:flutter/material.dart';

class JobInfo extends StatefulWidget {
  const JobInfo({super.key});

  @override
  State<JobInfo> createState() => _JobInfoState();
}

class _JobInfoState extends State<JobInfo> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xffF3ECFB),
        body: Container(
          width: w,
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(0xffFFFFFF), borderRadius: BorderRadius.circular(7)),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Job Title',
                  style: TextStyle(
                      color: Color(0xff6C848F),
                      fontFamily: 'Inter',
                      fontSize: 16,
                      height: 19.36 / 16,
                      fontWeight: FontWeight.w400)),
              SizedBox(
                height: h * 0.004,
              ),
              Text('UI/UX Designer',
                  style: TextStyle(
                      color: Color(0xff1D1C1D),
                      fontFamily: 'Inter',
                      fontSize: 16,
                      height: 19.36 / 16,
                      fontWeight: FontWeight.w400)),
              SizedBox(
                height: h * 0.02,
              ),
              Text('Date of hire',
                  style: TextStyle(
                      color: Color(0xff6C848F),
                      fontFamily: 'Inter',
                      fontSize: 16,
                      height: 19.36 / 16,
                      fontWeight: FontWeight.w400)),
              SizedBox(
                height: h * 0.004,
              ),
              Text('20-02-2024',
                  style: TextStyle(
                      color: Color(0xff1D1C1D),
                      fontFamily: 'Inter',
                      fontSize: 16,
                      height: 19.36 / 16,
                      fontWeight: FontWeight.w400)),
            ],
          )),
        ));
  }
}
