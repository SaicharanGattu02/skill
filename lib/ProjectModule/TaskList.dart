import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill/ProjectModule/TaskForm.dart';
import '../Model/TasklistModel.dart';
import '../Services/UserApi.dart';
import '../utils/Mywidgets.dart';

class TaskList extends StatefulWidget {
  final String id1;
  const TaskList({super.key, required this.id1});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Data> data = [];
  @override
  void initState() {
    super.initState(); // Add this to properly initialize the state
    GetProjectTasks();
  }

  Future<void> GetProjectTasks() async {
    var Res = await Userapi.GetTask(widget.id1);
    setState(() {
      if (Res != null) {
        if (Res.data != null) {
          data = Res.data ?? [];
        } else {
          print("Task Failure  ${Res.settings?.message}");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: w * 0.63,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
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
                  Spacer(),
                  SizedBox(height: w*0.09,
                    child: InkWell(onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context) => TaskForm(projectId: widget.id1),));
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
              ListView.builder(
                shrinkWrap: true,
                physics:
                    NeverScrollableScrollPhysics(), // Ensures the list doesn't scroll inside the scroll view
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final task = data[index];
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
                                  borderRadius: BorderRadius.circular(100),
                                  color: Color(0xffFFAB00).withOpacity(0.10)),
                              child: Text(
                                task.status??"",
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
                            Image.asset(
                              "assets/delate.png",
                              fit: BoxFit.contain,
                              width: w * 0.04,
                              height: w * 0.05,
                              color: Color(0xffDE350B),
                            ),
                            SizedBox(
                              width: w * 0.04,
                            ),
                            Image.asset(
                              "assets/edit.png",
                              fit: BoxFit.contain,
                              width: w * 0.06,
                              height: w * 0.05,
                              color: Color(0xff8856F4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
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
                                padding: const EdgeInsets.only(right: 4.0),
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
