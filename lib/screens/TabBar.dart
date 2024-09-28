import 'package:flutter/material.dart';
import 'package:skill/utils/CustomAppBar.dart';

import 'ProjectOverView.dart';

class MyTabBar extends StatefulWidget {
  final String titile;
  const MyTabBar({super.key, required this.titile});

  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this); // 8 tabs
    _pageController = PageController(); // Controller for PageView

    // Sync TabController with PageView
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
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
      ),
      body: Column(
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
              children:  [
                OverView()
              ],
            ),
          )
        ],
      ),
    );
  }
}
