import 'package:flutter/material.dart';

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
                    // Big Circle Progress Bar 2 with Percentage Inside
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
                                    value: percentage / 100, // Convert percentage to 0-1 range
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      progressColor,
                                    ),
                                    strokeWidth: 15, // Thicker stroke for bigger circle
                                  ),
                                ),
                                // Text at the center of the circle
                                Text(
                                  '${percentage.toInt()}%', // Display percentage as integer
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
                                    'Task Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(taskDetail),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
