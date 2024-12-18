import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill/utils/CustomSnackBar.dart';
import '../Providers/ThemeProvider.dart';
import '../Services/UserApi.dart';
import '../utils/Mywidgets.dart';
import '../Model/ProjectOverviewModel.dart';
import '../Model/ProjectActivityModel.dart';
import '../utils/Preferances.dart';
import '../utils/ShakeWidget.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class OverView extends StatefulWidget {
  final String id;
  const OverView({super.key, required this.id});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  bool isMembersTab = true; // Track which tab is active
  final TextEditingController _searchController = TextEditingController();

  bool _loading = true;
  final spinkit = Spinkits();
  String my_employeeID = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _searchController.text == "";
    });
    filteredMembers = List.from(members); // Start with all members
    _searchController.addListener(filterMembers); // Add listener
    GetProjectsOverviewData();
    GetProjectsActivityData();
  }

  void filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredMembers = members.where((member) {
        return member.fullName?.toLowerCase().contains(query) ?? false;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchController.removeListener(filterMembers);
    super.dispose();
  }

  Data? data = Data();
  List<Members> members = [];
  List<Members> filteredMembers = [];

  List<PieChartSectionData> pieChartSectionData = [];
  Future<void> GetProjectsOverviewData() async {
    my_employeeID = await PreferenceService().getString("my_employeeID") ?? "";
    print("my_employeeID:${my_employeeID}");
    var res = await Userapi.GetProjectsOverviewApi(widget.id);
    setState(() {
      if (res != null && res.data != null) {
        if (res.settings?.success == 1) {
          _loading = false;
          data = res.data;
          members = data?.members ?? [];
          filteredMembers = data?.members ?? [];
          _updatePieChartData();
        } else {
          _loading = false;
          CustomSnackBar.show(context, res.settings?.message ?? "");
        }
      }
    });
  }

  List<Activity> activitydata = [];
  Future<void> GetProjectsActivityData() async {
    var res = await Userapi.GetProjectsActivityApi(widget.id);
    setState(() {
      if (res != null && res.data != null) {
        activitydata = res.data ?? [];
      }
    });
  }

  double _parseToDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0; // Safely parse String to double
    } else if (value is int) {
      return value.toDouble(); // Convert int to double
    }
    return 0.0; // Default to 0.0 if it's neither a String nor an int
  }

  void _updatePieChartData() {
    final themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    pieChartSectionData = [
      PieChartSectionData(
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        value: (_parseToDouble(data?.todoPercent) ?? 0)
            .toInt()
            .toDouble(), // Convert to double
        title:
            '${((_parseToDouble(data?.todoPercent) ?? 0)).round()}%', // Display as an integer
        color: themeProvider.primaryColor,
        radius: 25,
      ),
      // In-progress section
      PieChartSectionData(
        titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        value: _parseToDouble(data?.inProgressPercent) ?? 0,
        title:
            '${data?.inProgressPercent}%', // Title with in-progress percentage
        color: Color(0xffCAA0F8),
        radius: 25,
      ),
      // Completed section
      PieChartSectionData(
        titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        value: (_parseToDouble(data?.totalPercent) ?? 0).toInt().toDouble(),
        title:
            '${((_parseToDouble(data?.totalPercent) ?? 0)).round()}%', // Display as an integer
        color: Color(0xffEDDFFC),
        radius: 25,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold( backgroundColor: themeProvider.scaffoldBackgroundColor,
        body: _loading
            ? _buildShimmerGrid(w)
            : NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      pinned: true,
                      expandedHeight:
                          MediaQuery.of(context).size.height * 0.378,
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16),
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
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: BoxDecoration(
                      color: themeProvider.themeData == lightTheme
                          ? Color(0xFFF0E5FC)
                          : AppColors.darkmodeContainerColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(18),
                          topLeft: Radius.circular(18))),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      _buildTabSwitcher(context),
                      SizedBox(height: 15),
                      Expanded(
                        child: isMembersTab
                            ? _buildMembersTab(context)
                            : _buildAcitivityTab(
                                context), // Conditional rendering for Activity Tab
                      ),
                    ],
                  ),
                ),
              ));
  }

  Widget _buildShimmerGrid(double width) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShimmerCard(),
                _buildShimmerCard(),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  topLeft: Radius.circular(18),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      shimmerText(130, 20, context),
                      shimmerText(130, 20, context),
                    ],
                  ),
                  const SizedBox(height: 15),
                  shimmerText(350, 20, context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return InkResponse(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.black
                                    : Color(0xffF7F4FC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  shimmerCircle(32, context),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        shimmerText(100, 16, context),
                                        const SizedBox(height: 5),
                                        shimmerText(160, 12, context),
                                      ],
                                    ),
                                  ),
                                  shimmerText(50, 12, context),
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
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          shimmerText(150, 20, context),
          const SizedBox(height: 15),
          shimmerCircle(120, context),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerColumn(),
              _buildShimmerColumn(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerColumn() {
    return Column(
      children: [
        shimmerText(60, 10, context),
        const SizedBox(height: 5),
        shimmerText(60, 10, context),
        const SizedBox(height: 5),
        shimmerText(60, 10, context),
        const SizedBox(height: 5),
        shimmerText(60, 10, context),
      ],
    );
  }

  Widget _buildProjectStatusCard(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: themeProvider.themeData == lightTheme
            ? Color(0xffffffff)
            : AppColors.darkmodeContainerColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          Text(
            "Project Status",
            style: TextStyle(
              color: themeProvider.themeData == lightTheme
                  ? Color(0xff16192C)
                  : themeProvider.textColor,
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.themeData == lightTheme
            ? Color(0xFFF0E5FC)
            : AppColors.darkmodeContainerColor,
        shape: BoxShape.circle,
      ),
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(136, 136),
            painter: RoundedProgressPainter(
              // Ensure the value is parsed as a double, multiplied by 100, and converted to a double
              (_parseToDouble(data?.totalPercent) ?? 0),context
            ),
          ),
          Text(
            // Parse the value, multiply by 100, then round and display as an integer
            '${((_parseToDouble(data?.totalPercent) ?? 0)).round()}%',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
                color: themeProvider.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDetails() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildProjectDetailColumn(
          title: "Start Date",
          value: "${data?.startDate ?? ""}",
          secondTitle: "Total Hours",
          secondValue: "${data?.totalTimeWorked ?? ""}",
        ),
        _buildProjectDetailColumn(
          title: "Deadline",
          value: "${data?.endDate ?? ""}",
          secondTitle: "Client",
          secondValue: "${data?.client ?? ""}",
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: "Inter",
              fontSize: 10,
              color: themeProvider.themeData == lightTheme
                  ? Color(0xff8A8A8E)
                  : themeProvider.textColor,
            )),
        Text(value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
              fontSize: 10,
              color: themeProvider.themeData == lightTheme
                  ? Color(0xff16192C)
                  : themeProvider.textColor,
            )),
        SizedBox(
          height: 2,
        ),
        Text(secondTitle,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: "Inter",
              fontSize: 10,
              color: themeProvider.themeData == lightTheme
                  ? Color(0xff8A8A8E)
                  : themeProvider.textColor,
            )),
        Text(secondValue,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
              fontSize: 10,
              color: themeProvider.themeData == lightTheme
                  ? Color(0xff16192C)
                  : themeProvider.textColor,
            )),
      ],
    );
  }

  Widget _buildTaskStatusCard(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: themeProvider.themeData == lightTheme
            ? Color(0xffffffff)
            : AppColors.darkmodeContainerColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Task Status",
            style: TextStyle(
              color: themeProvider.themeData == lightTheme
                  ? Color(0xff16192C)
                  : themeProvider.textColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: MediaQuery.of(context).size.width * 0.33,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: pieChartSectionData,
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
                // PieChart(
                //   PieChartData(
                //     sections: pieChartSectionData,
                //     borderData: FlBorderData(show: false),
                //     sectionsSpace: 2,
                //     // centerSpaceRadius: 40, // Center space radius for the pie chart
                //   ),
                // ),
                // // Title (Percentage) inside a black container
                // Positioned(
                //   left: 0,
                //   child: Container(
                //     width: MediaQuery.of(context).size.width * 0.12,
                //     height: MediaQuery.of(context).size.height * 0.06,
                //     decoration: BoxDecoration(
                //       color: Color(0xffECEAF8),  // Background color for the title container
                //       borderRadius: BorderRadius.circular(100),
                //     ),
                //     child: Center(
                //       child: Text(
                //      '${data?.todoPercent}%',  // Display percentage title for the first section
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontWeight: FontWeight.w600,
                //           fontSize: 14,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // // Title (Percentage) for the second section (inProgressPercent) inside a container
                // Positioned(
                //   top: MediaQuery.of(context).size.height * 0.05,  // Adjust position for second title
                //   right: MediaQuery.of(context).size.width * 0.10, // Adjusted right position
                //   child: Container(
                //     width: MediaQuery.of(context).size.width * 0.12,
                //     height: MediaQuery.of(context).size.height * 0.06,
                //     decoration: BoxDecoration(
                //       color: Color(0xffECEAF8),  // Background color for the title container
                //       borderRadius: BorderRadius.circular(100),
                //     ),
                //     child: Center(
                //       child: Text(
                //         '${data?.inProgressPercent}%',
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontWeight: FontWeight.w600,
                //           fontSize: 14,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // // Title (Percentage) for the third section (inProgressPercent) inside a container
                // Positioned(
                //   right: 0,
                //   child: Container(
                //     width: MediaQuery.of(context).size.width * 0.12,
                //     height: MediaQuery.of(context).size.height * 0.06,
                //     decoration: BoxDecoration(
                //       color: Color(0xffECEAF8),  // Background color for the title container
                //       borderRadius: BorderRadius.circular(100),
                //     ),
                //     child: Center(
                //       child: Text(
                //         '${data?.totalPercent}%',
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontWeight: FontWeight.w600,
                //           fontSize: 14,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _buildTaskLegend(),
        ],
      ),
    );
  }

  Widget _buildTaskLegend() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Row(
          children: [
            _buildLegendItem(themeProvider.primaryColor, "To do"),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Row(
          children: [
            _buildLegendItem(Color(0xffCAA0F8), "In Progress"),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Row(
          children: [
            _buildLegendItem(Color(0xffEDDFFC), "Done"),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
                fontSize: 11,
                color: themeProvider.textColor)),
      ],
    );
  }

  Widget _buildTabSwitcher(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                    color: isMembersTab
                        ? themeProvider.themeData == lightTheme
                            ? themeProvider.primaryColor
                            : themeProvider.textColor
                        : themeProvider.themeData == lightTheme
                            ? Color(0xff3c3c43)
                            : themeProvider.textColor.withOpacity(0.7)),
              ),
              if (isMembersTab)
                Container(
                    margin: EdgeInsets.only(top: 4),
                    height: 2,
                    width: MediaQuery.of(context).size.width * 0.3,
                    color: themeProvider.themeData == lightTheme
                        ? themeProvider.primaryColor
                        : themeProvider.textColor),
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
                    color: isMembersTab
                        ? themeProvider.themeData == lightTheme
                            ? themeProvider.primaryColor
                            : themeProvider.textColor.withOpacity(0.7)
                        : themeProvider.themeData == lightTheme
                            ? Color(0xff3c3c43)
                            : themeProvider.textColor),
              ),
              if (!isMembersTab)
                Container(
                    margin: EdgeInsets.only(top: 4),
                    height: 2,
                    width: MediaQuery.of(context).size.width * 0.3,
                    color: themeProvider.themeData == lightTheme
                        ? themeProvider.primaryColor
                        : themeProvider.textColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMembersTab(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: w,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xff9E7BCA).withOpacity(0.1),
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

          // Row(
          //   children: [
          //
          //     Expanded(
          //       child: Container(
          //         width: w * 0.8,
          //         padding:
          //             const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          //         decoration: BoxDecoration(
          //           color: const Color(0xfffcfaff),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         child: Row(
          //           children: [
          //             Image.asset(
          //               "assets/search.png",
          //               width: 20,
          //               height: 20,
          //               fit: BoxFit.contain,
          //             ),
          //             const SizedBox(width: 10),
          //             const Text(
          //               "Search",
          //               style: TextStyle(
          //                 color: Color(0xff9E7BCA),
          //                 fontWeight: FontWeight.w400,
          //                 fontSize: 16,
          //                 fontFamily: "Nunito",
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //     // SizedBox(width: 10),
          //     // GestureDetector(
          //     //   onTap: () {
          //     //     // _showBottomSheet();
          //     //   },
          //     //   child: Container(
          //     //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          //     //     decoration: BoxDecoration(
          //     //       color: Color(0xff8856F4), // Background color
          //     //       borderRadius: BorderRadius.circular(8), // Rounded corners
          //     //     ),
          //     //     child: Row(
          //     //       mainAxisSize: MainAxisSize.min,
          //     //       children: [
          //     //         Icon(Icons.add_circle_outline,
          //     //             color: Colors.white), // Plus icon
          //     //         SizedBox(width: 8), // Space between icon and text
          //     //         Text(
          //     //           'Add Member',
          //     //           style: TextStyle(color: Colors.white), // Text color
          //     //         ),
          //     //       ],
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredMembers.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  MemberCard(
                    name: filteredMembers[index].fullName ?? "",
                    profile_image: filteredMembers[index].image ?? "",
                    id: filteredMembers[index].id ?? "",
                  ),
                  if (index < filteredMembers.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        height: 10,
                        thickness: 0.5,
                        color: Color(0xffeff0fa),
                      ),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: activitydata.length,
            itemBuilder: (context, index) {
              String isoDate1 = activitydata[index].createdTime ?? "";
              String isoDate = activitydata[index].createdTime ?? "";
              String formattedDate = DateTimeFormatter.format(isoDate,
                  includeDate: true, includeTime: false); // Date only

              String formattedTime = DateTimeFormatter.format(isoDate1,
                  includeDate: false, includeTime: true);
              return Column(
                children: [
                  ActivityCard(
                    name: activitydata[index].userName ?? "",
                    user_img: activitydata[index].userImage ?? "",
                    time: "${formattedTime} | ${formattedDate}",
                    action: activitydata[index].action ?? "",
                    desc: activitydata[index].description ?? "",
                    project_name: activitydata[index].projectName ?? "",
                  ),
                  // Add a Divider if it's not the last item
                  if (index < activitydata.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        height: 10,
                        thickness: 0.5,
                        color: Color(0xffeff0fa),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // void _showBottomSheet() {
  //   var h = MediaQuery.of(context).size.height;
  //   var w = MediaQuery.of(context).size.width;
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //             padding: const EdgeInsets.all(16),
  //             height: h * 0.3,
  //             child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Title and close button
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         "Add Member",
  //                         style: TextStyle(
  //                           color: Color(0xff1C1D22),
  //                           fontSize: 18.0,
  //                           fontWeight: FontWeight.w500,
  //                           height: 18 / 18,
  //                           fontFamily: 'Inter',
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 24,
  //                         height: 24,
  //                         padding: EdgeInsets.all(7),
  //                         decoration: BoxDecoration(
  //                           color: Color(0xffE5E5E5),
  //                           borderRadius: BorderRadius.circular(100),
  //                         ),
  //                         child: Image.asset(
  //                           "assets/crossblue.png",
  //                           fit: BoxFit.contain,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 24),
  //
  //
  //                 ]));
  //       });
  // }

  // static Widget _label({required String text}) {
  //   return Text(
  //     text,
  //     style: TextStyle(
  //       color: Color(0xff141516),
  //       fontSize: 14,
  //     ),
  //   );
  // }
  //
  // Widget _buildTextFormField(
  //     {required TextEditingController controller,
  //     required FocusNode focusNode,
  //     bool obscureText = false,
  //     required String hintText,
  //     required String validationMessage,
  //     TextInputType keyboardType = TextInputType.text,
  //     Widget? prefixicon,
  //     Widget? suffixicon}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         height: MediaQuery.of(context).size.height * 0.050,
  //         child: TextFormField(
  //           controller: controller,
  //           focusNode: focusNode,
  //           keyboardType: keyboardType,
  //           obscureText: obscureText,
  //           cursorColor: Color(0xff8856F4),
  //           decoration: InputDecoration(
  //             hintText: hintText,
  //             // prefixIcon: Container(
  //             //     width: 21,
  //             //     height: 21,
  //             //     padding: EdgeInsets.only(top: 10, bottom: 10, left: 6),
  //             //     child: prefixicon),
  //             suffixIcon: suffixicon,
  //             hintStyle: const TextStyle(
  //               fontSize: 14,
  //               letterSpacing: 0,
  //               height: 19.36 / 14,
  //               color: Color(0xffAFAFAF),
  //               fontFamily: 'Inter',
  //               fontWeight: FontWeight.w400,
  //             ),
  //             filled: true,
  //             fillColor: const Color(0xffFCFAFF),
  //             enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(7),
  //               borderSide:
  //                   const BorderSide(width: 1, color: Color(0xffd0cbdb)),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(7),
  //               borderSide:
  //                   const BorderSide(width: 1, color: Color(0xffd0cbdb)),
  //             ),
  //             errorBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(7),
  //               borderSide:
  //                   const BorderSide(width: 1, color: Color(0xffd0cbdb)),
  //             ),
  //             focusedErrorBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(7),
  //               borderSide:
  //                   const BorderSide(width: 1, color: Color(0xffd0cbdb)),
  //             ),
  //           ),
  //         ),
  //       ),
  //       if (validationMessage.isNotEmpty) ...[
  //         Container(
  //           alignment: Alignment.topLeft,
  //           margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
  //           width: MediaQuery.of(context).size.width * 0.6,
  //           child: ShakeWidget(
  //             key: Key("value"),
  //             duration: Duration(milliseconds: 700),
  //             child: Text(
  //               validationMessage,
  //               style: TextStyle(
  //                 fontFamily: "Poppins",
  //                 fontSize: 12,
  //                 color: Colors.red,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ] else ...[
  //         SizedBox(height: 15),
  //       ]
  //     ],
  //   );
  // }
}
