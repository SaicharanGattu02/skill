import 'package:flutter/material.dart';
import 'package:skill/ProjectModule/MileStone.dart';
import 'package:skill/ProjectModule/ProjectComment.dart';
import 'package:skill/ProjectModule/ProjectFile.dart';
import 'package:skill/ProjectModule/ProjectTimeSheet.dart';
import 'package:skill/ProjectModule/Projects.dart';
import 'package:skill/ProjectModule/TaskKanBan.dart';
import 'package:skill/ProjectModule/TaskList.dart';
import 'package:skill/screens/Comments.dart';
import 'package:skill/utils/CustomAppBar.dart';

import 'ProjectNotes.dart';
import 'ProjectOverView.dart';

class MyTabBar extends StatefulWidget {
  final String titile;
  final String id;
  const MyTabBar({super.key, required this.titile, required this.id});

  @override
  _MyTabBarState createState() => _MyTabBarState();
}
bool _loading =true;
class _MyTabBarState extends State<MyTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _selectedTabIndex = 0;

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      if (_selectedTabIndex != 3)
                        InkWell(
                          onTap: () {},
                          child: Image.asset(
                            "assets/filter.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                        ),
                      SizedBox(width: 16),
                    ],
                  )
                ]
              : null),
      body:
      _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
      Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Color(0xffffffff)),
            child: TabBar(
              dividerColor: Colors.transparent,
              padding: EdgeInsets.zero, // Remove padding from TabBar itself
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Color(0xff8856F4), // Custom color for indicator
              indicatorWeight: 1.0,
              // indicatorPadding: EdgeInsets.zero,
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
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
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Overview'),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Task List'),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Task Kanban'),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Milestones'),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Notes'),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Files'),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Timesheets'),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Comments'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _tabController.animateTo(index); // Sync TabBar with PageView
              },
              children: [
                OverView(id:widget.id,),
                TaskList(id1: '${widget.id}',),
                TaskKanBan(id: '${widget.id}',),
                MileStone(id: '${widget.id}',),
                ProjectNotes(id: '${widget.id}',),
                ProjectFile(id: '${widget.id}',),
                TimeSheet(id: '${widget.id}',),
                ProjectComment(id: '${widget.id}',),
              ],
            ),
          )
        ],
      ),
    );
  }
}
