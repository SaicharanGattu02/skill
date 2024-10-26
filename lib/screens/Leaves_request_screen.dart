import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/Mywidgets.dart';  // Import shimmer package

class Leave extends StatefulWidget {
  const Leave({super.key});

  @override
  State<Leave> createState() => _LeaveState();
}

class _LeaveState extends State<Leave> {
  bool _loading = true;  // Ensure _loading is part of the state class

  @override
  void initState() {
    super.initState();
    // Simulate a delay for loading data
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _loading = true;  // Stop loading after a delay
      });
    });
  }

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
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(
              "assets/Plus square.png",
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
      body: _loading
          ? _buildShimmerLeaveRequests()  // Show shimmer when loading
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              _buildLeaveOverview(w),
              SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('Leaves List',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Handle "Apply Leaves" action
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff8856F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Apply Leaves'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              // List of leave requests
              SizedBox(
                height: 300.0,  // Adjust the height as needed
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F4FC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Maternity Leave'),
                            SizedBox(height: 4),
                            Text(
                              "Friend’s Birth Day Celebration",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        subtitle: const Text(
                            '19 July 2024 - 01:00 PM (4 Hours)'),
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffFEF7EC),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Text('Pending',
                              style: TextStyle(
                                color: Color(0xffEFA84E),
                                backgroundColor: Colors.black12,
                              )),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLeaveRequests() {
    return ListView.builder(
      itemCount: 4, // Number of shimmer items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,  // Background for shimmer container
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerText(150, 16),  // Title shimmer
                  const SizedBox(height: 4),
                  shimmerText(200, 14),  // Subtitle shimmer
                  const SizedBox(height: 8),
                  shimmerText(180, 12),  // Date and time shimmer
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: shimmerRoundedContainer(80, 28),  // Shimmer for trailing button
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper widget for leave overview
  Widget _buildLeaveOverview(double width) {
    return Row(
      children: [
        _buildLeaveCard("Available Leaves", "16", Color(0xff2FB035), width),
        const SizedBox(width: 16),
        _buildLeaveCard("Previous Unused Leaves", "16", Color(0xff8856F4), width),
      ],
    );
  }

  // Reusable widget for leave status cards
  Widget _buildLeaveCard(String title, String count, Color color, double width) {
    return Container(
      width: width * 0.42,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
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
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: Text(
                count,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: width * 0.3,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff290358),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
