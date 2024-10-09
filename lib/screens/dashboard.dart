import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skill/Services/UserApi.dart';
import 'package:skill/screens/AllChannels.dart';
import 'package:skill/screens/Leave.dart';
import 'package:skill/screens/LogInScreen.dart';
import 'package:skill/screens/Meetings.dart';
import 'package:skill/screens/Messages.dart';
import 'package:skill/screens/Notifications.dart';
import 'package:skill/ProjectModule/Projects.dart';
import 'package:skill/screens/Task.dart';
import 'package:skill/screens/ToDoList.dart';
import 'package:skill/utils/CustomSnackBar.dart';
import 'package:skill/utils/Preferances.dart';
import 'package:web_socket_channel/io.dart';
import '../Chatbubbledemo.dart';
import '../Model/EmployeeListModel.dart';
import '../Model/ProjectsModel.dart';
import '../Model/RoomsModel.dart';
import '../ProjectModule/TabBar.dart';
import '../ProjectModule/UserDetailsModel.dart';
import 'GeneralInfo.dart';
import 'OneToOneChatPage.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late IOWebSocketChannel _socket;
  late GoogleMapController mapController;
  final List<Map<String, String>> items1 = [
    {'image': 'assets/ray.png', 'text': 'Raay App', 'value': '0.35'},
    {'image': 'assets/payjet.png', 'text': 'Payjet App', 'value': '0.85'},
    {'image': 'assets/ray.png', 'text': 'Raay App', 'value': '0.35'},
    {'image': 'assets/payjet.png', 'text': 'Payjet App', 'value': '0.85'},
    {'image': 'assets/ray.png', 'text': 'Raay App', 'value': '0.35'},
    {'image': 'assets/payjet.png', 'text': 'Payjet App', 'value': '0.85'},
    {'image': 'assets/ray.png', 'text': 'Raay App', 'value': '0.35'},
    {'image': 'assets/payjet.png', 'text': 'Payjet App', 'value': '0.85'},
  ];

  final List<Map<String, String>> items=[
    {'image': 'assets/pixl.png', 'text': '# Pixl Team'},
    {'image': 'assets/hrteam.png', 'text': '# Designers'},
    {'image': 'assets/pixl.png', 'text': '# UIUX'},
    {'image': 'assets/designers.png', 'text': '# Hr Team'},
    {'image': 'assets/pixl.png', 'text': '# BDE Team'},
    {'image': 'assets/developer.png', 'text': '# Developers'},
    {'image': 'assets/pixl.png', 'text': '# Pixl Team'},
    {'image': 'assets/hrteam.png', 'text': '# Designers'},
    {'image': 'assets/pixl.png', 'text': '# UIUX'},
    {'image': 'assets/designers.png', 'text': '# Hr Team'},
    {'image': 'assets/pixl.png', 'text': '# BDE Team'},
  ];
  bool _isLoading = true;
  String userid = "";
  List<Rooms> rooms = [];
  String selectedEmployee = "";
  final spinkit = Spinkits();

  @override
  void initState() {
    // GetEmployeeData();
    _requestLocationPermission();
    GetUserDeatails();
    GetRoomsList();
    GetProjectsData();
    super.initState();
  }

  bool _isConnected = false;
  void _initializeWebSocket(String userid) {
    print('Attempting to connect to WebSocket...');
    _socket = IOWebSocketChannel.connect(
        Uri.parse("wss://stage.skil.in/ws/notify/${userid}"));
    print('Connected to WebSocket at: wss://stage.skil.in/ws/notify/${userid}');
    setState(() {
      _isConnected = true;
    });

    _socket.stream.listen(
      (message) {
        print('Message received: $message');
        try {
          final decodedMessage = jsonDecode(message);
          print('Decoded message: $decodedMessage');
          final decryptedMessage = decodedMessage['data']['message'];
          // Update rooms
          setState(() {
            updateRooms(decodedMessage, decryptedMessage);
          });
        } catch (e) {
          print('Error processing message: $e');
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        setState(() {
          _isConnected = false;
        });
      },
      onDone: () {
        print('WebSocket connection closed. Trying to reconnect...');
        setState(() {
          _isConnected = false;
        });
        _reconnectWebSocket();
      },
    );
  }

  List<Data> projectsData = [];
  Future<void> GetProjectsData() async {
    var Res = await Userapi.GetProjectsList();
    setState(() {
      if (Res != null && Res.data != null) {
        _loading = false;
        projectsData = Res.data ?? [];
      } else {
        // Handle failure case here
      }
    });
  }

  Future<void> createRoom(String id) async {
    var res = await Userapi.CreateChatRoomAPi(id);
    if (res != null && res.settings?.success == 1) {
      GetRoomsList();
      CustomSnackBar.show(context, "${res.settings?.message}");
    } else {
      CustomSnackBar.show(context, "${res?.settings?.message}");
    }
  }

  void updateRooms(Map<String, dynamic> newMessage, String decryptedMessage) {
    final roomId = newMessage['data']['room_id'];
    final sentUser = newMessage['data']['sent_user'];
    final messageTime = newMessage['data']['message_time'];

    // Check if room exists
    final roomIndex = rooms.indexWhere((room) => room.roomId == roomId);

    if (roomIndex != -1) {
      // Update existing room
      rooms[roomIndex]
        ..message = decryptedMessage
        ..sentUser = sentUser
        ..messageTime = messageTime;

      // Increment the message count
      if(sentUser!=userid){
        rooms[roomIndex].messageCount++;
      }
    } else {
      // Add new room with message count initialized to 1
      rooms.add(Rooms(
        roomId: roomId,
        otherUserId: sentUser, // Replace with actual other user ID
        message: decryptedMessage,
        messageTime: messageTime,
        messageCount: 1, // Initialize count to 1 for new room
      ));
    }

    // Sort rooms by messageTime and update state
    rooms.sort((a, b) => (b.messageTime ?? 0).compareTo(a.messageTime ?? 0));
  }

  void _reconnectWebSocket() {
    Future.delayed(Duration(seconds: 5), () {
      print('Reconnecting to WebSocket...');
      _initializeWebSocket(userid);
    });
  }

  Future<void> GetRoomsList() async {
    var res = await Userapi.getrommsApi();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          rooms = res.data ?? [];
          rooms.sort(
              (a, b) => (b.messageTime ?? 0).compareTo(a.messageTime ?? 0));
        } else {}
      }
    });
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      // Handle the case when the user denies the permission
      // Optionally, show a dialog or a snackbar
    } else {
      // Permission granted, you can proceed
      setState(() {});
    }
  }

  // Future<void> GetEmployeeData() async {
  //   var Res = await Userapi.GetEmployeeList();
  //   setState(() {
  //     if (Res != null) {
  //       if (Res.data != null) {
  //         employeeData = Res.data;
  //
  //         print("Employee List Get Succesfully  ${Res.settings?.message}");
  //       } else {
  //         print("Employee List Failure  ${Res.settings?.message}");
  //       }
  //     }
  //   });
  // }

  List<Employeedata> employeeData = [];
  Future<void> GetSerachUsersdata(String text) async {
    var Res = await Userapi.GetSearchUsers(text);
    setState(() {
      if (Res != null) {
        if (Res.data != null) {
          employeeData = Res.data ?? [];
          print("Employee List Get Succesfully  ${Res.settings?.message}");
        } else {
          employeeData = [];
          print("Employee List Failure  ${Res.settings?.message}");
        }
      }
    });
  }

  UserData? userdata;
  Future<void> GetUserDeatails() async {
    var Res = await Userapi.GetUserdetails();
    setState(() {
      if (Res != null) {
        if (Res.settings?.success == 1) {
          _isLoading = false;
          userdata = Res.data;
          userid = Res.data?.id ?? "";
          _initializeWebSocket(userdata?.id ?? "");
          PreferenceService().saveString("user_id", userdata?.id ?? "");
        } else {
          _isLoading = false;
        }
      }
    });
  }

  Future<void> _refreshItems() async {
    await Future.delayed(Duration(seconds: 2));
    // GetEmployeeData();
    GetUserDeatails();
    GetRoomsList();
    GetProjectsData();
    setState(() {
      employeeData = [];
      _loading=true;
    });
  }

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xffF3ECFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null, // Hides the leading icon (for drawer)
        actions: <Widget>[Container()],
        toolbarHeight: 58,
        backgroundColor: const Color(0xff8856F4),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              InkResponse(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Image.asset(
                  "assets/menu.png",
                  width: 24,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              Image.asset(
                "assets/skillLogo.png",
                width: 80,
                height: 35,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Notifications()));
                    },
                    child: Container(
                      width:
                          48, // Increase this size to make the area more tappable
                      height:
                          48, // Increase this size to make the area more tappable
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/notify.png",
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    child: Container(
                      width:
                          48, // Increase this size to make the area more tappable
                      height:
                          48, // Increase this size to make the area more tappable
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/dashboard.png",
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
              color: Color(0xff8856F4),
            ))
          : RefreshIndicator(
              color: Color(0xff9E7BCA),
              backgroundColor: Colors.white,
              displacement: 50,
              onRefresh: _refreshItems,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 8),
                  child: Column(
                    children: [
                      // Search Container
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/search.png",
                              width: 24,
                              height: 24,
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
                        height: w * 0.03,
                      ),
                      // User Info Container
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color(0xff8856F4),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Center(
                                    child: Image.network(
                                      userdata?.image ?? "",
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // User Info and Performance
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 4,
                                            right: 4,
                                            top: 2,
                                            bottom: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Skil ID - 02",
                                              style: TextStyle(
                                                  color: Color(0xff8856F4),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10,
                                                  height: 12.1 / 10,
                                                  letterSpacing: 0.14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: "Nunito"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              userdata?.fullName ?? "",
                                              style: const TextStyle(
                                                  color: Color(0xffFFFFFF),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: "Inter"),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff2FB035),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: const Text(
                                              "Active",
                                              style: TextStyle(
                                                  color: Color(0xffFFFFFF),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  height: 16.36 / 12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: "Nunito"),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Image.asset(
                                            "assets/edit.png",
                                            width: 18,
                                            height: 18,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // UX/UI and Performance in a Row
                                      Row(
                                        children: [
                                          // UX/UI and Contact Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "UX/UI Designer at PIXL Since 2024",
                                                  style: TextStyle(
                                                      color: const Color(
                                                              0xffFFFFFF)
                                                          .withOpacity(0.7),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      height: 16.21 / 12,
                                                      letterSpacing: 0.14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontFamily: "Inter"),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4,
                                                                vertical: 3),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color:
                                                              Color(0xffFFFFFF)
                                                                  .withOpacity(
                                                                      0.25),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/call.png",
                                                              fit: BoxFit
                                                                  .contain,
                                                              width: 12,
                                                              color: Color(
                                                                  0xffffffff),
                                                            ),
                                                            SizedBox(width: 4),
                                                            Expanded(
                                                              // Wrap Text with Expanded to avoid overflow
                                                              child: Text(
                                                                userdata?.mobile ??
                                                                    "",
                                                                style:
                                                                    TextStyle(
                                                                  color: const Color(
                                                                      0xffFFFFFF),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 11,
                                                                  height:
                                                                      13.41 /
                                                                          11,
                                                                  letterSpacing:
                                                                      0.14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontFamily:
                                                                      "Inter",
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: w * 0.015),
                                                    Expanded(
                                                      // Use Expanded for the second container as well
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4,
                                                                vertical: 3),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color:
                                                              Color(0xffFFFFFF)
                                                                  .withOpacity(
                                                                      0.25),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/gmail.png",
                                                              fit: BoxFit
                                                                  .contain,
                                                              width: 12,
                                                              color: Color(
                                                                  0xffffffff),
                                                            ),
                                                            SizedBox(width: 4),
                                                            Expanded(
                                                              // Wrap Text with Expanded here too
                                                              child: Text(
                                                                userdata?.email ??
                                                                    "",
                                                                style:
                                                                    TextStyle(
                                                                  color: const Color(
                                                                      0xffFFFFFF),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 11,
                                                                  height:
                                                                      13.41 /
                                                                          11,
                                                                  letterSpacing:
                                                                      0.14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontFamily:
                                                                      "Inter",
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          // Performance Container
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: w * 0.04,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Projects",
                            style: TextStyle(
                                color: Color(0xff16192C),
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                height: 24.48 / 18,
                                fontFamily: "Inter"),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProjectsScreen()));
                            },
                            child: Text(
                              "See all",
                              style: TextStyle(
                                  color: Color(0xff8856F4),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  height: 16.94 / 14,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xff8856F4),
                                  fontFamily: "Inter"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: w * 0.02,
                      ),
                      if (projectsData.length > 0) ...[
                        SizedBox(
                          height: w * 0.78,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: projectsData.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // Two items per row
                                    childAspectRatio:
                                        0.8, // Adjust this ratio to fit your design
                                    mainAxisSpacing: 2,
                                    crossAxisSpacing:
                                        10 // Space between items horizontally
                                    ),
                            itemBuilder: (context, index) {
                              var data = projectsData[index];
                              return InkResponse(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyTabBar(
                                                titile: '${data.name ?? ""}',
                                                id: '${data.id}',
                                              )));
                                  print('idd>>${data.id}');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        top: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF7F4FC),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Center Image
                                        Image.network(
                                          data.icon ?? "",
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 8),
                                        // Bottom Text
                                        Text(
                                          data.name ?? "",
                                          style: const TextStyle(
                                              color: Color(0xff4F3A84),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              height: 19.36 / 16,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: "Nunito"),
                                        ),
                                        const SizedBox(height: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Progress",
                                                  style: TextStyle(
                                                      color: Color(0xff000000),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      height: 14.52 / 12,
                                                      fontFamily: "Inter"),
                                                ),
                                                Text(
                                                  "${data.totalPercent ?? ""}%",
                                                  style: TextStyle(
                                                      color: Color(0xff000000),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      fontFamily: "Inter"),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            LinearProgressIndicator(
                                              value: (data.totalPercent
                                                          ?.toDouble() ??
                                                      0) /
                                                  100.0,
                                              minHeight: 7,
                                              backgroundColor:
                                                  const Color(0xffE0E0E0),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: const Color(0xff2FB035),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          height: w * 0.78,
                          child: Center(
                            child: Text("No projects are assigned.",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      ],
                      // SizedBox(
                      //   height: w * 0.04,
                      // ),
                      // Row(
                      //   children: [
                      //     const Text(
                      //       "Channels",
                      //       style: TextStyle(
                      //           color: Color(0xff16192C),
                      //           fontWeight: FontWeight.w500,
                      //           fontSize: 18,
                      //           fontFamily: "Inter"),
                      //     ),
                      //     Spacer(),
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => Allchannels()));
                      //       },
                      //       child: Text(
                      //         "See all",
                      //         style: TextStyle(
                      //             color: Color(0xff8856F4),
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: 14,
                      //             decoration: TextDecoration.underline,
                      //             decorationColor: Color(0xff8856F4),
                      //             fontFamily: "Inter"),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      //
                      // SizedBox(
                      //   height: w * 0.02,
                      // ),
                      // SizedBox(
                      //   height: w * 0.3,
                      //   child: GridView.builder(
                      //     scrollDirection:
                      //         Axis.horizontal, // Changed to vertical to display in rows
                      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //       crossAxisCount: 2,
                      //       crossAxisSpacing: 10,
                      //       mainAxisSpacing: 2,
                      //       childAspectRatio:
                      //           0.28, // Adjust this ratio to fit your design
                      //     ),
                      //     itemCount: items.length,
                      //     itemBuilder: (context, index) {
                      //       return Padding(
                      //         padding: const EdgeInsets.only(right: 8),
                      //         child: Container(
                      //           padding: const EdgeInsets.all(10),
                      //           decoration: BoxDecoration(
                      //             color: const Color(0xffF7F4FC),
                      //             borderRadius: BorderRadius.circular(8),
                      //           ),
                      //           child: Row(
                      //             children: [
                      //               // Center Image
                      //               Image.asset(
                      //                 items[index]['image']!,
                      //                 width: 32,
                      //                 height: 32,
                      //                 fit: BoxFit.contain,
                      //               ),
                      //               const SizedBox(width: 8),
                      //               // Bottom Text
                      //               Text(
                      //                 items[index]['text']!,
                      //                 style: const TextStyle(
                      //                   color: Color(0xff27272E),
                      //                   fontWeight: FontWeight.w600,
                      //                   fontSize: 13,
                      //                   height: 16.94 / 14,
                      //                   overflow: TextOverflow.ellipsis,
                      //                   fontFamily: "Inter",
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      //
                      SizedBox(
                        height: w * 0.05,
                      ),

                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProjectsScreen()));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: w * 0.16,
                                        height: w * 0.115,
                                        padding: EdgeInsets.only(
                                            left: 3,
                                            right: 3,
                                            top: 2,
                                            bottom: 2),
                                        decoration: BoxDecoration(
                                            color: Color(0x1A8856F4),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Center(
                                          child: Text(
                                            userdata?.projectCount.toString() ??
                                                "",
                                            style: TextStyle(
                                                color: Color(0xff000000),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Sarabun"),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "PROJECTS",
                                        style: TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Inter"),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: w * 0.03,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Todolist()));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: w * 0.16,
                                        height: w * 0.115,
                                        padding: EdgeInsets.only(
                                            left: 3,
                                            right: 3,
                                            top: 2,
                                            bottom: 2),
                                        decoration: BoxDecoration(
                                            color: Color(0xffF1FFF3),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Center(
                                          child: Text(
                                            userdata?.todoCount.toString() ??
                                                "",
                                            style: TextStyle(
                                                color: Color(0xff000000),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Sarabun"),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "TO DO",
                                        style: TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Inter"),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Task()));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: w * 0.16,
                                        height: w * 0.115,
                                        padding: EdgeInsets.only(
                                            left: 3,
                                            right: 3,
                                            top: 2,
                                            bottom: 2),
                                        decoration: BoxDecoration(
                                            color: Color(0x1AFBBC04),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Center(
                                          child: Text(
                                            userdata?.tasksCount.toString() ??
                                                "",
                                            style: TextStyle(
                                                color: Color(0xff000000),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Sarabun"),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "TASKS",
                                        style: TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Inter"),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Meetings()));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: w * 0.16,
                                        height: w * 0.115,
                                        padding: EdgeInsets.only(
                                            left: 3,
                                            right: 3,
                                            top: 2,
                                            bottom: 2),
                                        decoration: BoxDecoration(
                                            color: Color(0x1A08BED0),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Center(
                                          child: Text(
                                            userdata?.meetingCount.toString() ??
                                                "",
                                            style: TextStyle(
                                                color: Color(0xff000000),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Sarabun"),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "MEETINGS",
                                        style: TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Inter"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkResponse(
                              onTap: () {
                                // setState(() {
                                //   _isLoading=true;
                                // });
                                // showCustomDialog(context);
                                CustomSnackBar.show(context, "Coming soon...");
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                width: w,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xff8856F4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // _isLoading?spinkit.getFadingCircleSpinner():
                                    Text(
                                      "Punch In",
                                      style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Inter"),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    // Image.asset(
                                    //   "assets/fingerPrint.png",
                                    //   fit: BoxFit.contain,
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      drawer: Drawer(
        backgroundColor: Color(0xff8856F4),
        width: w * 0.65,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Image.asset(
                          "assets/skillLogo.png",
                          fit: BoxFit.contain,
                          width: 60,
                          height: 30,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            "assets/cross.png",
                            fit: BoxFit.contain,
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                height: 32,
                margin: EdgeInsets.only(left: 16, right: 16, top: 12),
                padding: EdgeInsets.only(left: 10, top: 6, bottom: 6),
                decoration: BoxDecoration(
                  color: Color(0xffEAE0FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: (text) {
                    if (text.length > 2) {
                      setState(() {
                        employeeData = []; // Clear previous data
                      });
                      GetSerachUsersdata(text); // Fetch new data
                    } else {
                      setState(() {
                        employeeData =
                            []; // Clear data if input is less than 3 characters
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Color(0xff9E7BCA)),
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: Color(0xff9E7BCA),
                    ),
                  ),
                  style: TextStyle(color: Color(0xff9E7BCA)),
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                itemCount: employeeData.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final employee = employeeData[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(employee.image ?? ""),
                    ),
                    title: Text(
                      employee.fullName ?? "",
                      style: const TextStyle(
                        color: Color(0xffFFFFFF),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: "Inter",
                      ),
                    ),
                    onTap: () async {
                      try {
                        setState(() {
                          employeeData = [];
                        });
                        createRoom(employee.id ?? "");
                      } catch (error) {
                        // Handle error
                        print(error);
                      }
                    },
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.arrow_drop_down,
                            color: Color(0xffffffff), size: 25),
                        SizedBox(width: 15),
                        Text(
                          "Direct messages",
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                      itemCount: rooms.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        return InkResponse(
                          onTap: () {
                            // Reset message count for the specific room
                            setState(() {
                              room.messageCount = 0;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatPage(roomId: room.roomId),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    room.otherUserImage ?? '',
                                    fit: BoxFit.cover,
                                    width: 43,
                                    height: 43,
                                    errorBuilder: (context, error, stackTrace) {
                                      return ClipOval(
                                        child: Icon(Icons.person, size: 43),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        room.otherUser ?? 'No Name',
                                        style: const TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              room.message ?? '',
                                              style: const TextStyle(
                                                color: Color(0xffFFFFFF),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: "Inter",
                                              ),
                                            ),
                                          ),
                                          if (room.messageCount > 0)
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                '${room.messageCount}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Image.asset(
                                  "assets/notify.png",
                                  fit: BoxFit.contain,
                                  width: 24,
                                  height: 24,
                                  color: Color(0xffFFFFFF).withOpacity(0.7),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Container(
              //   padding: EdgeInsets.only(left: 16, right: 16, bottom: 30),
              //   child: Row(
              //     children: [
              //       Container(
              //         width: 20,
              //         height: 20,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(4),
              //           color: Color(0xffFFFFFF1A).withOpacity(0.10),
              //         ),
              //         child: Center(
              //           child: Image.asset(
              //             "assets/add.png",
              //             fit: BoxFit.contain,
              //             height: 9,
              //             width: 9,
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: 8),
              //       Text(
              //         "Add channels",
              //         style: const TextStyle(
              //           color: Color(0xffFFFFFF),
              //           fontWeight: FontWeight.w400,
              //           fontSize: 14,
              //           overflow: TextOverflow.ellipsis,
              //           fontFamily: "Inter",
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        width: w * 0.3,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 40),
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Color(0xfff8856F4),
                      borderRadius: BorderRadius.circular(4)),
                  child: Image.asset("assets/dashboard.png"),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Color(0xff8856F4),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Inter",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Messages()));
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset("assets/msg.png"),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Messages",
                          style: TextStyle(
                            color: Color(0xff6C848F),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Todolist()));
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset("assets/folder-plus.png"),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "To Do List",
                          style: TextStyle(
                            color: Color(0xff6C848F),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProjectsScreen()));
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset("assets/Frame.png"),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Projects",
                          style: TextStyle(
                            color: Color(0xff6C848F),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => Allchannels()));
                //   },
                //   child: Container(
                //     child: Column(
                //       children: [
                //         Container(
                //           padding: EdgeInsets.all(4),
                //           width: 32,
                //           height: 32,
                //           decoration: BoxDecoration(
                //               color: Color(0xffffffff),
                //               borderRadius: BorderRadius.circular(4)),
                //           child: Image.asset("assets/Channel.png"),
                //         ),
                //         SizedBox(
                //           height: 4,
                //         ),
                //         Text(
                //           "Channels",
                //           style: TextStyle(
                //             color: Color(0xff6C848F),
                //             fontWeight: FontWeight.w400,
                //             fontSize: 14,
                //             overflow: TextOverflow.ellipsis,
                //             fontFamily: "Inter",
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Leave()));
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset("assets/calendar.png"),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Leaves",
                          style: TextStyle(
                            color: Color(0xff6C848F),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Meetings()));
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset("assets/video.png"),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Meetings",
                          style: TextStyle(
                            color: Color(0xff6C848F),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                // InkResponse(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => MyHomePage(
                //                   title: "Demo chat bubble",
                //                 ))
                //     );
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(4),
                //     width: 32,
                //     height: 32,
                //     decoration: BoxDecoration(
                //         color: Color(0xffffffff),
                //         borderRadius: BorderRadius.circular(4)),
                //     child: Image.asset("assets/Settings.png"),
                //   ),
                // ),
                // SizedBox(
                //   height: 4,
                // ),
                // Text(
                //   "Settings",
                //   style: TextStyle(
                //     color: Color(0xff6C848F),
                //     fontWeight: FontWeight.w400,
                //     fontSize: 14,
                //     overflow: TextOverflow.ellipsis,
                //     fontFamily: "Inter",
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                InkWell(
                  onTap: () {
                    PreferenceService().remove("token");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LogInScreen()));
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset("assets/logout.png"),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Color(0xffDE350B),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 102,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 400,
                width: double.infinity,
                child: GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.7749, -122.4194),
                    zoom: 10,
                  ),
                  myLocationEnabled: true,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Punch In action
                        Navigator.of(context).pop();
                      },
                      child: Text('Punch In'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Cancel action
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
