import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skill/ProjectModule/TabBar.dart';
import 'package:skill/utils/CustomAppBar.dart';
import 'package:skill/utils/CustomSnackBar.dart';
import '../Model/ProjectsModel.dart';
import '../Providers/ThemeProvider.dart';
import '../Services/UserApi.dart';
import '../utils/Mywidgets.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {

  List<Data> projectsData = [];
  List<Data> filteredRooms = [];
  bool isLoading = true;
  bool _loading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredRooms = projectsData.where((room) {
        String otherUser = room.name?.toLowerCase() ?? '';
        return otherUser.contains(query);
      }).toList();
      print('Filtered rooms: ${filteredRooms.length}'); // Debug log
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    GetProjectsData();
  }

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime(2101), // Maximum date
    );
    if (pickedDate != null) {
      controller.text =
          DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
    }
  }


  bool isSelected = false;

  Future<void> GetProjectsData() async {
    var Res = await Userapi.GetProjectsList();
    setState(() {
      if (Res != null && Res.data != null) {
        _loading = false;
        if (Res.settings?.success == 1) {
          isLoading = false;
          projectsData = Res.data ?? [];
          filteredRooms = projectsData; // Initialize filteredRooms with all projects
        } else {
          isLoading = false;
        }
      } else {
        isLoading = false; // Handle empty or null response
      }
    });
  }

final spinkit=Spinkits();


  Future<bool> willPop() async {
    Navigator.pop(context,true);
    return false;

  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        backgroundColor: themeProvider.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'All Projects',
          actions: [Container()],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                width: w,
                // height: h * 0.043,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                  decoration: BoxDecoration(
                    color: themeProvider.themeData==lightTheme? Color(0xffffffff) : AppColors.darkmodeContainerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                  Row(
                    children: [
                      Image.asset(
                        "assets/search.png",
                        width: 20,
                        height: 17,
                        color:themeProvider.textColor,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: themeProvider.textColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontFamily: "Nunito",
                            ),
                          ),
                          style: TextStyle(
                            color:themeProvider.textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            decorationColor: Color(0xff9E7BCA),
                            fontFamily: "Nunito",
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _loading?_buildShimmerGrid(w):
                filteredRooms.isEmpty
                    ? _buildEmptyPlaceholder()
                    : _buildProjectGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildShimmerGrid(double width) {
    return GridView.builder(
      itemCount: 4, // Number of shimmer placeholders
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
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
              shimmerCircle(48,context), // Shimmer for the circular image
              const SizedBox(height: 8),
              shimmerText(100, 16,context), // Shimmer for title text
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  shimmerText(50, 12,context), // Shimmer for progress label
                  shimmerText(30, 12,context), // Shimmer for percentage text
                ],
              ),
              const SizedBox(height: 4),
              shimmerLinearProgress(7,context), // Shimmer for progress indicator
            ],
          ),
        );
      },
    );
  }
  Widget _buildProjectGrid() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // Check if filteredRooms is empty to determine if we need to show a message
    if (filteredRooms.isEmpty) {
      return Center(
        child: Text(
          'No results found.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }





    return GridView.builder(
      itemCount: filteredRooms.length, // Use filteredRooms here
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final data = filteredRooms[index]; // Use filteredRooms here

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyTabBar(
                  titile: '${data.name ?? ""}',
                  id: '${data.id}',
                ),
              ),
            );
            print('idd>>${data.id}');
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeProvider.themeData==lightTheme? Color(0xffffffff) : AppColors.darkmodeContainerColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.network(
                    data.icon ?? "",
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.name ?? "",
                  style: TextStyle(
                    color: themeProvider.themeData==lightTheme? Color(0xff4F3A84) : themeProvider.textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 19.36 / 16,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Nunito",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      "Progress",
                      style: TextStyle(
                        color:themeProvider.textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        fontFamily: "Inter",
                      ),
                    ),
                    Text(
                      "${data.totalPercent ?? ""}%",
                      style: TextStyle(
                        color:themeProvider.textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: (data.totalPercent?.toDouble() ?? 0) / 100.0,
                  minHeight: 7,
                  backgroundColor: const Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xff2FB035),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/nodata2.png',
            height: 150,
            width: 150,
          ), // Add your placeholder image
          SizedBox(height: 16),
          Text(
            'No projects found.',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xff9E7BCA),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

