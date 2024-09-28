import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class projectStatus extends StatelessWidget {
  late final double percentage; // To pass the percentage dynamically
  late final Color progressColor; // To pass the color dynamically
  late final String taskDetail; // To pass task details dynamically

  // Constructor to initialize variables
  projectStatus({
    required this.percentage,
    required this.progressColor,
    required this.taskDetail,
  });

  final gradientList = <List<Color>>[
      [
        Color.fromRGBO(223, 250, 92, 1), // Gradient from yellow to green
        Color.fromRGBO(129, 250, 112, 1),
      ],
      [
        Color.fromRGBO(129, 182, 205, 1), // Gradient from blue to cyan
        Color.fromRGBO(91, 253, 199, 1),
      ],
      [
        Color.fromRGBO(175, 63, 62, 1.0), // Gradient from red to orange
        Color.fromRGBO(254, 154, 92, 1),
      ],
    ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text('App Title'),
          backgroundColor: Color(0xff8856F4),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back button press
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Handle add button press
              },
            )
          ],
        ),
        body: Column(
          children: [
            // Tabs inside a Card with rounded corners
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TabBar(
                  isScrollable: true,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: "Overview"),
                    Tab(text: "Task List"),
                    Tab(text: "Task Kaban"),
                    Tab(text: "Milestones"),
                    Tab(text: "Notes"),
                    Tab(text: "Files"),
                    Tab(text: "Time"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    // Big Circle Progress Bar 1 with Percentage Inside
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Stack to place the percentage inside the circle
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: CircularProgressIndicator(
                                    value: 0.7, // 70% filled
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xff8856F4),
                                    ),
                                    strokeWidth: 15, // Thicker stroke for bigger circle
                                  ),
                                ),
                                // Text at the center of the circle
                                Text(
                                  '70%',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            // Details next to the big circle progress
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chat Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text('Additional information about chat goes here...'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 350,
                          height: 150,
                          child: PieChart(
                            dataMap: {
                              "Progress": percentage,
                              "Remaining": 100 - percentage,
                            },
                            animationDuration: Duration(milliseconds: 800),
                            chartType: ChartType.ring, // Circular ring-style chart
                            ringStrokeWidth: 15,
                            gradientList: gradientList, // Apply gradient to the chart
                            emptyColorGradient: [
                              Color(0xff6c5ce7), // Gradient for remaining empty part
                              Colors.blue,
                            ],
                            chartValuesOptions: ChartValuesOptions(
                              showChartValuesOutside: true, // Show values outside the chart
                              showChartValuesInPercentage: true, // Display values as percentages
                              decimalPlaces: 1,
                            ),
                            totalValue: 100, // Total value for the chart
                          ),
                        ),
                        // Display the percentage in the center

                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
