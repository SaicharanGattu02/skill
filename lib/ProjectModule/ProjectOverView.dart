import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Services/UserApi.dart';
import '../utils/Mywidgets.dart';
import '../Model/ProjectOverviewModel.dart';

class OverView extends StatefulWidget {
  final String id;
  const OverView({super.key, required this.id});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  bool isMembersTab = true; // Track which tab is active
  final FocusNode searchFocusNode = FocusNode();
  bool _isSearchFocused = false;
  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = searchFocusNode.hasFocus;
      });
    });
    GetProjectsOverviewData();
  }
  Data? data = Data();
  List<Members> members=[];
  List<PieChartSectionData> pieChartSectionData = [];
  Future<void> GetProjectsOverviewData() async {
    var res = await Userapi.GetProjectsOverviewApi(widget.id);
    setState(() {
      if (res != null && res.data != null) {
        data = res.data;
        members = data?.members ?? [];
        _updatePieChartData();
      }
    });
  }

  void _updatePieChartData() {
    pieChartSectionData = [
      PieChartSectionData(
        value: data?.todoPercent?.toDouble() ?? 0,
        title: '${data?.todoPercent}%',
        color: Color(0xff8856F4),
        radius: 33,
      ),
      PieChartSectionData(
        value: data?.inProgressPercent?.toDouble() ?? 0,
        title: '${data?.inProgressPercent}%',
        color: Color(0xffCAA0F8),
        radius: 25,
      ),
      PieChartSectionData(
        value: data?.inProgressPercent?.toDouble() ?? 0,
        title: '${data?.inProgressPercent}%',
        color: Color(0xffEDDFFC),
        radius: 25,
      ),
    ];
  }


  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              pinned: true,
              expandedHeight: _isSearchFocused
                  ? 0
                  : MediaQuery.of(context).size.height * 0.36,
              automaticallyImplyLeading: false,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16,top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildProjectStatusCard(context),
                      _buildTaskStatusCard(context),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: EdgeInsets.only(left: 16, right: 16,top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18), topLeft: Radius.circular(18))),
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildTabSwitcher(context),
              SizedBox(height: 10),
              Expanded(
                child: isMembersTab
                    ? _buildMembersTab(context)
                    : _buildAcitivityTab(context), // Conditional rendering for Activity Tab
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectStatusCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          Text(
            "Project Status",
            style: TextStyle(
              color: Color(0xff16192C),
              fontWeight: FontWeight.w500,
              fontSize: 18,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 6),
          _buildCircularProgress(),
          SizedBox(height: 12),
          _buildProjectDetails(),
        ],
      ),
    );
  }

  Widget _buildCircularProgress() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF0E5FC),
        shape: BoxShape.circle,
      ),
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(136, 136),
            painter: RoundedProgressPainter(0.75),
          ),
          Text(
            '${(data?.totalPercent??0 * 100).round()}%',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildProjectDetailColumn(
          title: "Start Date",
          value: "${data?.startDate??""}",
          secondTitle: "Total Hours",
          secondValue:"${data?.totalTimeWorked??""}",
        ),
        _buildProjectDetailColumn(
          title: "Deadline",
          value: "${data?.endDate??""}",
          secondTitle: "Client",
          secondValue: "${data?.client??""}",
        ),
      ],
    );
  }

  Widget _buildProjectDetailColumn({
    required String title,
    required String value,
    required String secondTitle,
    required String secondValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
                fontSize: 10,
                color: Color(0xff8A8A8E))),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
                fontSize: 10,
                color: Color(0xff16192C))),
        Text(secondTitle,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
                fontSize: 10,
                color: Color(0xff8A8A8E))),
        Text(secondValue,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
                fontSize: 10,
                color: Color(0xff16192C))),
      ],
    );
  }

  Widget _buildTaskStatusCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Task Status",
            style: TextStyle(
              color: Color(0xff16192C),
              fontWeight: FontWeight.w500,
              fontSize: 18,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: MediaQuery.of(context).size.width * 0.33,
            child: PieChart(
              PieChartData(
                sections: pieChartSectionData,
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildTaskLegend(),
        ],
      ),
    );
  }

  Widget _buildTaskLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLegendItem(Color(0xff8856F4), "To do"),
            SizedBox(width: 10),
            _buildLegendItem(Color(0xffEDDFFC), "Done"),
          ],
        ),
        Row(
          children: [
            _buildLegendItem(Color(0xffCAA0F8), "In Progress"),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 27,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        SizedBox(width: 7),
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
                fontSize: 11,
                color: Colors.black)),
      ],
    );
  }

  Widget _buildTabSwitcher(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isMembersTab = true;
            });
          },
          child: Column(
            children: [
              Text(
                'Members',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      isMembersTab ? FontWeight.w500 : FontWeight.w500,
                  color: isMembersTab ? Color(0xff8856f4) : Color(0xff3c3c43),
                ),
              ),
              if (isMembersTab)
                Container(
                  margin: EdgeInsets.only(top: 4),
                  height: 2,
                  width: MediaQuery.of(context).size.width * 0.3,
                  color: Color(0xff8856f4) ,
                ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isMembersTab = false;
            });
          },
          child: Column(
            children: [
              Text(
                'Activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  isMembersTab ? FontWeight.w500 : FontWeight.w500,
                  color: isMembersTab ? Color(0xff3c3c43) : Color(0xff8856f4),
                ),
              ),
              if (!isMembersTab)
                Container(
                  margin: EdgeInsets.only(top: 4),
                  height: 2,
                  width: MediaQuery.of(context).size.width * 0.3,
                  color: Color(0xff8856f4),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMembersTab(BuildContext context) {
    double w= MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child:  Container(
                  width: w * 0.8,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xfffcfaff),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/search.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Search",
                        style: TextStyle(
                          color: Color(0xff9E7BCA),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontFamily: "Nunito",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  // Add member action
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Color(0xff8856F4), // Background color
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_outline, color: Colors.white), // Plus icon
                      SizedBox(width: 8), // Space between icon and text
                      Text(
                        'Add Member',
                        style: TextStyle(color: Colors.white), // Text color
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Example member count
            itemBuilder: (context, index) {
              return Column(
                children: [
                  MemberCard(
                      name: 'Member $index',
                      profession: 'Profession $index'
                  ),
                  // Add a Divider if it's not the last item
                  if (index < 9) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(height: 10, thickness: 0.5,color: Color(0xffeff0fa),),
                  ),
                ],
              );
            },
          ),
        ),

      ],
    );
  }

  Widget _buildAcitivityTab(BuildContext context) {
    double w= MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Example member count
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ActivityCard(
                      name: 'Member $index',
                      profession: 'Profession $index'
                  ),
                  // Add a Divider if it's not the last item
                  if (index < 9) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(height: 10, thickness: 0.5,color: Color(0xffeff0fa),),
                  ),
                ],
              );
            },
          ),
        ),

      ],
    );
  }

}

