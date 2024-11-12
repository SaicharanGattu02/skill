import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skill/Model/NotificationModel.dart';  // Import your Notification model
import '../Helpers/DatabaseHelper.dart';  // Import your database helper
import '../utils/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<NotificationModel>> _notifications;

  @override
  void initState() {
    super.initState();
    // Fetch notifications when the screen is first loaded
    setState(() {
      _notifications = fetchNotifications();
      print("Notifications:${_notifications}");
    });
  }

  // Fetch notifications from SQLite database
  Future<List<NotificationModel>> fetchNotifications() async {
    return await DatabaseHelper.instance.getNotifications();
  }

  // Handle the deletion of a notification
  Future<void> deleteNotification(int id) async {
    await DatabaseHelper.instance.deleteNotification(id);
    // After deleting, fetch the updated list of notifications
    setState(() {
      _notifications = fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
          ),
        ),
        title: Text(
          "Notifications",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
            height: 29.05 / 24.0,
          ),
        ),
        actions: [Container()],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<List<NotificationModel>>(
          future: _notifications,  // The future to wait for
          builder: (context, snapshot) {
            // Show loading spinner if data is not loaded yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Color(0xff8856F4)));
            }

            // If there's an error loading the data
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // If no notifications were found
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    color: Color(0xff6C848F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            // If notifications are available, display them
            final notifications = snapshot.data!;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/notification-bell.png",  // Use the icon from the model
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title ?? '',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w500,
                                height: 18.15 / 15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              notification.body ?? '',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(0xff6C848F),
                                fontWeight: FontWeight.w400,
                                height: 16.09 / 14,
                              ),
                            ),
                            // SizedBox(height: 5),
                            // Text(
                            //   notification.data ?? '',
                            //   style: TextStyle(
                            //     fontFamily: 'Inter',
                            //     fontSize: 12,
                            //     color: Color(0xff6C848F),
                            //     fontWeight: FontWeight.w400,
                            //     height: 14 / 12,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          // Call the delete method when the cross icon is tapped
                          deleteNotification(notification.id!);
                        },
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Color(0xffE5E5E5),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            "assets/cross.png",
                            color: Color(0xff6A2FA5),
                            width: 10,
                            height: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
