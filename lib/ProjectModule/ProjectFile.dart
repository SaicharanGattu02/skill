import 'package:flutter/material.dart';
import '../Model/ProjectFileModel.dart';
import '../Services/UserApi.dart';

class ProjectFile extends StatefulWidget {
  final String id;
  const ProjectFile({super.key, required this.id});

  @override
  State<ProjectFile> createState() => _ProjectFileState();
}

class _ProjectFileState extends State<ProjectFile> {
  void initState() {
    GetFile();
    super.initState();
  }

  List<Data> data = [];
  Future<void> GetFile() async {
    var res = await Userapi.GetProjectFile(widget.id);

    setState(() {
      if (res != null) {
        if (res.data != null) {
          data = res.data ?? [];

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
      body: SingleChildScrollView(
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
                              "Add Files",
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
                  final projectfile = data[index];
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
                            SizedBox(
                              width: w * 0.004,
                            ),
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
                              "assets/download.png",
                              fit: BoxFit.contain,
                              width: w * 0.06,
                              height: w * 0.05,
                              color: Color(0xff8856F4),
                            ),
                            SizedBox(
                              width: w * 0.025,
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
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Color(0xffF5E6FE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                "assets/gallery.png",
                                fit: BoxFit.contain,
                                color: Color(0xffBE63F9),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  projectfile.fileName ?? "",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 21.78 / 15,
                                    color: Color(0xff1D1C1D),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  projectfile.category ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 16 / 14,
                                    color: Color(0xff1D1C1D),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        projectfile.fileUrl ?? "",
                                        fit: BoxFit.contain,
                                        width: 20,
                                        color: Color(0xff8856F4),
                                      ),
                                    ),
                                    SizedBox(
                                      width: w * 0.01,
                                    ),
                                    Text(
                                      projectfile.uploadedBy ?? "",
                                      style: TextStyle(
                                        color: Color(0xff371F41),
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 18.36 / 14,
                                      ),
                                    )
                                  ],
                                ),
                              ],
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
