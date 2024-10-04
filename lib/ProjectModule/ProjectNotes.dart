import 'package:flutter/material.dart';
import '../Model/ProjectNoteModel.dart';
import '../Services/UserApi.dart';

class ProjectNotes extends StatefulWidget {
  final String id;
  const ProjectNotes({super.key, required this.id});

  @override
  State<ProjectNotes> createState() => _ProjectNotesState();
}
bool _loading =true;
class _ProjectNotesState extends State<ProjectNotes> {
  @override
  void initState() {
    GetNote();
    super.initState();
  }

  List<Data> data =[];
  Future<void> GetNote() async {
    var res = await Userapi.GetProjectNote(widget.id);

    setState(() {
      if (res != null) {
        _loading=false;
        if (res.data != null) {
          data=res.data??[];

          print("sucsesss");
        } else {
          print("Task Failure  ${res.settings?.message}");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffEFE2FF).withOpacity(0.1),
      body:
      _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: w * 0.61,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
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
                  Spacer(),
                  SizedBox(
                    height: w * 0.09,
                    child: InkWell(
                      onTap: () {
                        // showModalBottomSheet(
                        //   context: context,
                        //   isScrollControlled: true,
                        //   // isDismissible: false,
                        //
                        //   builder: (BuildContext context) {
                        //     return _bottomSheet(context);
                        //   },
                        // );
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
                              "Add Notes",
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
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final note = data[index];
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
                            Image.asset(
                              "assets/calendar.png",
                              fit: BoxFit.contain,
                              width: w * 0.06,
                              height: w * 0.05,
                              color: Color(0xff6C848F),
                            ),
                            SizedBox(width: w*0.004,),
                            Text(
                              // note.createdTime?? "",
                              "01/01/0000",
                              style: TextStyle(
                                color: const Color(0xff1D1C1D),
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                height: 19.41 / 15,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: "Inter",
                              ),
                            ),
                            Spacer(),
                            Image.asset(
                              "assets/edit.png",
                              fit: BoxFit.contain,
                              width: w * 0.06,
                              height: w * 0.05,
                              color: Color(0xff8856F4),
                            ),
                            SizedBox(
                              width: w * 0.02,
                            ),
                            Image.asset(
                              "assets/eye.png",
                              fit: BoxFit.contain,
                              width: w * 0.06,
                              height: w * 0.05,
                              color: Color(0xff8856F4),
                            ),
                            SizedBox(
                              width: w * 0.02,
                            ),
                            Image.asset(
                              "assets/download.png",
                              fit: BoxFit.contain,
                              width: w * 0.06,
                              height: w * 0.05,
                              color: Color(0xff8856F4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          note.title ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            height: 16 / 18,
                            color: Color(0xff1D1C1D),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          note.description ?? "",
                          style: const TextStyle(
                            fontSize: 15,
                            height: 18.15 / 15,
                            color: Color(0xff6C848F),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Remove",
                          style: TextStyle(
                            color: Color(0xff8856F4),
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 19.36 / 15,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff8856F4),
                          ),
                        )
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
