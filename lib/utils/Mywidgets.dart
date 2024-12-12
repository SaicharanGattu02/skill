import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill/screens/OneToOneChatPage.dart';

import '../ProjectModule/TaskForm.dart';
import '../Providers/ThemeProvider.dart';
import '../Services/UserApi.dart';
import 'CustomSnackBar.dart';
import 'constants.dart';

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
Widget shimmerRoundedContainer(double width, double height) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey[300], // Shimmer placeholder color
      borderRadius: BorderRadius.circular(100), // Rounded edges for button shape
    ),
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
shimmerCircle(double size,BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
  final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;
  return Shimmer.fromColors(
    baseColor:baseColor,
    highlightColor: highlightColor,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    ),
  );
}

Widget shimmerRectangle(double size,BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
  final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;
  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
shimmerContainer(double width, double height,BuildContext context,{bool isButton = false}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
  final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;
  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isButton ? Colors.grey : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: isButton
          ? Center(child: shimmerText(80, 18,context))
          : SizedBox(),
    ),
  );
}

// Shimmer component for text
shimmerText(double width, double height,BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
  final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;
  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Color(0xffE6E8EB), borderRadius: BorderRadius.circular(18)),
    ),
  );
}

// Shimmer component for linear progress bar
shimmerLinearProgress(double height,BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
  final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;
  return Shimmer.fromColors(
    baseColor:baseColor,
    highlightColor:highlightColor,
    child: Container(
      height: height,
      decoration: BoxDecoration(
          color: Color(0xffE6E8EB), borderRadius: BorderRadius.circular(18)),
    ),
  );
}

class RoundedProgressPainter extends CustomPainter {
  final double progress; // Progress value as a fraction (0.0 to 1.0)

  RoundedProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    print("Progress :$progress");

    // Background paint (circle)
    final Paint paintBackground = Paint()
      ..color = Color(0xffE0C6FD) // Light color for background
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    // Foreground paint (arc)
    final Paint paintForeground = Paint()
      ..color = Color(0xff682FA3) // Color for the progress
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;

    // Draw background circle (complete circle)
    canvas.drawCircle(
      Offset(radius, radius),
      radius - paintBackground.strokeWidth / 2,
      paintBackground,
    );

    // Calculate sweep angle for the progress arc
    // Full circle is 2 * PI radians, so multiply the progress by the full circle's radians
    final double sweepAngle = 2 * 3.141592653589793 * (progress / 100);

    // Draw foreground arc (progress arc)
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(radius, radius),
        radius: radius - paintForeground.strokeWidth / 2,
      ),
      -3.141592653589793 / 2, // Start at the top (12 o'clock position)
      sweepAngle, // Arc sweep angle based on progress
      false,
      paintForeground,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever progress changes
  }
}

class MemberCard extends StatefulWidget {
  final String name;
  final String profile_image;
  final String id;

  const MemberCard({
    Key? key,
    required this.name,
    required this.profile_image,
    required this.id,
  }) : super(key: key);

  @override
  _MemberCardState createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {

  Future<void> createRoom(String id) async {
    var res = await Userapi.CreateChatRoomAPi(id);
    setState(() {
      if (res != null && res.settings?.success == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(roomId: res.data?.room ?? "",ID: "",),
          ),
        );
      } else {
        CustomSnackBar.show(context, "${res?.settings?.message}");
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              widget.profile_image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                    color: themeProvider.textColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Image.asset(
              'assets/chat_icon.png',
              width: 16,
              height: 16,
            ),
            onPressed: () {
              createRoom(widget.id);
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
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                            color: themeProvider.textColor)),
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
                        color: Color(0xff6c848f)
                    )),
                
                Text("${desc}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                        color: themeProvider.themeData == lightTheme
                            ?   Color(0xff6c848f)
                            : themeProvider.textColor,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskBottomSheet {
  static void show(BuildContext context,String title,String project_id,String id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TaskForm(title:title ,projectId: project_id,taskid: id,),
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


class TodoPriorities {
  final String priorityValue;
  final String priorityKey;

  TodoPriorities({required this.priorityValue, required this.priorityKey});
}
class MeetingTypess {
  final String meetingtypevalue;


  MeetingTypess({required this.meetingtypevalue,});
}

class HemispherePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xff8856F4)
      ..style = PaintingStyle.fill;

    // Draw the hemisphere
    canvas.drawArc(
      Rect.fromLTWH(10, 0, size.width, size.height),
      0, // Start angle
      3.14, // Sweep angle for a semicircle
      true, // Use center for the arc
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}







