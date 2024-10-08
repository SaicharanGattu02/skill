import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill/Model/Get_Color_Response.dart';
import 'package:skill/screens/AddTaskScreen.dart';
import 'package:skill/utils/CustomSnackBar.dart';

import '../Model/ToDoListModel.dart';
import '../ProjectModule/UserDetailsModel.dart';
import '../Services/UserApi.dart';

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  final List<Map<String, String>> tasks = [
    {
      'date': 'September 23, 2024',
      'title': 'PRPL Application',
      'subtitle': 'Presentation of new products and cost structure'
    },
    {'date': 'September 24, 2024', 'title': 'Raay Project'},
    {'date': 'September 24, 2024', 'title': 'Dotclinic Project'},
    {
      'date': 'October 5, 2024',
      'title': 'Raay Project',
      'subtitle': 'Presentation of new products and cost structure'
    },
  ];

  List<TODOList> data = [];
  List<TODOList> filteredData = []; // For storing filtered tasks
  TextEditingController _searchController = TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    GetToDoList();
    // GetColorResponse();

    // Initialize filteredData to be the full data initially
    filteredData = data;

    // Listen to changes in the search bar input
    _searchController.addListener(_filterTasks);
  }

  Future<void> GetToDoList() async {
    var res = await Userapi.gettodolistApi();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          data = res.data ?? [];
          filteredData = data; // Initialize the filtered list to the full list
        }
      }
    });
  }

  void _filterTasks() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredData = data.where((task) {
        return (task.labelName?.toLowerCase().contains(query) ?? false) ||
            (task.description?.toLowerCase().contains(query) ?? false) ||
            (task.dateTime?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

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
        title: Row(
          children: [
            Text(
              "Todo",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24.0,
                color: Color(0xffffffff),
                fontWeight: FontWeight.w500,
                height: 29.05 / 24.0,
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(),
                  ),
                );
              },
              child: Container(
                width: w * 0.05,
                height: w * 0.05,
                child: Center(
                  child: Image.asset(
                    "assets/circleadd.png",
                    fit: BoxFit.contain,
                    width: w * 0.093,
                    height: w * 0.093,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/search.png",
                            width: 20,
                            height: 17,
                            fit: BoxFit.contain,
                          ),
                           SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController, // Use the controller for search
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                                hintStyle: const TextStyle(
                                  color: Color(0xff9E7BCA),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontFamily: "Nunito",
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xff141516),
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: "Nunito",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  SizedBox(
                    height: w * 0.09,
                    child: InkWell(
                      onTap: () {
                        // _showAddTaskBottomSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Color(0xff8856F4),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/circleadd.png",
                              fit: BoxFit.contain,
                              width: w * 0.045,
                              height: w * 0.05,
                              color: Color(0xffffffff),
                            ),
                            SizedBox(
                              width: w * 0.01,
                            ),
                            Text(
                              "Add Label",
                              style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  fontFamily: "Inter",
                                  height: 16.94 / 12,
                                  letterSpacing: 0.59),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: w,
              height: h * 0.85,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: filteredData.length,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var tododata = filteredData[index];
                  // Color labelColor = hexToColor(tododata.labelColor ?? "");

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/More-vertical.png",
                              fit: BoxFit.contain,
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 10),
                            ClipOval(
                              child: Container(
                                width: w * 0.045,
                                height: w * 0.045,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    // color: labelColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tododata.labelName ?? "",
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Color(0xff141516),
                                      height: 16.94 / 13,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: w * 0.5,
                                    child: Text(
                                      tododata.description ?? "",
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                        color: Color(0xffB1B5C3),
                                        height: 12.89 / 11,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    tododata.dateTime ?? "",
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      color: Color(0xffB1B5C3),
                                      height: 13.31 / 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0xffF1F1F1),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
