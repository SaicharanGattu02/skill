import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../Model/ProjectsModel.dart';
import '../Services/UserApi.dart';
import '../utils/Mywidgets.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Data> projectsData = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    GetProjectsData();
  }

  Future<void> GetProjectsData() async {
    var Res = await Userapi.GetProjectsList();
    setState(() {
      if (Res != null && Res.data != null) {
        projectsData = Res.data ?? [];
        print("projectsData List Get Successfully  ${projectsData[0].name}");
      } else {
        // print("Employee List Failure  ${Res.settings?.message}");
      }
      isLoading = false; // Set loading to false after data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
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
        title: const Text(
          "All Projects",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
            height: 29.05 / 24.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset("assets/Plus square.png", width: 28, height: 28, fit: BoxFit.contain),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/search.png",
                    width: 24,
                    height: 24,
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
            const SizedBox(height: 10),
            Expanded(
              child: isLoading ? _buildShimmerGrid(w) : _buildProjectGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid(double width) {
    return GridView.builder(
      itemCount: 8, // Number of shimmer placeholders
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
              shimmerCircle(48), // Shimmer for the circular image
              const SizedBox(height: 8),
              shimmerText(100,16), // Shimmer for title text
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  shimmerText(50,12), // Shimmer for progress label
                  shimmerText(30,12), // Shimmer for percentage text
                ],
              ),
              const SizedBox(height: 4),
              shimmerLinearProgress(7), // Shimmer for progress indicator
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectGrid() {
    return GridView.builder(
      itemCount: projectsData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final data = projectsData[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xffF7F4FC),
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
                style: const TextStyle(
                  color: Color(0xff4F3A84),
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
                  const Text(
                    "Progress",
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: "Inter",
                    ),
                  ),
                  Text(
                    "${data.totalPercent ?? ""}%",
                    style: const TextStyle(
                      color: Color(0xff000000),
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
        );
      },
    );
  }
}
