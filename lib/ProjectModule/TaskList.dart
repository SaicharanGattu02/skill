import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill/ProjectModule/TaskForm.dart';
import '../Model/TasklistModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';

class TaskList extends StatefulWidget {
  final String id1;
  const TaskList({super.key, required this.id1});

  @override
  State<TaskList> createState() => _TaskListState();

}

class _TaskListState extends State<TaskList> {

  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();
  List<Data> data = []; // Original list of Data objects
  List<Data> filteredData = []; // Filtered list for search

  @override
  void initState() {
    super.initState(); // Add this to properly initialize the state
    GetProjectTasks();
    // Initialize filteredData with all data
    filteredData = List.from(data);
    _searchController.addListener(filterData); // Add listener for search
    // Simulate fetching data (you can replace this with your API call)
  }


  void filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredData = data.where((item) {
        return (item.title?.toLowerCase().contains(query) ?? false) ||
            (item.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(filterData); // Remove listener
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  Future<void> GetProjectTasks() async {
    var Res = await Userapi.GetTask(widget.id1);
    setState(() {
      if (Res?.data != null) {
        if (Res?.settings?.success == 1) {
          data = Res?.data ?? [];
          filteredData = Res?.data ?? [];
          _loading=false;
        } else {
          _loading=false;
          CustomSnackBar.show(context,Res?.settings?.message??"");
        }
      } else {
        print("Task Failure  ${Res?.settings?.message}");
      }
    });
  }

  Future<void> DelateTask(String id) async {
    var data = await Userapi.ProjectDelateTask(id);
    setState(() {
      if (data != null) {
        if (data.settings?.success == 1) {
          GetProjectTasks();
          _loading=true;
          CustomSnackBar.show(context, "${data.settings?.message}");
        } else {
          CustomSnackBar.show(context, "${data.settings?.message}");
        }
      } else {
        CustomSnackBar.show(context, "${data?.settings?.message}");
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      body:
      _loading
          ? Center(
              child: CircularProgressIndicator(
              color: Color(0xff8856F4),
            ))
          :
        SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: w * 0.63,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                          Row(
                            children: [
                              Image.asset(
                                "assets/search.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 10),

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
                        Spacer(),
                        SizedBox(
                          height: w * 0.09,
                          child: InkWell(
                            onTap: () async {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskForm(title: 'Add Task',projectId: widget.id1,taskid: '',),
                                  ));
                              if (res == true) {
                                setState(() {
                                  GetProjectTasks();
                                });
                              }
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
                                    "Add Task",
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
                    SizedBox(height: 8),
                    filteredData.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*0.24,),
                          Image.asset(
                            'assets/nodata1.png', // Make sure to use the correct image path
                            width:
                            150, // Adjust the size according to your design
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No Data Found",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontFamily: "Inter",
                            ),
                          ),
                        ],
                      ),
                    )
                        :
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // Ensures the list doesn't scroll inside the scroll view
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final task = filteredData[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 1),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Color(0xffFFAB00)
                                            .withOpacity(0.10)),
                                    child: Text(
                                      task.status ?? "",
                                      style: TextStyle(
                                        color: const Color(0xffFFAB00),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        height: 19.41 / 12,
                                        letterSpacing: 0.14,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell( onTap:(){
                                    DelateTask(task.id??"");

                        },
                                    child: Image.asset(
                                      "assets/delate.png",
                                      fit: BoxFit.contain,
                                      width: w * 0.04,
                                      height: w * 0.05,
                                      color: Color(0xffDE350B),
                                    ),
                                  ),
                                  SizedBox(
                                    width: w * 0.04,
                                  ),
                                  InkWell(onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskForm(title:'Edit Task',projectId:widget.id1,taskid:task.id??"")));
                             
                                  },
                                    child: Container(
                                      child: Image.asset(
                                        "assets/edit.png",
                                        fit: BoxFit.contain,
                                        width: w * 0.06,
                                        height: w * 0.05,
                                        color: Color(0xff8856F4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height: 6),
                              Text(
                                task.title ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff1D1C1D),
                                  height: 21 / 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                task.description ?? "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 16 / 12,
                                  color: Color(0xff787486),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  // Adding the images before the collaborators text
                                  if (task.assignedToImage != null)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: ClipOval(
                                        child: Image.network(
                                          // task.assignedToImage ?? "", // Network image
                                          task.assignedToImage.toString() ?? "",
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "+6 Collaborators",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff64748B),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Start Date: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff64748B),
                                    ),
                                  ),
                                  Text(
                                    task.startDate ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff64748B),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "End Date: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff64748B),
                                    ),
                                  ),
                                  Text(
                                    task.endDate ?? "25/09/2024",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
