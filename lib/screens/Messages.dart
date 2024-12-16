import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill/Model/UserDetailsModel.dart';
import 'package:skill/utils/CustomSnackBar.dart';

import '../Model/RoomsModel.dart';
import '../Providers/ConnectivityProviders.dart';
import '../Services/UserApi.dart';
import '../Services/otherservices.dart';
import '../utils/Mywidgets.dart';
import '../utils/app_colors.dart';
import 'OneToOneChatPage.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> items1 = [
    {
      'image': 'assets/Pixl Team.png',
      'title': 'Vishwa',
      'subtitle': 'Date of appointment...',
      'time': '33 mins'
    },
    {
      'image': 'assets/Pixl Team.png',
      'title': 'Varun',
      'subtitle': 'Date of appointment...',
      'time': '33 mins'
    },
    {
      'image': 'assets/Pixl Team.png',
      'title': 'Karthik',
      'subtitle': 'Date of appointment...',
      'time': '33 mins'
    },
  ];
  bool showNoDataFoundMessage = false;
  bool isSelected = false;
  bool _loading = true;
  final spinkit = Spinkits();

  List<Rooms> rooms = [];
  List<Rooms> filteredRooms = []; // To store filtered messages based on the search query

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProviders>(context, listen: false).initConnectivity();
    _searchController.addListener(_onSearchChanged);
    GetRoomsList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    Provider.of<ConnectivityProviders>(context,listen: false).dispose();
    super.dispose();
  }

  Future<void> GetRoomsList() async {
    var res = await Userapi.getrommsApi();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          _loading = false;
          rooms = res.data ?? [];
          rooms.sort(
              (a, b) => (b.messageTime ?? 0).compareTo(a.messageTime ?? 0));
          filteredRooms = rooms; // Initially, show all rooms

          if (rooms.isEmpty) {
            // Handle empty rooms case
            showNoDataFoundMessage =
                true; // Set this flag when no data is found
          } else {
            showNoDataFoundMessage = false; // Data found, so hide the message
          }
        } else {
          // If success is not 1, assume no data and show the message
          showNoDataFoundMessage = true;
          _loading = false;
        }
      } else {
        // Handle null response case, show message
        showNoDataFoundMessage = true;
        _loading = false;
      }
    });
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredRooms = rooms.where((room) {
        String otherUser =
            room.otherUser?.toLowerCase() ?? ''; // Handle null cases
        String message = room.message?.toLowerCase() ?? '';
        return otherUser.contains(query) || message.contains(query);
      }).toList();
      print('Filtered rooms: ${filteredRooms.length}'); // Debug log
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var connectiVityStatus =Provider.of<ConnectivityProviders>(context);
    return
      (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
          connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
          ?
 Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
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
          "Messages",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
            height: 29.05 / 24.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: w,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/search.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: 'Search',
                            hintStyle: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Color(0xff9E7BCA),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontFamily: "Nunito",
                            ),
                          ),
                          style: TextStyle(
                              color: Color(0xff9E7BCA),
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              decorationColor: Color(0xff9E7BCA),
                              fontFamily: "Nunito",
                              overflow: TextOverflow.ellipsis),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 20),
            // Row(
            //   children: [
            //     const Text(
            //       "Direct messages",
            //       style: TextStyle(
            //         color: Color(0xff1C1C1C),
            //         fontFamily: "Inter",
            //         fontSize: 14,
            //         fontWeight: FontWeight.w400,
            //         height: 15 / 14,
            //       ),
            //     ),
            //     const Spacer(),
            //     const Text(
            //       "Unread",
            //       style: TextStyle(
            //         color: Color(0xff000000),
            //         fontFamily: "Inter",
            //         fontSize: 13,
            //         fontWeight: FontWeight.w400,
            //         height: 15 / 13,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 40,
            //       height: 20,
            //       child: Transform.scale(
            //         scale: 0.5,
            //         child: Switch(
            //           value: isSelected,
            //           inactiveThumbColor: const Color(0xff98A9B0),
            //           activeColor: const Color(0xff8856F4),
            //           onChanged: (bool value) {
            //             setState(() {
            //               isSelected = value;
            //             });
            //           },
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            SizedBox(height: w * 0.02),
            Expanded(
              child: _loading
                  ? _buildShimmerGrid()
                  : filteredRooms.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/nodata1.png', // Make sure to use the correct image path
                                width:
                                    150, // Adjust the size according to your design
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "No Data Found",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredRooms.length,
                          itemBuilder: (context, index) {
                            var data = filteredRooms[index];
                            String isoDate = data.messageSent ?? "";

                            DateTime? dateTime;
                            String formattedTime = "";

                            if (isoDate.isNotEmpty) {
                              try {
                                dateTime = DateTime.parse(isoDate);
                                formattedTime =
                                    "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
                              } catch (e) {
                                print("Error parsing date: $e");
                              }
                            }

                            return InkResponse(
                              onTap: () async {
                                var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatPage(roomId: data.roomId,ID: "",),
                                  ),
                                );
                                if (res == true) {
                                  setState(() {
                                    _loading = true;
                                    GetRoomsList();
                                  });
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF7F4FC),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipOval(
                                            child: Image.network(
                                              data.otherUserImage ?? "",
                                              fit: BoxFit.cover,
                                              width: 32,
                                              height: 32,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [


                                          Text(
                                            data.otherUser ?? "",
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w400,
                                              height: 19.36 / 16,
                                              color: Color(0xff1C1C1C),
                                            ),
                                          ),
                                          if(data.message!=null)...[
                                            Text(
                                              data.message ?? "",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                height: 14.52 / 12,
                                                overflow: TextOverflow.ellipsis,
                                                color: Color(0xff8A8A8A),
                                              ),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        formattedTime,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          height: 14.52 / 12,
                                          overflow: TextOverflow.ellipsis,
                                          color: Color(0xff8A8A8A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    )      :NoInternetWidget();
  }

  Widget _buildShimmerGrid() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: 6, // Number of shimmer items to display
      itemBuilder: (context, index) {
        return InkResponse(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xffF7F4FC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  shimmerCircle(32,context), // Use your shimmer circle
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerText(100, 16,context), // Shimmer for user name
                        const SizedBox(height: 5),
                        shimmerText(160, 12,context), // Shimmer for message
                      ],
                    ),
                  ),
                  const Spacer(),
                  shimmerText(50, 12,context), // Shimmer for formatted time
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
