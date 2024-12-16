import 'package:flutter/material.dart';
import 'package:skill/utils/CustomSnackBar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/UserDetailModel.dart';
import '../Services/UserApi.dart';

class UserProfile extends StatefulWidget {
  final String userID;

  const UserProfile({super.key, required this.userID});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool loading = true;
  @override
  void initState() {
    updateProfile();
    super.initState();
  }

  final splinkit = Spinkits();

  Data? data;
  Future<void> updateProfile() async {
    final response = await Userapi.UserDetails(widget.userID);
    if (response != null) {
      setState(() {
        if (response.settings?.success == 1) {
          data = response.data;
          loading = false;
          print("Data:${data?.fullName ?? ""}");
        } else {
          loading = false;
          print(
              "Update failure: ${response.settings?.message ?? 'Unknown error'}");
        }
      });
    } else {
      print("Update failed: No response from server.");
    }
  }

  // Function to send SMS
  Future<void> launchSMS(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not send SMS to $phoneNumber';
    }
  }

  // Function to launch mail
  Future<void> launchEmail(String email,
      {String? subject, String? body}) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri(queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      }).query,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not send email to $email';
    }
  }

// Function to make a phone call
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not call $phoneNumber';
    }
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
        title: Text(
          "User Profile",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: (loading)
          ? Center(
              child: splinkit.getFadingCircleSpinner(color: Color(0xff8856F4)))
          : Container(
              width: w,
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              padding: const EdgeInsets.only(left: 48, right: 48),
              decoration: BoxDecoration(
                color: const Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(data?.image ?? ""),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    data?.fullName ?? "",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24.0,
                      color: Color(0xff290358),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "UX/UI Designer",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      color: Color(0xff6C848F),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      // UX/UI and Contact Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Color(0xFF36B37E).withOpacity(0.1),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/call.png",
                                          fit: BoxFit.contain,
                                          width: 12,
                                          color: Color(0xff36B37E),
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          // Wrap Text with Expanded to avoid overflow
                                          child: Text(
                                            data?.mobile ?? "",
                                            style: TextStyle(
                                              color: Color(0xff36B37E),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                              height: 13.41 / 11,
                                              letterSpacing: 0.14,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: "Inter",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: w * 0.05),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Color(0xff2572ED).withOpacity(0.2),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/gmail.png",
                                          fit: BoxFit.contain,
                                          width: 12,
                                          color: const Color(0xff2572ED),
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          // Wrap Text with Expanded here too
                                          child: Text(
                                            data?.email ?? "",
                                            style: TextStyle(
                                              color: const Color(0xff2572ED),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                              height: 13.41 / 11,
                                              letterSpacing: 0.14,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: "Inter",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    launchSMS(
                                      data?.mobile ?? "",
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/msg.png",
                                        width: 18,
                                        height: 18,
                                        color: Color(0xff8856F4),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Message",
                                        style: TextStyle(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                          height: 13.41 / 11,
                                          letterSpacing: 0.14,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color:
                                          Color(0xff1D1C1D).withOpacity(0.2)),
                                ),
                                InkWell(
                                  onTap: () {
                                    makePhoneCall(
                                      data?.mobile ?? "",
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/call.png",
                                        width: 18,
                                        height: 18,
                                        color: Color(0xff8856F4),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Call",
                                        style: TextStyle(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                          height: 13.41 / 11,
                                          letterSpacing: 0.14,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color:
                                          Color(0xff1D1C1D).withOpacity(0.2)),
                                ),
                                InkWell(
                                  onTap: () {
                                    launchEmail(
                                      data?.email ?? "",
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/gmail.png",
                                        width: 18,
                                        height: 18,
                                        color: Color(0xff8856F4),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Mail",
                                        style: TextStyle(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                          height: 13.41 / 11,
                                          letterSpacing: 0.14,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Divider(
                              height: 1,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),

                      // Performance Container
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
