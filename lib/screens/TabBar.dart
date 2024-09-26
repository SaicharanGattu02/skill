import 'package:flutter/material.dart';

class MyTabBar extends StatefulWidget {
  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> with SingleTickerProviderStateMixin {
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
      appBar: AppBar(
        bottom:

        TabBar(
          padding: EdgeInsets.zero, // Remove padding from TabBar itself
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Color(0xff8856F4), // Custom color for indicator
          indicatorWeight: 2.0, // Custom weight for the indicator
          indicatorPadding: EdgeInsets.zero, // Remove default padding
          labelPadding: EdgeInsets.symmetric(horizontal: 10), // Fine-tune label padding
          labelStyle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 15,
            height: 1.6,
            color: Color(0xff8856F4),
            letterSpacing: 0.15,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _tabController.animateTo(index); // Change the tab when a page is swiped
        },
        children: List.generate(
          8,
              (index) => Center(child: Text('Content of Tab ${index + 1}')),
        ),
      ),
    );
  }
}
