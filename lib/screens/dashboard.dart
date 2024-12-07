import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skill/Profile/ProfileDashboard.dart';
import 'package:skill/Providers/ProfileProvider.dart';
import 'package:skill/Services/UserApi.dart';
import 'package:skill/screens/AIChatPage.dart';
import 'package:skill/screens/Leave.dart';
import 'package:skill/Authentication/LogInScreen.dart';
import 'package:skill/screens/Meetings.dart';
import 'package:skill/screens/Messages.dart';
import 'package:skill/screens/Notifications.dart';
import 'package:skill/ProjectModule/Projects.dart';
import 'package:skill/screens/PunchInOut.dart';
import 'package:skill/screens/Task.dart';
import 'package:skill/screens/ToDoList.dart';
import 'package:skill/utils/CustomSnackBar.dart';
import 'package:skill/utils/Preferances.dart';
import 'package:vibration/vibration.dart';
import 'package:web_socket_channel/io.dart';
import '../Model/EmployeeListModel.dart';
import '../Model/ProjectsModel.dart';
import '../Model/RoomsModel.dart';
import '../ProjectModule/TabBar.dart';
import '../Model/UserDetailsModel.dart';
import '../Providers/ThemeProvider.dart';
import '../Services/otherservices.dart';
import '../utils/Mywidgets.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'OneToOneChatPage.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:geocoding/geocoding.dart' as geocoder;

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  late IOWebSocketChannel _socket;
  bool _isListVisible = true; // Variable to track visibility
  String userid = "";
  List<Rooms> rooms = [];
  String selectedEmployee = "";
  String mainWeatherStatus = "";
  final spinkit = Spinkits();
  var lattitude;
  var longitude;
  var address;
  bool _loading = true;
  bool is_notify = false;
  int? _animatingIndex;

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  var isDeviceConnected = "";

  double lat = 0.0;
  double lng = 0.0;
  var latlngs = "";
  bool valid_address = true;
  bool punching = true;

  late String _locationName = "";
  late String _pinCode = "";
  final nonEditableAddressController = TextEditingController();

  Set<Marker> markers = {};
  var address_loading = true;
  bool submit = false;

  String status = "";

  @override
  void initState() {
    initConnectivity();
    GetUserDeatails();
    GetEmployeeData();
    GetRoomsList();

    GetProjectsData();
    get_lat_log();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  Future<void> createRoom(String id) async {
    var res = await Userapi.CreateChatRoomAPi(id);
    setState(() {
      if (res != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(roomId: res.data?.room ?? "",ID:userdata?.employee?.id??"",),
          ),
        );
      } else {
        CustomSnackBar.show(context, "${res?.settings?.message}");
      }
    });
  }

  Future<void> _getAddress(double? lat1, double? lng1) async {
    if (lat1 == null || lng1 == null) return;
    List<geocoder.Placemark> placemarks =
        await geocoder.placemarkFromCoordinates(lat1, lng1);

    geocoder.Placemark? validPlacemark;
    for (var placemark in placemarks) {
      if (placemark.country == 'India' &&
          placemark.isoCountryCode == 'IN' &&
          placemark.postalCode != null &&
          placemark.postalCode!.isNotEmpty) {
        validPlacemark = placemark;
        break;
      }
    }
    if (validPlacemark != null) {
      setState(() {
        _locationName =
            "${validPlacemark?.name},${validPlacemark?.subLocality},${validPlacemark?.subAdministrativeArea},"
                    "${validPlacemark?.administrativeArea},${validPlacemark?.postalCode}"
                .toString();
        _pinCode = validPlacemark!.postalCode.toString();
        address_loading = false;
        valid_address = true;
        _loading = false;
      });
    } else {
      // Handle case where no valid placemark is found
      setState(() {
        _locationName =
            "Whoa there, explorer! \nYou've reached a place we haven't. Our services are unavailable here. \nTry another location!";
        address_loading = false;
        valid_address = false;
        _loading = false;
      });
    }
  }

  Future<void> initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      // Check connectivity and get the result
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    // Update connection status based on the single ConnectivityResult
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      for (int i = 0; i < _connectionStatus.length; i++) {
        setState(() {
          isDeviceConnected = _connectionStatus[i].toString();
          print("isDeviceConnected:${isDeviceConnected}");
        });
      }
    });
    print('Connectivity changed: $_connectionStatus');
  }

  Future<void> get_lat_log() async {
    // Check location permission
    var status = await Permission.location.status;

    // If the permission is denied, request it
    if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        // Permission granted
        await _getLocation();
      } else {
        // Permission denied
        // Handle permission denial (show a message, etc.)
        return;
      }
    } else if (status.isGranted) {
      // Permission already granted
      await _getLocation();
    }
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        lattitude = position.latitude;
        longitude = position.longitude;
        address =
            "${placemarks[0].subLocality}, ${placemarks[0].street}, ${placemarks[0].locality}";
      });
      fetchWeather();
    } catch (e) {
      // Handle any errors
      print('Error getting location: $e');
    }
  }

  Future<void> fetchWeather() async {
    final apiKey = '5ea9806af0bf37b08dab840ff3b70c5b';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lattitude&lon=$longitude&appid=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      setState(() {
        if (response.statusCode == 200) {
          // Parse the JSON response
          final data = json.decode(response.body);
          // Extract the main weather status
          mainWeatherStatus = data['weather'][0]['main'];

          // Print the extracted status
          print('Main weather status: $mainWeatherStatus');
        } else {
          print('Error: ${response.statusCode}');
        }
      });
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  bool _isConnected = false;
  void _initializeWebSocket(String userid) async {
    final token = await PreferenceService().getString("token");
    print('Attempting to connect to WebSocket...');
    _socket = IOWebSocketChannel.connect(
        Uri.parse("wss://stage.skil.in/ws/notify/${userid}?token=${token}"));
    print(
        'Connected to WebSocket at: wss://stage.skil.in/ws/notify/${userid}?token=${token}');
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
        _loading = false;
      }
    });
  }

  // Future<void> createRoom(String id) async {
  //   var res = await Userapi.CreateChatRoomAPi(id);
  //   setState(() {
  //     if (res != null && res.settings?.success == 1) {
  //       GetRoomsList();
  //       _searchController.text = "";
  //       Navigator.pop(context);
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ChatPage(roomId: res.data?.room ?? ""),
  //         ),
  //       );
  //     } else {
  //       CustomSnackBar.show(context, "${res?.settings?.message}");
  //     }
  //   });
  // }

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
      if (sentUser != userid) {
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
        _loading = false;
        if (res.settings?.success == 1) {
          rooms = res.data ?? [];
          rooms.sort(
              (a, b) => (b.messageTime ?? 0).compareTo(a.messageTime ?? 0));
        } else {}
      }
    });
  }

  Future<void> Notifyuser(String id) async {
    var res = await Userapi.notifyUser(id);
    setState(() {
      if (res != null) {
        if(res.settings?.success==1){
            is_notify=false;
        }else{
          is_notify=false;
        }
      }
    });
  }

  List<Employeedata> employeeData = [];
  List<Employeedata> tempemployeeData = [];
  Future<void> GetEmployeeData() async {
    var Res = await Userapi.GetEmployeeList();
    setState(() {
      if (Res != null && Res.data != null) {
        employeeData = Res.data ?? [];
        tempemployeeData = Res.data ?? [];
      }
    });
  }

  Future<void> GetSearchUsersData(String text) async {
    var Res = await Userapi.GetSearchUsers(text);
    setState(() {
      if (Res != null && Res.data != null) {
        employeeData = Res.data ?? [];
        print("Employee List Retrieved Successfully: ${Res.settings?.message}");
      } else {
        employeeData = [];
        print("Employee List Retrieval Failed: ${Res?.settings?.message}");
      }
    });
  }

  UserData? userdata;
  // Function to fetch user details
  Future<void> GetUserDeatails() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    try {
      await profileProvider.fetchUserDetails();
       userdata = profileProvider.userProfile;
      PreferenceService().saveString("my_employeeID", userdata?.employee?.id ?? "");
    } catch (e) {
      print("Error: $e");
    } finally {
      // Once the data is fetched, stop showing the loader
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _refreshItems() async {
    await Future.delayed(Duration(seconds: 2));
    GetEmployeeData();
    GetRoomsList();
    GetProjectsData();
    get_lat_log();
    setState(() {
      employeeData = [];
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM d, y').format(now);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return (isDeviceConnected == "ConnectivityResult.wifi" ||
            isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
            key: _scaffoldKey,
            backgroundColor: themeProvider.scaffoldBackgroundColor, // Use dynamic background color
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: null, // Hides the leading icon (for drawer)
              actions: <Widget>[Container()],
              toolbarHeight: 58,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    InkResponse(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Image.asset(
                          "assets/menu.png",
                          width: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
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
                                    builder: (context) => AIChatPage()));
                          },
                          child: Container(
                            width:
                                48, // Increase this size to make the area more tappable
                            height:
                                48, // Increase this size to make the area more tappable
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/robo.png",
                              width: 30,
                              height: 30,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationsScreen()));
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
                ? _buildShimmerGrid(w)
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Today \n$formattedDate",
                                  style: TextStyle(
                                      color: themeProvider.textColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      fontFamily: "Inter"),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/sun1.png",
                                      width: 30,
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      mainWeatherStatus,
                                      style: TextStyle(
                                          color: themeProvider.textColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          fontFamily: "Inter"),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    // Image.asset(
                                    //   "assets/sun2.png",
                                    //   width: 25,
                                    //   height: 25,
                                    // ),
                                  ],
                                )
                              ],
                            ),
                            // SwitchListTile(
                            //   title: Text('Dark Mode'),
                            //   value: themeProvider.themeData.brightness == Brightness.dark,
                            //   onChanged: (bool value) {
                            //     // Change the theme based on the switch value
                            //     if (value) {
                            //       themeProvider.setDarkTheme();
                            //     } else {
                            //       themeProvider.setLightTheme();
                            //     }
                            //   },
                            // ),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 16, vertical: 6),
                            //   decoration: BoxDecoration(
                            //       color: const Color(0xffffffff),
                            //       borderRadius: BorderRadius.circular(8)),
                            //   child: Row(
                            //     children: [
                            //       Image.asset(
                            //         "assets/search.png",
                            //         width: 24,
                            //         height: 24,
                            //         fit: BoxFit.contain,
                            //       ),
                            //       const SizedBox(width: 10),
                            //       const Text(
                            //         "Search",
                            //         style: TextStyle(
                            //             color: Color(0xff9E7BCA),
                            //             fontWeight: FontWeight.w400,
                            //             fontSize: 16,
                            //             fontFamily: "Nunito"),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: w * 0.03,
                            ),
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) {
                                final userdata = profileProvider.userProfile;
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color:themeProvider.themeData==lightTheme? AppColors.primaryColor : AppColors.darkmodeContainerColor,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4,
                                                          right: 4,
                                                          top: 2,
                                                          bottom: 2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffFFFFFF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        userdata?.userNumber ??
                                                            "",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff8856F4),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 10,
                                                            height: 12.1 / 10,
                                                            letterSpacing: 0.14,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontFamily:
                                                                "Nunito"),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        userdata?.fullName ??
                                                            "",
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontFamily:
                                                                "Inter"),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4,
                                                          vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xff2FB035),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: Text(
                                                        userdata?.status ?? "",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12,
                                                            height: 16.36 / 12,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontFamily:
                                                                "Nunito"),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfileDashboard()),
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.asset(
                                                          "assets/edit.png",
                                                          width: 20,
                                                          height: 20,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            userdata?.employee
                                                                    ?.designation ??
                                                                "",
                                                            style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                            0xffFFFFFF)
                                                                        .withOpacity(
                                                                            0.7),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                                height:
                                                                    16.21 / 12,
                                                                letterSpacing:
                                                                    0.14,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontFamily:
                                                                    "Inter"),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              4,
                                                                          vertical:
                                                                              3),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(6),
                                                                    color: Color(
                                                                            0xffFFFFFF)
                                                                        .withOpacity(
                                                                            0.25),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        "assets/call.png",
                                                                        fit: BoxFit
                                                                            .contain,
                                                                        width:
                                                                            12,
                                                                        color: Color(
                                                                            0xffffffff),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              4),
                                                                      Expanded(
                                                                        // Wrap Text with Expanded to avoid overflow
                                                                        child:
                                                                            Text(
                                                                          userdata?.mobile ??
                                                                              "",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                const Color(0xffFFFFFF),
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize:
                                                                                11,
                                                                            height:
                                                                                13.41 / 11,
                                                                            letterSpacing:
                                                                                0.14,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            fontFamily:
                                                                                "Inter",
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: w *
                                                                      0.015),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              4,
                                                                          vertical:
                                                                              3),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(6),
                                                                    color: Color(
                                                                            0xffFFFFFF)
                                                                        .withOpacity(
                                                                            0.25),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        "assets/gmail.png",
                                                                        fit: BoxFit
                                                                            .contain,
                                                                        width:
                                                                            12,
                                                                        color: Color(
                                                                            0xffffffff),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              4),
                                                                      Expanded(
                                                                        // Wrap Text with Expanded here too
                                                                        child:
                                                                            Text(
                                                                          userdata?.email ??
                                                                              "",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                const Color(0xffFFFFFF),
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize:
                                                                                11,
                                                                            height:
                                                                                13.41 / 11,
                                                                            letterSpacing:
                                                                                0.14,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
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
                                );
                              },
                            ),
                            SizedBox(
                              height: w * 0.04,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Projects",
                                  style: TextStyle(
                                      color: themeProvider.themeData==lightTheme? Color(0xff16192C) :  themeProvider.textColor,
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
                                            builder: (context) =>
                                                ProjectsScreen()));
                                  },
                                  child: Text(
                                    "See all",
                                    style: TextStyle(
                                        color: Color(0xff8856F4),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        height: 16.94 / 14,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primaryColor,
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
                                height: projectsData.length > 2
                                    ? w * 0.78
                                    : w * 0.45,
                                child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: projectsData.length,
                                  gridDelegate:
                                      // SliverGridDelegateWithFixedCrossAxisCount(
                                      //     crossAxisCount:
                                      //         2, // Two items per row
                                      //     childAspectRatio:
                                      //         0.8, // Adjust this ratio to fit your design
                                      //     mainAxisSpacing: 2,
                                      //     crossAxisSpacing:
                                      //         10 // Space between items horizontally
                                      //     ),
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              projectsData.length > 2 ? 2 : 1,
                                          childAspectRatio:
                                              projectsData.length > 2
                                                  ? 0.8
                                                  : 0.98,
                                          // 0.8, // Adjust this ratio to fit your design
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
                                                      titile:
                                                          '${data.name ?? ""}',
                                                      id: '${data.id}',
                                                    )));
                                        print('idd>>${data.id}');
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 10,
                                              bottom: 10),
                                          decoration: BoxDecoration(
                                            color: themeProvider.themeData==lightTheme? Color(0xffffffff) : AppColors.darkmodeContainerColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                                style: TextStyle(
                                                    color: themeProvider.themeData==lightTheme? Color(0xff4F3A84) : themeProvider.textColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    height: 19.36 / 16,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                            color:themeProvider.textColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                            height: 14.52 / 12,
                                                            fontFamily:
                                                                "Inter"),
                                                      ),
                                                      Text(
                                                        "${data.totalPercent ?? ""}%",
                                                        style: TextStyle(
                                                            color:themeProvider.textColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "Inter"),
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
                                                        BorderRadius.circular(
                                                            20),
                                                    color:
                                                        const Color(0xff2FB035),
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
                                height: w * 0.4,
                                child: Center(
                                  child: Text(
                                    "No projects are assigned.",
                                    style: TextStyle(
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
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
                            //             decorationColor:AppColors.primaryColor,
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
                              height: h * 0.18,
                            ),
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) {
                                final userdata = profileProvider.userProfile;
                                return Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                        color:themeProvider.containerColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await Navigator.push(
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
                                                      color:themeProvider.themeData==lightTheme?Color(0x1A8856F4) :  themeProvider.scaffoldBackgroundColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Center(
                                                    child: Text(
                                                      userdata?.projectCount
                                                              .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                          color: themeProvider.textColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              "Sarabun"),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "PROJECTS",
                                                  style: TextStyle(
                                                      color: themeProvider.textColor,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                      builder: (context) =>
                                                          Todolist()));
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
                                                      color:themeProvider.themeData==lightTheme? Color(0xffF1FFF3) :  themeProvider.scaffoldBackgroundColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Center(
                                                    child: Text(
                                                      userdata?.todoCount
                                                              .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                          color: themeProvider.textColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              "Sarabun"),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "TO DO",
                                                  style: TextStyle(
                                                      color: themeProvider.textColor,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Inter"),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Task()));
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
                                                      color:themeProvider.themeData==lightTheme?  Color(0x1AFBBC04) :  themeProvider.scaffoldBackgroundColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Center(
                                                    child: Text(
                                                      userdata?.tasksCount
                                                              .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                          color: themeProvider.textColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              "Sarabun"),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "TASKS",
                                                  style: TextStyle(
                                                      color: themeProvider.textColor,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                      builder: (context) =>
                                                          Meetings()));
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
                                                      color:themeProvider.themeData==lightTheme?  Color(0x1A08BED0) :  themeProvider.scaffoldBackgroundColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Center(
                                                    child: Text(
                                                      userdata?.meetingCount
                                                              .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                          color: themeProvider.textColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              "Sarabun"),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "MEETINGS",
                                                  style: TextStyle(
                                                      color: themeProvider.textColor,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Punching(),
                                              ));
                                          // showCustomDialog(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          width: w,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
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
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            drawer: Drawer(
              backgroundColor:themeProvider.themeData==lightTheme? AppColors.primaryColor:  themeProvider.scaffoldBackgroundColor,
              width: w * 0.65,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 40),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/skillLogo.png",
                              fit: BoxFit.contain,
                              width: 60,
                              height: 30,
                            ),
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
                      controller: _searchController,
                      onChanged: (text) {
                        setState(() {
                          if (text.isNotEmpty) {
                            // Filter employeeData based on the search query
                            employeeData = tempemployeeData.where((employee) {
                              return employee.name!.toLowerCase().contains(text.toLowerCase());
                            }).toList();
                          } else {
                            // Reset to original data if the search field is empty
                            employeeData = List.from(tempemployeeData);
                          }
                        });
                      },
                      // onChanged: (text) {
                      //   setState(() {
                      //     if (text.length > 0) {
                      //       employeeData = []; // Clear previous dat
                      //       GetSearchUsersData(text); // Fetch new data
                      //     } else {
                      //       employeeData = [];
                      //       employeeData = tempemployeeData;
                      //     }
                      //   });
                      // },
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
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: employeeData.length == 0
                        ? Text(
                            "No Data found!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(bottom: 10, top: 10),
                            itemCount: employeeData.length,
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final employee = employeeData[index];
                              final bool isAnimating = _animatingIndex == index; // Check if the current index is animating
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(employee.image ?? ""),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        employee.name ?? "",
                                        style: const TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (isAnimating)
                                          Lottie.asset(
                                            'assets/animations/wave.json',
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.cover,
                                          ),
                                        InkResponse(
                                          onTap: () async {
                                            if(is_notify){

                                            }else{
                                              setState(() {
                                                Notifyuser(employee.id ?? "");
                                                Vibration.vibrate(duration: 300);
                                                _animatingIndex = index;
                                                is_notify=true;
                                              });
                                            }
                                            await Future.delayed(
                                                Duration(seconds: 2));
                                            setState(() {
                                              _animatingIndex = null;
                                            });
                                          },
                                          child: Image.asset(
                                            'assets/notify.png',
                                            fit: BoxFit.contain,
                                            width: 24,
                                            height: 24,
                                            color: Color(0xffFFFFFF)
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  try {
                                    FocusScope.of(context).unfocus();
                                    Navigator.pop(context, true);
                                    if(employee.room_id!=""){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            roomId: employee.room_id ?? "",
                                            ID: userdata?.employee?.id?? "",
                                          ),
                                        ),
                                      );
                                    }else{
                                      createRoom(employee.id??"");
                                    }
                                  } catch (error) {
                                    // Handle error
                                    print(error);
                                  }
                                },
                              );
                            },
                          ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 16, right: 16),
                  //   child: Column(
                  //     children: [
                  //       // InkResponse(
                  //       //   onTap: () {
                  //       //     setState(() {
                  //       //       _isListVisible = !_isListVisible; // Toggle visibility
                  //       //     });
                  //       //   },
                  //       //   child: Row(
                  //       //     mainAxisAlignment: MainAxisAlignment.start,
                  //       //     crossAxisAlignment: CrossAxisAlignment.start,
                  //       //     children: [
                  //       //       if (_isListVisible) ...[
                  //       //         Icon(Icons.arrow_drop_down,
                  //       //             color: Color(0xffffffff), size: 25),
                  //       //       ] else ...[
                  //       //         Icon(Icons.arrow_drop_up,
                  //       //             color: Color(0xffffffff), size: 25),
                  //       //       ],
                  //       //       SizedBox(width: 15),
                  //       //       Text(
                  //       //         "Direct messages",
                  //       //         style: TextStyle(
                  //       //           color: Color(0xffffffff),
                  //       //           fontFamily: "Inter",
                  //       //           fontWeight: FontWeight.w400,
                  //       //           fontSize: 14,
                  //       //         ),
                  //       //       ),
                  //       //     ],
                  //       //   ),
                  //       // ),
                  //       // if (_isListVisible) // Conditionally show the ListView
                  //         ListView.builder(
                  //           padding: EdgeInsets.only(top: 10),
                  //           itemCount: rooms.length,
                  //           shrinkWrap: true,
                  //           physics: NeverScrollableScrollPhysics(),
                  //           itemBuilder: (context, index) {
                  //             final room = rooms[index];
                  //             return InkResponse(
                  //               onTap: () {
                  //                 setState(() {
                  //                   room.messageCount = 0;
                  //                 });
                  //                 Navigator.pop(context);
                  //                 Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                     builder: (context) =>
                  //                         ChatPage(roomId: room.roomId),
                  //                   ),
                  //                 );
                  //               },
                  //               child: Padding(
                  //                 padding: const EdgeInsets.symmetric(vertical: 8),
                  //                 child: Row(
                  //                   children: [
                  //                     ClipOval(
                  //                       child: Image.network(
                  //                         room.otherUserImage ?? '',
                  //                         fit: BoxFit.cover,
                  //                         width: 43,
                  //                         height: 43,
                  //                         errorBuilder:
                  //                             (context, error, stackTrace) {
                  //                           return ClipOval(
                  //                             child: Icon(Icons.person, size: 43),
                  //                           );
                  //                         },
                  //                       ),
                  //                     ),
                  //                     SizedBox(width: 8),
                  //                     Expanded(
                  //                       child: Column(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           Text(
                  //                             room.otherUser ?? 'No Name',
                  //                             style: const TextStyle(
                  //                               color: Color(0xffFFFFFF),
                  //                               fontWeight: FontWeight.w400,
                  //                               fontSize: 14,
                  //                               overflow: TextOverflow.ellipsis,
                  //                               fontFamily: "Inter",
                  //                             ),
                  //                           ),
                  //                           Row(
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment.spaceBetween,
                  //                             children: [
                  //                               Expanded(
                  //                                 child: Text(
                  //                                   room.message ?? '',
                  //                                   style: const TextStyle(
                  //                                     color: Color(0xffFFFFFF),
                  //                                     fontWeight: FontWeight.w400,
                  //                                     fontSize: 14,
                  //                                     overflow:
                  //                                         TextOverflow.ellipsis,
                  //                                     fontFamily: "Inter",
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                               if (room.messageCount > 0)
                  //                                 Container(
                  //                                   padding: EdgeInsets.all(4),
                  //                                   decoration: BoxDecoration(
                  //                                     color: Colors.red,
                  //                                     shape: BoxShape.circle,
                  //                                   ),
                  //                                   child: Text(
                  //                                     '${room.messageCount}',
                  //                                     style: const TextStyle(
                  //                                       color: Colors.white,
                  //                                       fontWeight: FontWeight.bold,
                  //                                       fontSize: 12,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                             ],
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                     SizedBox(width: 8),
                  //                     Image.asset(
                  //                       "assets/notify.png",
                  //                       fit: BoxFit.contain,
                  //                       width: 24,
                  //                       height: 24,
                  //                       color: Color(0xffFFFFFF).withOpacity(0.7),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //     ],
                  //   ),
                  // ),
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
            endDrawer: Drawer(
              width: w * 0.3,
              backgroundColor:themeProvider.themeData==lightTheme? Colors.white:themeProvider.scaffoldBackgroundColor,
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
                            color: AppColors.primaryColor,
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
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Messages()));
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
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
                        onTap: () async {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>Todolist()));
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
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
                        onTap: () async {
                          Navigator.pop(context);
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
                          Navigator.pop(context);
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
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Meetings()));
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogInScreen()));
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
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
            // floatingActionButton: InkResponse(
            //   onTap: (){
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => AIChatPage()));
            //   },
            //   child: Image(image: AssetImage("assets/AI.png"),width: 60,height: 60,
            //   ),
            // ),
          )
        : NoInternetWidget();
  }

  Widget _buildShimmerGrid(double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                shimmerText(100, 16),
                shimmerText(100, 16),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      shimmerCircle(70), // Shimmer for profile image
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerText(80, 10), // Shimmer for Skill ID
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                shimmerText(120, 16), // Shimmer for full name
                                shimmerText(50, 12), // Shimmer for status
                              ],
                            ),
                            const SizedBox(height: 8),
                            shimmerText(200, 12), // Shimmer for job title
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                    child: shimmerText(
                                        120, 11)), // Shimmer for mobile
                                const SizedBox(width: 8),
                                Expanded(
                                    child: shimmerText(
                                        120, 11)), // Shimmer for email
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
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                shimmerText(100, 16),
                shimmerText(100, 16),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: width * 0.9,
              child: GridView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.985,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        shimmerCircle(48), // Shimmer for the circular image
                        const SizedBox(height: 8),
                        shimmerText(100, 16), // Shimmer for title text
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            shimmerText(50, 12), // Shimmer for progress label
                            shimmerText(30, 12), // Shimmer for percentage text
                          ],
                        ),
                        const SizedBox(height: 4),
                        shimmerLinearProgress(
                            7), // Shimmer for progress indicator
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              shimmerContainer(width * 0.16,
                                  width * 0.115), // Shimmer for count
                              SizedBox(height: 8),
                              shimmerText(60,
                                  10), // Shimmer for label (e.g., "PROJECTS")
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  shimmerContainer(width, 40,
                      isButton: true), // Shimmer for the "Punch In" button
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // void showCustomDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius:
  //               BorderRadius.circular(16.0), // Adjust the radius as needed
  //         ),
  //         child: Container(
  //           width: double.infinity, // Adjust the width as needed
  //           height: 500,
  //           child: Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               GoogleMap(
  //                 mapType: MapType.normal,
  //                 initialCameraPosition: CameraPosition(
  //                   target: initialPosition,
  //                   zoom: 17.0,
  //                 ),
  //                 onMapCreated: (GoogleMapController controller) {
  //                   _controller = controller;
  //                 },
  //                 markers: markers,
  //                 circles: circles,
  //                 myLocationEnabled: true,
  //                 zoomControlsEnabled: true,
  //                 myLocationButtonEnabled: false,
  //                 compassEnabled: false,
  //                 zoomGesturesEnabled: false,
  //                 scrollGesturesEnabled: false,
  //                 rotateGesturesEnabled: false,
  //                 tiltGesturesEnabled: false,
  //                 minMaxZoomPreference: MinMaxZoomPreference(16, null),
  //               ),
  //               Positioned(
  //                 bottom: 0,
  //                 left: 0,
  //                 right: 0,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         // Handle Punch In action
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: Text('Punch In'),
  //                     ),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         // Handle Cancel action
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: Text('Cancel'),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
