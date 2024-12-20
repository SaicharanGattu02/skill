import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skill/ProjectModule/MileStone.dart';
import 'package:skill/ProjectModule/ProjectComment.dart';
import 'package:skill/ProjectModule/ProjectFile.dart';
import 'package:skill/ProjectModule/ProjectTimeSheet.dart';
import 'package:skill/ProjectModule/Projects.dart';
import 'package:skill/ProjectModule/TaskKanBan.dart';
import 'package:skill/ProjectModule/TaskList.dart';
import 'dart:developer' as developer;
import '../Providers/ConnectivityProviders.dart';
import '../Providers/ThemeProvider.dart';
import '../Services/otherservices.dart';
import '../utils/ShakeWidget.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'ProjectNotes.dart';
import 'ProjectOverView.dart';
import 'TaskKanbanBoard.dart';

class MyTabBar extends StatefulWidget {
  final String titile;
  final String id;
  const MyTabBar({super.key, required this.titile, required this.id});

  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  late PageController _pageController;
  int _selectedTabIndex = 0;
  bool _loading = true;


  @override
  void initState() {
    super.initState();
    print("idd>>>${widget.id}");
    _tabController = TabController(length: 8, vsync: this); // 8 tabs
    _pageController = PageController(); // Controller for PageView

    // Sync TabController with PageView
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
        _pageController.animateToPage(
          _tabController.index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    setState(() {
      _loading = false;
    });

    Provider.of<ConnectivityProviders>(context, listen: false).initConnectivity();
  }


  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context,listen: false).dispose();
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    var connectiVityStatus =Provider.of<ConnectivityProviders>(context);
    return
      (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
          connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")

        ? Scaffold(
            key: _scaffoldKey,
            backgroundColor: themeProvider.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: themeProvider.themeData==lightTheme?themeProvider.primaryColor : AppColors.darkmodeContainerColor,
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
                widget.titile,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20.0,
                  color: Color(0xffffffff),
                  fontWeight: FontWeight.w500,
                  height: 26.05 / 20.0,
                ),
              ),
              actions: (_selectedTabIndex == 1 ||
                      _selectedTabIndex == 2 ||
                      _selectedTabIndex == 3)
                  ? [
                      Row(
                        children: [
                          Image.asset(
                            "assets/tasktime.png",
                            width: 19,
                            height: 19,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProjectsScreen()));
                            },
                            child: Image.asset(
                              "assets/taskclockhistory.png",
                              width: 22,
                              height: 22,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: 10),
                          // if (_selectedTabIndex ==1)
                          //   InkWell(
                          //     onTap: () {
                          //       _scaffoldKey.currentState?.openEndDrawer();
                          //     },
                          //     child: Image.asset(
                          //       "assets/filter.png",
                          //       width: 20,
                          //       height: 20,
                          //       fit: BoxFit.contain,
                          //     ),
                          //   ),
                          SizedBox(width: 16),
                        ],
                      )
                    ]
                  : null,
            ),
            body: _loading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Color(0xff8856F4),
                  ))
                : Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(  color: themeProvider.themeData==lightTheme? Color(0xffffffff) : AppColors.darkmodeContainerColor,),
                        child: TabBar(
                          dividerColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          controller: _tabController,
                          isScrollable: true,
                          indicatorColor:themeProvider.themeData==lightTheme?  themeProvider.primaryColor : Color(0xffffffff),
                          indicatorWeight: 1.0,
                          tabAlignment: TabAlignment.start,
                          labelPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            height: 1.6,
                            color: themeProvider.themeData==lightTheme?themeProvider.primaryColor : Color(0xffffffff),
                            letterSpacing: 0.15,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            color:themeProvider.themeData==lightTheme? Color(0xff6C848F) : Color(0xffffffff),
                            fontSize: 12,
                            height: 1.6,
                            letterSpacing: 0.15,
                          ),
                          tabs: [
                            Tab(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Overview'))),
                            Tab(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Task List'))),
                            Tab(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Task Kanban'))),
                            Tab(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Milestones'))),
                            Tab(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Notes'))),
                            Tab(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Files'))),
                            Tab(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Timesheets'))),
                            Tab(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Comments'))),
                          ],
                          onTap: (index) {
                            FocusScope.of(context)
                                .unfocus(); // Update the current page index
                            _pageController.jumpToPage(
                                index); // Change page when tab is tapped
                            setState(() {
                              _selectedTabIndex =
                                  index; // Update selected tab index
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics:
                              NeverScrollableScrollPhysics(), // Disable swipe
                          children: [
                            OverView(id: widget.id),
                            TaskList(id1: '${widget.id}'),
                            Taskkanbanboard(id: '${widget.id}'),
                            MileStone(id: '${widget.id}'),
                            ProjectNotes(id: '${widget.id}'),
                            ProjectFile(id: '${widget.id}'),
                            TimeSheet(id: '${widget.id}'),
                            ProjectComment(id: '${widget.id}'),
                          ],
                        ),
                      ),
                    ],
                  ),
          )
        : NoInternetWidget();
  }
}
