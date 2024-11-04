import 'package:flutter/material.dart';
import 'package:skill/Profile/GeneralInfo.dart';
import 'package:skill/Profile/JobInfo.dart';
import 'package:skill/Profile/PaySlips.dart';
import 'package:skill/utils/CustomAppBar.dart';

class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({super.key});

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffF3ECFB),
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: 'Edit Profile', actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Image.asset(
            'assets/share.png',
            width: 18,
            height: 18,
          ),
        ),
      ]),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            "assets/prashanth.png",
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          // Adjust the positioning as needed
                          bottom: 0,
                          child: Container(
                            height: 25,
                            width: w*0.18,
                           
                            
                            decoration: BoxDecoration(
                            color: Color(0xff8856F4),borderRadius: BorderRadius.only(bottomRight: Radius.circular(1000),bottomLeft: Radius.circular(100))
                            ),
                            child: Center(
                              child: Text(
                                '1', // Example text (like a notification count)
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                     SizedBox(width: 10),
                    // User Info and Performance
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 4, right: 4, top: 2, bottom: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xff8856F4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Skil ID - 02",
                                  style: TextStyle(
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      height: 12.1 / 10,
                                      letterSpacing: 0.14,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Nunito"),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  // userdata?.fullName ?? "",
                                  "Prashanth Chary",
                                  style: const TextStyle(
                                      color: Color(0xff290358),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Inter"),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xff2FB035),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Text(
                                  "Active",
                                  style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      height: 16.36 / 12,
                                      overflow: TextOverflow.ellipsis,
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "UX/UI Designer at PIXL Since 2024",
                                      style: TextStyle(
                                          color: const Color(0xff6C848F),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          height: 16.21 / 14,
                                          letterSpacing: 0.14,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: "Inter"),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 3),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Color(0xff36B37E)
                                                  .withOpacity(0.10),
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
                                                    // userdata?.mobile ??
                                                    "9876543210",
                                                    style: TextStyle(
                                                      color: const Color(
                                                          0xff36B37E),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 11,
                                                      height: 13.41 / 11,
                                                      letterSpacing: 0.14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontFamily: "Inter",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: w * 0.015),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 3),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Color(0xff2572ED)
                                                    .withOpacity(0.08)),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/gmail.png",
                                                  fit: BoxFit.contain,
                                                  width: 12,
                                                  color:
                                                      const Color(0xff2572ED),
                                                ),
                                                SizedBox(width: 4),
                                                Expanded(
                                                  // Wrap Text with Expanded here too
                                                  child: Text(
                                                    // userdata?.email ??
                                                    "chran@gmail.com",
                                                    style: TextStyle(
                                                      color: const Color(
                                                          0xff2572ED),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 11,
                                                      height: 13.41 / 11,
                                                      letterSpacing: 0.14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontFamily: "Inter",
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
          Container(
            width: w,
            decoration: BoxDecoration(color: Color(0xffffffff)),
            child: TabBar(
              dividerColor: Colors.transparent,
              padding: EdgeInsets.zero,
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Color(0xff8856F4),
              indicatorWeight: 1.0,
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.symmetric(horizontal: w * 0.09),
              labelStyle: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 13,
                height: 1.6,
                color: Color(0xff8856F4),
                letterSpacing: 0.15,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: Color(0xff6C848F),
                fontSize: 12,
                height: 1.6,
                letterSpacing: 0.15,
              ),
              tabs: List.generate(1, (index) {
                return Tab(
                  child: Center(
                    child: Text(
                        // index == 0
                        //     ?
                        'General Info'
                        // : index == 1
                        //     ? 'Job Info'
                        //     : 'Payslips',
                        ),
                  ),
                );
              }),
              onTap: (index) {
                FocusScope.of(context).unfocus();
                _pageController.jumpToPage(index);
                setState(() {
                  _selectedTabIndex = index; // Update selected tab index
                });
              },
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [GeneralInfo(), JobInfo(), PaySlips()],
            ),
          ),
        ],
      ),
    );
  }
}
