import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Model/GetCatagoryModel.dart';
import '../Model/GetFileModel.dart';
import '../Model/ProjectFileModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
import 'package:path/path.dart' as p;
import '../utils/ShakeWidget.dart';

class ProjectFile extends StatefulWidget {
  final String id;
  const ProjectFile({super.key, required this.id});

  @override
  State<ProjectFile> createState() => _ProjectFileState();
}

class _ProjectFileState extends State<ProjectFile> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();
  final FocusNode _focusNodetitle = FocusNode();

  String _validateCategory = "";
  String _validateDescription = "";
  String _validatefile = "";
  String filename = "";
  String _validatename = "";
  XFile? _imageFile;
  File? filepath;
  bool _isLoading = false;
  final spinkit=Spinkits();
  bool isFilesSelected = true;

  String categoryID = "";



  @override
  void initState() {
    super.initState();
    GetFile();
    GetCatagory();
    filteredRooms = List.from(data);
    filteredRooms2 = List.from(catagory);
    _searchController.addListener(_onSearchChanged);
    _searchController2.addListener(_onSearchChanged2);
  }



  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchController2.removeListener(_onSearchChanged2);
    _searchController2.dispose();
    super.dispose();
  }

  List<Data> data = [];
  List<Data> filteredRooms = [];
  List<Catagory> catagory = [];
  List<Catagory> filteredRooms2 = [];

  // Search listener function to filter the list
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      // Filter the rooms based on title or ID
      filteredRooms = data.where((room) {
        String id = room.category?.toLowerCase() ?? '';
        return id.contains(query);
      }).toList();
    });
  }
  void _onSearchChanged2() {
    String query = _searchController2.text.toLowerCase();
    setState(() {
      // Filter the rooms based on title or ID
      filteredRooms2 = catagory.where((room) {
        String title = room.name?.toLowerCase() ?? '';
        return title.contains(query);
      }).toList();
    });
  }



  Future<void> GetFile() async {
    var res = await Userapi.GetProjectFile(widget.id);
    setState(() {
      if (res != null) {
        if(res.settings?.success==1){
          _isLoading = false;
          data = res.data ?? [];
          filteredRooms = data;  // Initially, show all rooms
        }else{
          _isLoading = false;
          CustomSnackBar.show(context,res.settings?.message??"");
        }
      }
      });
  }

  Future<void> PostFiles(String editid) async {
    var res;
    if (editid != "") {

      res = await Userapi.putProjectFile(editid, categoryID,
          File(_imageFile!.path), _descriptionController.text);
      print("putProjectFile>>${res}");
    } else {
      res = await Userapi.postProjectFile(widget.id, categoryID,
          File(_imageFile!.path), _descriptionController.text);
    }

    print("filee>${File(_imageFile!.path)}");
    setState(() {

    if (res != null) {
      if (res.settings?.success == 1) {
            _isLoading=false;
            Navigator.pop(context, true);
            CustomSnackBar.show(context, "${res.settings?.message}");
            GetFile();
      }
      else {
        CustomSnackBar.show(context, "${res.settings?.message}");
      }
    } else {}
    });
  }

  Future<void> PostCategory(String id) async {
    var res;

    if (id != "") {
      res = await Userapi.PutProjectCategory(_nameController.text, id);
    } else {
      res = await Userapi.PostProjectCategory(_nameController.text, widget.id);
    }

    if (res != null) {
      if (res.settings?.success == 1) {

        Navigator.pop(context, true);
        CustomSnackBar.show(context, "${res.settings?.message}");
        GetCatagory();
      } else {
        CustomSnackBar.show(context, "${res.settings?.message}");
      }
    } else {}
  }

  // List<Catagory> catagory = [];
  Future<void> GetCatagory() async {
    print("hiii");
    var res = await Userapi.GetProjectCatagory(widget.id);
    setState(() {
      if (res != null) {
        _isLoading = false;
        if (res.catagory != null) {
          catagory = res.catagory ?? [];
          filteredRooms2 =  res.catagory ?? [];
          print("sucsesss");
        } else {
          print("Task Failure  ${res.settings?.message}");
        }
      }
    });
  }


  Future<void> GetEditFileApi(String editid) async {
    var res = await Userapi.GetEditFile(editid);
    setState(() {
      if (res != null) {
        if (res.editFile != null) {

          filteredRooms = data;  // Initially, show all rooms
          _isLoading = false;
          _categoryController.text = res.editFile?.category ?? "";
          String fileUrl = res.editFile?.fileName ?? "";
          _descriptionController.text = res.editFile?.description ?? "";
          if (fileUrl != "") {
            filename = getFileName(fileUrl);
          }
          _showBottomSheet(context, "Edit", editid ?? "", filename);
          print("sucsesss:${filename}");
        } else {
          print("Task Failure  ${res.settings?.message}");
        }
      }
    });
  }

  String getFileName(String url) {
    Uri uri = Uri.parse(url);
    return uri.pathSegments.last;
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffEFE2FF).withOpacity(0.1),
      body:
      // _isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(
      //         color: Color(0xff8856F4),
      //       ))
      //     :
        SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: w,
                      height: w * 0.08,
                      // padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Color(0xFF9B5FFF), // Purple background
                          borderRadius: BorderRadius.circular(100),
                          border:
                              Border.all(width: 1, color: Color(0xFF9B5FFF))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Files Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFilesSelected = true;
                              });
                            },
                            child: Container(
                              width: w * 0.44,
                              height: w * 0.08,
                              decoration: BoxDecoration(
                                color: isFilesSelected
                                    ? Color(0xFF9B5FFF)
                                    : Colors
                                        .white, // White background if selected, purple if not
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    topLeft: Radius.circular(50)),
                              ),
                              // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/folder.png",
                                    width: 16,
                                    height: 16,
                                    color: !isFilesSelected
                                        ? Color(0xFF9B5FFF)
                                        : Color(0xFFFFFFFF),
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Files",
                                    style: TextStyle(
                                        color: isFilesSelected
                                            ? Colors.white
                                            : Color(
                                                0xFF9B5FFF), // Purple text if selected, white if not
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        height: 14.52 / 12,
                                        letterSpacing: 0.59),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Category Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFilesSelected = false;
                              });
                            },
                            child: Container(
                              width: w * 0.44,
                              height: w * 0.08,
                              decoration: BoxDecoration(
                                color: !isFilesSelected
                                    ? Color(0xFF9B5FFF)
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50),
                                    bottomRight: Radius.circular(50)),
                              ),
                              // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/catogory.png",
                                    width: 16,
                                    height: 16,
                                    color: !isFilesSelected
                                        ? Colors.white
                                        : Color(0xFF9B5FFF),
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Category",
                                    style: TextStyle(
                                        color: !isFilesSelected
                                            ? Colors.white
                                            : Color(0xFF9B5FFF),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        height: 14.52 / 12,
                                        letterSpacing: 0.59),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isFilesSelected) ...[
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Container(
                            width: w * 0.61,
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
                              onTap: () {
                                GetCatagory();
                                _showBottomSheet(context, "Add", "", "");
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
                        itemCount: filteredRooms.length,
                        itemBuilder: (context, index) {
                          final projectfile = data[index];
                          String isoDate =projectfile.createdTime??"";
                          String formattedDate = DateTimeFormatter.format(isoDate, includeDate: true, includeTime: false); // Date only

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
                          "${formattedDate}",

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
                                    InkWell(
                                      onTap: () {
                                        GetEditFileApi(projectfile.id ?? "");
                                      },
                                      child: Image.asset(
                                        "assets/edit.png",
                                        fit: BoxFit.contain,
                                        width: w * 0.06,
                                        height: w * 0.05,
                                        color: Color(0xff8856F4),
                                      ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: w * 0.7,
                                          child: Text(
                                            projectfile.fileName ?? "",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              height: 21.78 / 15,
                                              color: Color(0xff1D1C1D),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Inter',
                                            ),
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
                                            if (projectfile.fileUrl != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4.0),
                                                child: ClipOval(
                                                  child: Image.network(
                                                    projectfile.fileUrl
                                                            .toString() ??
                                                        "",
                                                    width: 24,
                                                    height: 24,
                                                    fit: BoxFit.cover,
                                                  ),
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
                    ] else ...[
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Container(
                            width: w * 0.55,
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
                                    controller: _searchController2,
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
                              onTap: () {
                                _showBottomSheet1(context, "Add", "");
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
                                      "Add Category",
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
                        itemCount: filteredRooms2.length,
                        itemBuilder: (context, index) {
                          final projectcatagory = catagory[index];
                          String isoDate = projectcatagory.createdTime ?? "";
                          String formattedDate = DateTimeFormatter.format(
                              isoDate,
                              includeDate: true,
                              includeTime: false);

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
                                      " ${formattedDate}",
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
                                    InkWell(
                                      onTap: () {
                                        _showBottomSheet1(context, 'Edit',
                                            projectcatagory.id ?? "");
                                        _nameController.text=projectcatagory.name??"";
                                      },
                                      child: Image.asset(
                                        "assets/edit.png",
                                        fit: BoxFit.contain,
                                        width: w * 0.06,
                                        height: w * 0.05,
                                        color: Color(0xff8856F4),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   height: 30,
                                    //   width: 30,
                                    //   padding: EdgeInsets.all(7),
                                    //   decoration: BoxDecoration(
                                    //     color: Color(0xffF5E6FE),
                                    //     borderRadius: BorderRadius.circular(8),
                                    //   ),
                                    //   child: Image.asset(
                                    //     "assets/gallery.png",
                                    //     fit: BoxFit.contain,
                                    //     color: Color(0xffBE63F9),
                                    //   ),
                                    // ),
                                    // const SizedBox(width: 8),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Container(
                                        //   width: w * 0.7,
                                        //   child: Text(
                                        //     projectfile.fileName ?? "",
                                        //     style: const TextStyle(
                                        //       fontSize: 15,
                                        //       height: 21.78 / 15,
                                        //       color: Color(0xff1D1C1D),
                                        //       fontWeight: FontWeight.w500,
                                        //       fontFamily: 'Inter',
                                        //     ),
                                        //   ),
                                        // ),
                                        const SizedBox(height: 10),
                                        Text(
                                          projectcatagory.name ?? "",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            height: 16 / 14,
                                            color: Color(0xff1D1C1D),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        // const SizedBox(height: 10),
                                        // Row(
                                        //   children: [
                                        //     if (projectfile.fileUrl != null)
                                        //       Padding(
                                        //         padding: const EdgeInsets.only(
                                        //             right: 4.0),
                                        //         child: ClipOval(
                                        //           child: Image.network(
                                        //             projectfile.fileUrl
                                        //                 .toString() ??
                                        //                 "",
                                        //             width: 24,
                                        //             height: 24,
                                        //             fit: BoxFit.cover,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     SizedBox(
                                        //       width: w * 0.01,
                                        //     ),
                                        //     Text(
                                        //       projectfile.uploadedBy ?? "",
                                        //       style: TextStyle(
                                        //         color: Color(0xff371F41),
                                        //         fontFamily: 'Inter',
                                        //         fontSize: 14,
                                        //         fontWeight: FontWeight.w400,
                                        //         height: 18.36 / 14,
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ]
                  ],
                ),
              ),
            ),
    );
  }

  void _showBottomSheet(
      BuildContext context, String mode, String id, String file) {
    double h = MediaQuery.of(context).size.height * 0.55;
    double w = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            Future<void> _pickImage(ImageSource source) async {
              // Check and request camera/gallery permissions
              if (source == ImageSource.camera) {
                var status = await Permission.camera.status;
                if (!status.isGranted) {
                  await Permission.camera.request();
                }
              } else if (source == ImageSource.gallery) {
                var status = await Permission.photos.status;
                if (!status.isGranted) {
                  await Permission.photos.request();
                }
              }
              // After permissions are handled, proceed to pick an image
              final ImagePicker picker = ImagePicker();
              XFile? selected = await picker.pickImage(source: source);

              setState(() {
                _imageFile = selected;
              });

              if (selected != null) {
                setState(() {
                  filepath = File(selected.path);
                  filename = p.basename(selected.path);
                  _validatefile = "";
                });
                print("Selected Image: ${selected.path}");
              } else {
                print('User canceled the file picking');
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: h,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: w * 0.1,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          ("${mode} Files"),
                          style: TextStyle(
                            color: Color(0xff1C1D22),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            height: 18 / 16,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pop(); // Close the BottomSheet when tapped
                          },
                          child: Container(
                            width: w * 0.05,
                            height: w * 0.05,
                            decoration: BoxDecoration(
                              color: Color(0xffE5E5E5),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/crossblue.png",
                                fit: BoxFit.contain,
                                width: w * 0.023,
                                height: w * 0.023,
                                color: Color(0xff8856F4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label(text: 'Category'),
                            SizedBox(height: 4),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.050,
                              child: TypeAheadField<Catagory>(
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    controller: _categoryController,
                                    focusNode: focusNode,
                                    autofocus: true,
                                    onTap: () {
                                      setState(() {});
                                    },
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      height: 1.2,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Select your milestone",
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 0,
                                        height: 1.2,
                                        color: Color(0xffAFAFAF),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffFCFAFF),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xffD0CBDB)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xffD0CBDB)),
                                      ),
                                    ),
                                  );
                                },
                                suggestionsCallback: (pattern) {
                                  return catagory
                                      .where((item) => item.name!
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()))
                                      .toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(
                                      suggestion.name!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
                                },
                                onSelected: (suggestion) {
                                  setState(() {
                                    _categoryController.text = suggestion.name!;
                                    // You can use suggestion.statusKey to send to the server
                                    categoryID = suggestion.id!;
                                    // Call your API with the selected key here if needed
                                    _validateCategory = "";
                                  });
                                },
                              ),
                            ),
                            if (_validateCategory.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    left: 8, bottom: 10, top: 5),
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateCategory,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              SizedBox(height: 15),
                            ],
                            DottedBorder(
                              color: Color(0xffD0CBDB),
                              strokeWidth: 1,
                              dashPattern: [2, 2],
                              borderType: BorderType.RRect,
                              radius: Radius.circular(8),
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SafeArea(
                                            child: Wrap(
                                              children: <Widget>[
                                                ListTile(
                                                  leading:
                                                      Icon(Icons.camera_alt),
                                                  title: Text('Take a photo'),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.camera);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      Icon(Icons.photo_library),
                                                  title: Text(
                                                      'Choose from gallery'),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.gallery);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 35,
                                      width: w * 0.35,
                                      decoration: BoxDecoration(
                                        color: Color(0xffF8FCFF),
                                        border: Border.all(
                                          color: Color(0xff8856F4),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Choose File',
                                          style: TextStyle(
                                            color: Color(0xff8856F4),
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (filename != "")
                                            ? (file != "")
                                                ? file
                                                : filename
                                            : 'No File Chosen',
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Color(0xff3C3C3C),
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_validatefile.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validatefile,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            _label(text: 'Description'),
                            SizedBox(height: 4),
                            Container(
                              height: h * 0.2,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Color(0xffE8ECFF))),
                              child: TextFormField(
                                cursorColor: Color(0xff8856F4),
                                scrollPadding: const EdgeInsets.only(top: 5),
                                controller: _descriptionController,
                                textInputAction: TextInputAction.done,
                                maxLines: 100,
                                onTap: () {
                                  setState(() {
                                    _validateDescription = "";
                                  });
                                },
                                onChanged: (v) {
                                  setState(() {
                                    _validateDescription = "";
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 10, top: 10),
                                  hintText: "Type Description",
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 0,
                                    height: 1.2,
                                    color: Color(0xffAFAFAF),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xffFCFAFF),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xffD0CBDB)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xffD0CBDB)),
                                  ),
                                ),
                              ),
                            ),
                            if (_validateDescription.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(bottom: 5),
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateDescription,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: w * 0.43,
                            decoration: BoxDecoration(
                              color: Color(0xffF8FCFF),
                              border: Border.all(
                                color: Color(0xff8856F4),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  color: Color(0xff8856F4),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        InkResponse(
                          onTap: () {
                            setState(() {
                              _validateCategory =
                                  _categoryController.text.isEmpty
                                      ? "Please select a category"
                                      : "";
                              _validateDescription =
                                  _descriptionController.text.isEmpty
                                      ? "Please enter a description"
                                      : "";
                              _validatefile =
                                  filename == "" ? "Please choose file." : "";
                              _isLoading = _validateCategory.isEmpty &&
                                  _validateDescription.isEmpty &&
                                  _validatefile.isEmpty;
                            });
                            if (_isLoading) {
                              if (mode == "Edit") {
                                PostFiles(id);
                              } else {
                                PostFiles("");
                              }
                            }
                          },
                          child: Container(
                            height: 40,
                            width: w * 0.43,
                            decoration: BoxDecoration(
                              color: Color(0xff8856F4),
                              border: Border.all(
                                color: Color(0xff8856F4),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child:
                              // _isLoading?spinkit.getFadingCircleSpinner():
                              Text(
                                'Save',
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _categoryController.text = "";
      _descriptionController.text = "";
      filename = "";
      _validateCategory = "";
      _validateDescription = "";
      _validatefile = "";
    });
    ;
  }

  static Widget _label({required String text}) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xff141516),
        fontSize: 14,
      ),
    );
  }

  void _showBottomSheet1(BuildContext context, String mode, String id) {
    double h = MediaQuery.of(context).size.height * 0.3;
    double w = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: h,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: w * 0.1,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          ("${mode} Category"),
                          style: TextStyle(
                            color: Color(0xff1C1D22),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            height: 18 / 16,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pop(); // Close the BottomSheet when tapped
                          },
                          child: Container(
                            width: w * 0.05,
                            height: w * 0.05,
                            decoration: BoxDecoration(
                              color: Color(0xffE5E5E5),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/crossblue.png",
                                fit: BoxFit.contain,
                                width: w * 0.023,
                                height: w * 0.023,
                                color: Color(0xff8856F4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label(text: "Name"),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.050,
                                child: TextFormField(
                                  controller: _nameController,
                                  focusNode: _focusNodetitle,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Color(0xff8856F4),
                                  onTap: () {
                                    setState(() {
                                      _validatename = "";
                                    });
                                  },
                                  onChanged: (v) {
                                    setState(() {
                                      _validatename = "";
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Enter Category Name",
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 0,
                                      height: 19.36 / 14,
                                      color: Color(0xffAFAFAF),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xffFCFAFF),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: const BorderSide(
                                          width: 1, color: Color(0xffd0cbdb)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: const BorderSide(
                                          width: 1, color: Color(0xffd0cbdb)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: const BorderSide(
                                          width: 1, color: Color(0xffd0cbdb)),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: const BorderSide(
                                          width: 1, color: Color(0xffd0cbdb)),
                                    ),
                                  ),
                                ),
                              ),
                              if (_validatename.isNotEmpty) ...[
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      left: 8, bottom: 10, top: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: ShakeWidget(
                                    key: Key("value"),
                                    duration: Duration(milliseconds: 700),
                                    child: Text(
                                      _validatename,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                SizedBox(height: 15),
                              ],
                            ]),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: w * 0.43,
                            decoration: BoxDecoration(
                              color: Color(0xffF8FCFF),
                              border: Border.all(
                                color: Color(0xff8856F4),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  color: Color(0xff8856F4),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        InkResponse(
                          onTap: () {
                            setState(() {
                              _validatename = _nameController.text.isEmpty
                                  ? "Please select a category name"
                                  : "";

                              _isLoading = _validatefile.isEmpty;
                            });
                            if (_isLoading) {
                              if (mode == "Edit") {
                                PostCategory(id);

                              } else {
                                PostCategory("");
                              }
                            }
                          },
                          child: Container(
                            height: 40,
                            width: w * 0.43,
                            decoration: BoxDecoration(
                              color: Color(0xff8856F4),
                              border: Border.all(
                                color: Color(0xff8856F4),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child:
                              _isLoading?spinkit.getFadingCircleSpinner():
                              Text(
                                'Save',
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _nameController.text = "";
      _validatename = "";
    });
    ;
  }
}
