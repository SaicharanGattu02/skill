import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../ProjectModule/TaskForm.dart';

FadeShimmer_circle(size) {
  return Container(
    margin: EdgeInsets.all(2),
    decoration: new BoxDecoration(
      color: Color(0xffE6E8EB),
      shape: BoxShape.circle,
    ),
    height: size,
    width: size,
  );
}

FadeShimmer_box(height, width, radius) {
  return Container(
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Color(0xffE6E8EB), borderRadius: BorderRadius.circular(radius)),
    height: height,
    width: width,
  );
}

FadeShimmer_box_elite(height, width, radius) {
  return Container(
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Color(0xFF3D3D3D), borderRadius: BorderRadius.circular(radius)),
    height: height,
    width: width,
  );
}

FadeShimmer_box_porter(height, width, radius) {
  return Container(
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Color(0xFF959595), borderRadius: BorderRadius.circular(radius)),
    height: height,
    width: width,
  );
}

// Shimmer component for a circular image
shimmerCircle(double size) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
    ),
  );
}

// Shimmer component for text
shimmerText(double width, double height) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Color(0xffE6E8EB), borderRadius: BorderRadius.circular(18)),
    ),
  );
}

// Shimmer component for linear progress bar
shimmerLinearProgress(double height) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: height,
      decoration: BoxDecoration(
          color: Color(0xffE6E8EB), borderRadius: BorderRadius.circular(18)),
    ),
  );
}

class RoundedProgressPainter extends CustomPainter {
  final double progress;

  RoundedProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    print("Progress :${progress}");
    final Paint paintBackground = Paint()
      ..color = Color(0xffE0C6FD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final Paint paintForeground = Paint()
      ..color = Color(0xff682FA3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;

    // Draw background circle
    canvas.drawCircle(
      Offset(radius, radius),
      radius - paintBackground.strokeWidth / 2,
      paintBackground,
    );

    // Draw foreground arc
    final double sweepAngle = 2 * 3.141592653589793 * progress; // Full circle in radians
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(radius, radius),
        radius: radius - paintForeground.strokeWidth / 2,
      ),
      -3.141592653589793 / 2, // Start angle (top)
      sweepAngle,
      false,
      paintForeground,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint when progress changes
  }
}

class MemberCard extends StatelessWidget {
  final String name;
  final String profile_image;

  const MemberCard({Key? key, required this.name, required this.profile_image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          ClipOval(
              child: Image.network(
            profile_image,
            width: 60,
            height: 60,
          )
              // Text(
              //   name[0],
              //   style: TextStyle(color: Colors.white, fontSize: 24),
              // ),
              ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                        color: Colors.black)),
                // Text(profession,
                //     style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w400,
                //         fontFamily: "Inter",
                //         color: Color(0xff6c848f))),
              ],
            ),
          ),
          IconButton(
            icon: Image.asset(
              'assets/delete_icon.png',
              width: 16,
              height: 16,
            ),
            onPressed: () {
              // Handle delete action
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/chat_icon.png',
              width: 16,
              height:
                  16, // Make sure to use the correct path to your image asset
            ),
            onPressed: () {
              // Handle message action
            },
          ),
        ],
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String name;
  final String user_img;
  final String time;
  final String action;
  final String desc;
  final String project_name;

  const ActivityCard({
    Key? key,
    required this.name,
    required this.user_img,
    required this.time,
    required this.action,
    required this.desc,
    required this.project_name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, // Set the desired width for your rectangle
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18)
            ),// Set the desired height for your rectangle
            child: ClipOval(
              child: Image(
                image: NetworkImage(user_img),
                fit: BoxFit.cover, // Adjust how the image fits in the rectangle
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Inter",
                            color: Colors.black)),
                    SizedBox(
                      width: 10,
                    ),

                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xff2fb035),
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Text(
                        action,
                        style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                Text(time,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                        color: Color(0xff6c848f))),
                
                Text("${desc}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                        color: Color(0xff6c848f))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskBottomSheet {
  static void show(BuildContext context,String project_id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TaskForm(projectId: project_id),
        );
      },
    );
  }
}



class DateTimeFormatter {
  // Method to format both date and time based on user choice
  static String format(String isoDate, {bool includeDate = true, bool includeTime = false}) {
    if (isoDate.isEmpty) {
      return "";
    }

    try {
      // Remove AM/PM if present to avoid parsing issues
      String cleanedDate = isoDate.replaceAll(RegExp(r'(AM|PM)'), '').trim();

      // Parse the date
      DateTime dateTime = DateTime.parse(cleanedDate);

      // Format the date and time as needed
      String formattedDate = "";
      if (includeDate) {
        formattedDate = "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
      }

      String formattedTime = "";
      if (includeTime) {
        formattedTime = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      }

      // Combine date and time if both are requested
      if (includeDate && includeTime) {
        return "$formattedDate $formattedTime";
      } else if (includeDate) {
        return formattedDate;
      } else if (includeTime) {
        return formattedTime;
      }
    } catch (e) {
      print("Error parsing date: $e");
      return "";
    }

    return "";
  }
}


class Priorities {
  final String priorityValue;
  final String priorityKey;

  Priorities({required this.priorityValue, required this.priorityKey});
}


