import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Leave extends StatefulWidget {
  const Leave({super.key});

  @override
  State<Leave> createState() => _LeaveState();
}

class _LeaveState extends State<Leave> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: AppBar(
        backgroundColor: const Color(0xff8856F4),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
          ),
        ),
        title: const Text(
          "Apply Leave",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
            height: 29.05 / 24.0,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Image.asset(
              "assets/Plus square.png",
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                height: 16,
              ),

              Row(
                children: [
                  Container(
                    width: w * 0.42,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff2FB0351A).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff).withOpacity(0.50),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                              child: Text(
                            "16",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              color: Color(0xff2FB035),
                              fontWeight: FontWeight.w700,
                              height: 38.4 / 24,
                              letterSpacing: 0.14,
                            ),
                          )),
                        ),
                        Text(
                          "Available Leaves",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            color: Color(0xff290358),
                            fontWeight: FontWeight.w600,
                            height: 34.2 / 20,
                            letterSpacing: 0.14,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: w*0.030),
                  Container(
                    width: w * 0.42,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff2FB0351A).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff).withOpacity(0.50),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                              child: Text(
                                "16",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 24,
                                  color: Color(0xff2FB035),
                                  fontWeight: FontWeight.w700,
                                  height: 38.4 / 24,
                                  letterSpacing: 0.14,
                                ),
                              )),
                        ),
                        Text(
                          "Available Leaves",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            color: Color(0xff290358),
                            fontWeight: FontWeight.w600,
                            height: 34.2 / 20,
                            letterSpacing: 0.14,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Container(
                    width: w * 0.42,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff2FB0351A).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff).withOpacity(0.50),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                              child: Text(
                                "16",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 24,
                                  color: Color(0xff2FB035),
                                  fontWeight: FontWeight.w700,
                                  height: 38.4 / 24,
                                  letterSpacing: 0.14,
                                ),
                              )),
                        ),
                        Text(
                          "Available Leaves",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            color: Color(0xff290358),
                            fontWeight: FontWeight.w600,
                            height: 34.2 / 20,
                            letterSpacing: 0.14,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: w*0.030),
                  Container(
                    width: w * 0.42,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff2FB0351A).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff).withOpacity(0.50),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                              child: Text(
                                "16",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 24,
                                  color: Color(0xff2FB035),
                                  fontWeight: FontWeight.w700,
                                  height: 38.4 / 24,
                                  letterSpacing: 0.14,
                                ),
                              )),
                        ),
                        Text(
                          "Available Leaves",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            color: Color(0xff290358),
                            fontWeight: FontWeight.w600,
                            height: 34.2 / 20,
                            letterSpacing: 0.14,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),


              Row(
                children: [
                  Text('Leaves List',
                      style:
                          TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle "Apply Leaves" action
                      },
                      child: Text('Apply Leaves'),
                    ),
                  ),

                ],
              ),

              SizedBox(height: 16.0),

              // Wrapping ListView.builder in a SizedBox to manage height
              SizedBox(
                height:
                    300.0, // Set an appropriate height based on the list size
                child: ListView.builder(
                  itemCount: 4, // Replace with actual number of leave requests
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text('Maternity Leave'),
                        subtitle: Text('19 July 2024 - 01:00 PM (4 Hours)'),
                        trailing: Chip(label: Text('Pending')),
                      ),
                    );
                  },
                ),
              ),

              // Add space between list and the button
              SizedBox(height: 16.0),

              // Centered "Apply Leaves" button

            ],
          ),
        ),
      ),
    );
  }
}
