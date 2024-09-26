import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final List<Map<String, dynamic>> tasks = [
    {
      'date': 'March 6, 2024',
      'app': 'Mobile App',
      'name': 'Bharath Gupta',
      'percentage': 30, // Ensure this is a valid percentage
    },
  ];

  final List<String> _images = [
    'https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
    'https://images.unsplash.com/photo-1612594305265-86300a9a5b5b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1612626256634-991e6e977fc1?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1712&q=80',
    'https://images.unsplash.com/photo-1593642702749-b7d2a804fbcf?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1593642702749-b7d2a804fbcf?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1593642702749-b7d2a804fbcf?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1593642702749-b7d2a804fbcf?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80'
  ];

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
          "Task List",
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
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                  const Text(
                    "Search",
                    style: TextStyle(
                      color: Color(0xff9E7BCA),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      fontFamily: "Nunito",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true, // Use shrinkWrap to avoid size constraints
              physics: NeverScrollableScrollPhysics(), // Disable scrolling
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                // Safely access values with null checks
                final date = task['date'] ?? "Unknown Date";
                final app = task['app'] ?? "Unknown App";
                final name = task['name'] ?? "Unknown Name";
                final percentage = task['percentage'] ?? 0; // Default to 0 if null

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            date,
                            style: const TextStyle(
                              color: Color(0xffD9D9D9),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              height: 19.41 / 12,
                              letterSpacing: 0.14,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: "Inter",
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                            "assets/edit.png",
                            fit: BoxFit.contain,
                            width: w * 0.040,
                            height: w * 0.04,
                            color: const Color(0xff8856F4),
                          ),
                          SizedBox(width: w * 0.020),
                          Container(
                            width: w * 0.04,
                            height: w * 0.04,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color(0xff8856F4),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/crossblue.png",
                                fit: BoxFit.contain,
                                width: 5,
                                height: 5,
                                color: const Color(0xff8856F4),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "ID : 322",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff371F41),
                          height: 19.36 / 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        app,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 19.36 / 18,
                          color: Color(0xff27104E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              "assets/prashanth.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 19.36 / 12,
                              color: Color(0xff371F41),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.05),
                      LinearProgressIndicator(
                        value: percentage / 100.0, // Converting percentage to a fraction (0.30 for 30%)
                        minHeight: 7,
                        backgroundColor: const Color(0xffE0E0E0),
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xff2FB035),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Progress ",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff64748B),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${percentage}%", // Display percentage with % sign
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        thickness: 1,
                        color: const Color(0xff94A3B8).withOpacity(0.3),
                      ),
                      SizedBox(height: 16),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlutterImageStack(
                            imageList: _images,
                            totalCount: _images.length,
                            showTotalCount: true,
                            extraCountTextStyle:TextStyle(  fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1.21,
                              ) ,

                            itemBorderWidth: 1,
                            itemRadius: 20,
                            itemCount: 3,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 1, bottom: 1),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(0x19DE350B)),
                            child: Text("10-12-2024",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  height: 14.52 / 10,
                                  color: Color(0xffDE350B)

                              ),),
                          )
                        ],
                      ),

                    ],
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
