import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skill/Providers/ThemeProvider.dart';
import '../Model/GetCatagoryModel.dart';
import '../Model/ProjectFileModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
import 'package:path/path.dart' as p;
import '../utils/ShakeWidget.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/app_colors.dart';

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
  final FocusScopeNode focusScopeNode = FocusScopeNode();
  final FocusScopeNode focusScopeNode1 = FocusScopeNode();
  String _validateCategory = "";
  String _validateDescription = "";
  String _validatefile = "";
  String filename = "";
  String _validatename = "";
  XFile? _imageFile;
  File? filepath;
  bool _isLoading = true;
  final spinkit=Spinkits();
  bool isFilesSelected = true;

  String categoryID = "";
  String categoryid = "";



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

  // Future<void> downloadInvoice(String url) async {
  //   try {
  //     print("Checking storage permission...");
  //     var status = await Permission.mediaLibrary.status;
  //
  //     if (!status.isGranted) {
  //       print("Storage permission not granted. Requesting...");
  //       await Permission.mediaLibrary.request();
  //     }
  //     status = await Permission.mediaLibrary.status;
  //     if (status.isGranted) {
  //       print("Storage permission granted.");
  //       Directory dir =
  //           Directory('/storage/emulated/0/Download/'); // for Android
  //       if (!await dir.exists()) {
  //         print(
  //             "Download directory does not exist. Using external storage directory.");
  //         dir = await getExternalStorageDirectory() ?? Directory.systemTemp;
  //       } else {
  //         print("Download directory exists: ${dir.path}");
  //       }
  //       String generateFileName(String originalName) {
  //         // Extract file extension
  //         String extension = originalName.split('.').last;
  //         // Generate unique identifier
  //         String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
  //         // Return unique filename
  //         String fileName = "Prescription_$uniqueId.$extension";
  //         print("Generated filename: $fileName");
  //         return fileName;
  //       }
  //
  //       // Start downloading the file
  //       print("Starting download from: $url");
  //       FileDownloader.downloadFile(
  //         url: url.toString().trim(),
  //         name: generateFileName("Order_invoice.pdf"),
  //         notificationType: NotificationType.all,
  //         downloadDestination: DownloadDestinations.publicDownloads,
  //         onDownloadRequestIdReceived: (downloadId) {
  //           print('Download request ID received: $downloadId');
  //         },
  //         onProgress: (fileName, progress) {
  //           print('Downloading $fileName: $progress%');
  //         },
  //         onDownloadError: (String error) {
  //           print('DOWNLOAD ERROR: $error');
  //         },
  //         onDownloadCompleted: (path) {
  //           print('Download completed! File saved at: $path');
  //           setState(() {
  //             // Update UI if necessary
  //           });
  //         },
  //       );
  //     } else {
  //       print("Storage permission denied.");
  //     }
  //   } catch (e, s) {
  //     print('Exception caught: $e');
  //     print('Stack trace: $s');
  //   }
  // }

  Future<void> PostFiles(String editid) async {
    var res;
    if (editid != "") {
      res = await Userapi.putProjectFile(editid, categoryID,
          filepath, _descriptionController.text);
      print("putProjectFile>>${res}");
    } else {
      res = await Userapi.postProjectFile(widget.id, categoryID,
          filepath, _descriptionController.text);
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      body:
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
                          color:themeProvider.primaryColor, // Purple background
                          borderRadius: BorderRadius.circular(100),
                          border:
                              Border.all(width: 1, color: themeProvider.primaryColor,)),
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
                                    ? themeProvider.primaryColor
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
                                        ? themeProvider.primaryColor
                                        : Color(0xFFFFFFFF),
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Files",
                                    style: TextStyle(
                                        color: isFilesSelected
                                            ? Colors.white
                                            : themeProvider.primaryColor, // Purple text if selected, white if not
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
                                    ?themeProvider.primaryColor
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
                                        : themeProvider.primaryColor,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Category",
                                    style: TextStyle(
                                        color: !isFilesSelected
                                            ? Colors.white
                                            :themeProvider.primaryColor,
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
                                  color: themeProvider.primaryColor,
                                ),
                                const SizedBox(width: 10),

                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    focusNode: focusScopeNode,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      border: InputBorder.none,
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: themeProvider.primaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        fontFamily: "Nunito",
                                      ),
                                    ),
                                    style: TextStyle(
                                        color:themeProvider.primaryColor,
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
                                focusScopeNode.unfocus();
                                GetCatagory();
                                _showBottomSheet(context, "Add", "", "");
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color:themeProvider.primaryColor,
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
                      _isLoading? _buildShimmerList():
                      filteredRooms.isEmpty
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
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredRooms.length,
                        itemBuilder: (context, index) {
                          final projectfile = filteredRooms[index];
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
                                    // InkResponse(
                                    //   onTap: (){
                                    //     // downloadInvoice(projectfile.fileUrl??"");
                                    //   },
                                    //   child: Image.asset(
                                    //     "assets/download.png",
                                    //     fit: BoxFit.contain,
                                    //     width: w * 0.06,
                                    //     height: w * 0.05,
                                    //     color: Color(0xff8856F4),
                                    //   ),
                                    // ),
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
                                        color:themeProvider.primaryColor,
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
                                    focusNode: focusScopeNode1,
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
                                focusScopeNode1.unfocus();
                                _showBottomSheet1(context, "Add", "");
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: themeProvider.primaryColor,
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
                      filteredRooms2.isEmpty
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
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredRooms2.length,
                        itemBuilder: (context, index) {
                          final projectcatagory = catagory[index];
                          String isoDate = projectcatagory.createdTime ?? "";
                          String formattedDate = DateTimeFormatter.format(
                              isoDate,
                              includeDate: true,
                              includeTime: false);

                          return Consumer<ThemeProvider>(builder: (context,themeProvider,child){
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: themeProvider.containerColor,
                                borderRadius: BorderRadius.circular(7),
                                // border: Border.all(color: Colors.white,width: 0.5)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        projectcatagory.name ?? "",
                                        style:  TextStyle(
                                          fontSize: 18,
                                          height: 16 / 18,
                                          color: themeProvider.textColor,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      // Image.asset(
                                      //   "assets/calendar.png",
                                      //   fit: BoxFit.contain,
                                      //   width: w * 0.06,
                                      //   height: w * 0.05,
                                      //   color: Color(0xff6C848F),
                                      // ),
                                      // SizedBox(
                                      //   width: w * 0.004,
                                      // ),
                                      // Text(
                                      //   " ${formattedDate}",
                                      //   style: TextStyle(
                                      //     color: const Color(0xff1D1C1D),
                                      //     fontWeight: FontWeight.w400,
                                      //     fontSize: 15,
                                      //     height: 19.41 / 15,
                                      //     overflow: TextOverflow.ellipsis,
                                      //     fontFamily: "Inter",
                                      //   ),
                                      // ),
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
                                          color:themeProvider.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(height: 12),
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
                                          // const SizedBox(height: 10),

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
                          }


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

  Widget _buildShimmerList() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      itemCount: 10, // Adjust this number based on how many shimmer items you want
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  shimmerRectangle(20,context), // Shimmer for calendar icon
                  const SizedBox(width: 8),
                  shimmerText(100, 15,context), // Shimmer for formatted date
                  const Spacer(),
                  shimmerRectangle(20,context), // Shimmer for edit icon
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerRectangle(20,context), // Shimmer for gallery icon
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerText(150, 15,context), // Shimmer for file name
                        const SizedBox(height: 10),
                        shimmerText(100, 14,context), // Shimmer for category
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            shimmerCircle(24,context), // Shimmer for user image
                            const SizedBox(width: 8),
                            shimmerText(100, 14,context), // Shimmer for uploaded by
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
        return Consumer<ThemeProvider>(builder: (context,themeProvider,child){
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
                    color: themeProvider.containerColor,
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
                              color: themeProvider.textColor,
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
                              _label(context,text: 'Category'),
                              SizedBox(height: 4),
                              // Container(
                              //   height: MediaQuery.of(context).size.height * 0.050,
                              //   child: TypeAheadField<Catagory>(
                              //     builder: (context, controller, focusNode) {
                              //       return TextField(
                              //         controller: _categoryController,
                              //         focusNode: focusNode,
                              //         autofocus: true,
                              //         onTap: () {
                              //           setState(() {});
                              //         },
                              //         onChanged: (v) {
                              //           setState(() {});
                              //         },
                              //         style: TextStyle(
                              //           fontSize: 16,
                              //           letterSpacing: 0,
                              //           height: 1.2,
                              //           color: Colors.black,
                              //           fontWeight: FontWeight.w400,
                              //         ),
                              //         decoration: InputDecoration(
                              //           hintText: "Select Category",
                              //           hintStyle: TextStyle(
                              //             fontSize: 15,
                              //             letterSpacing: 0,
                              //             height: 1.2,
                              //             color: Color(0xffAFAFAF),
                              //             fontFamily: 'Poppins',
                              //             fontWeight: FontWeight.w400,
                              //           ),
                              //           filled: true,
                              //           fillColor: Color(0xffFCFAFF),
                              //           enabledBorder: OutlineInputBorder(
                              //             borderRadius: BorderRadius.circular(7),
                              //             borderSide: BorderSide(
                              //                 width: 1, color: Color(0xffD0CBDB)),
                              //           ),
                              //           focusedBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(7.0),
                              //             borderSide: BorderSide(
                              //                 width: 1, color: Color(0xffD0CBDB)),
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     suggestionsCallback: (pattern) {
                              //       return catagory
                              //           .where((item) => item.name!
                              //               .toLowerCase()
                              //               .contains(pattern.toLowerCase()))
                              //           .toList();
                              //     },
                              //     itemBuilder: (context, suggestion) {
                              //       return ListTile(
                              //         title: Text(
                              //           suggestion.name!,
                              //           style: TextStyle(
                              //             fontSize: 15,
                              //             fontFamily: "Inter",
                              //             fontWeight: FontWeight.w400,
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     onSelected: (suggestion) {
                              //       setState(() {
                              //         _categoryController.text = suggestion.name!;
                              //         // You can use suggestion.statusKey to send to the server
                              //         categoryID = suggestion.id!;
                              //         // Call your API with the selected key here if needed
                              //         _validateCategory = "";
                              //       });
                              //     },
                              //   ),
                              // ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<Catagory>(
                                  isExpanded: true,
                                  hint: Row(
                                    children: [
                                      Text(
                                        'Select Category',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Inter",
                                          color: Color(0xffAFAFAF),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  // Show "No data found" if data is empty
                                  items: catagory.isEmpty
                                      ? [
                                    DropdownMenuItem<Catagory>(
                                      value: null, // Set value as null or a placeholder
                                      enabled: false, // Disable selection
                                      child: Text(
                                        'No data found',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xffAFAFAF),
                                        ),
                                      ),
                                    ),
                                  ]
                                      : catagory
                                      .map((source) => DropdownMenuItem<Catagory>(
                                    value: source, // Set the whole object as the value
                                    child: Text(
                                      source.name ?? '', // Show the category name
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                                      .toList(),
                                  value: categoryid != null && categoryid != ""
                                      ? catagory.isNotEmpty
                                      ? catagory.firstWhere(
                                        (member) => member.id == categoryid,
                                    orElse: () => catagory[0], // Fallback to the first element if available
                                  )
                                      : null // If data is empty, return null
                                      : null, // Default to null if categoryid is not valid
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) {
                                        categoryid = value.id!; // Set categoryid to the selected category's id
                                      } else {
                                        categoryid = ""; // If the value is null (No data found), reset categoryid to 0
                                      }
                                      _validateCategory = ""; // Reset validation message
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: MediaQuery.of(context).size.height * 0.050,
                                    width: w,
                                    padding: const EdgeInsets.only(left: 14, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(color: Color(0xffD0CBDB)),
                                      color:themeProvider.containerColor,
                                    ),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      size: 25,
                                    ),
                                    iconSize: 14,
                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.black,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: themeProvider.containerColor,
                                    ),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness: MaterialStateProperty.all(6),
                                      thumbVisibility: MaterialStateProperty.all(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding: EdgeInsets.only(left: 14, right: 14),
                                  ),
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
                                        showModalBottomSheet(backgroundColor: themeProvider.containerColor,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SafeArea(
                                              child: Wrap(
                                                children: <Widget>[
                                                  ListTile(
                                                    leading:
                                                    Icon(Icons.camera_alt,),
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
                                          color: themeProvider.containerColor,
                                          border: Border.all(
                                            color: themeProvider.primaryColor,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Choose File',
                                            style: TextStyle(
                                              color: themeProvider.primaryColor,
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
                                              color: themeProvider.textColor,
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
                              _label(context,text: 'Description'),
                              SizedBox(height: 4),
                              Container(
                                height: h * 0.2,
                                decoration: BoxDecoration(
                                    color: themeProvider.containerColor,
                                    borderRadius: BorderRadius.circular(20),
                                   ),
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
                                      color:themeProvider.textColor,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    filled: true,
                                    fillColor: themeProvider.fillColor,
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
                                color: themeProvider.containerColor,
                                border: Border.all(
                                  color:themeProvider.primaryColor,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                    color: themeProvider.primaryColor,
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
                                _validateCategory = categoryid==""
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
                                color:themeProvider.primaryColor,
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

   Widget _label(BuildContext context,{required String text}) {
    return Consumer<ThemeProvider>(builder: (context,themeProvider,child){
      return Text(
        text,
        style: TextStyle(
          color: themeProvider.textColor,
          fontSize: 14,
        ),
      );
    },

    );
  }

  void _showBottomSheet1(BuildContext context, String mode, String id) {
    double h = MediaQuery.of(context).size.height * 0.3;
    double w = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(builder: (context,themeProvider,child){
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
                    color: themeProvider.containerColor,
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
                              color: themeProvider.textColor,
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
                                _label(context,text: "Name"),
                                Container(
                                  height:
                                  MediaQuery.of(context).size.height * 0.050,
                                  child: TextFormField(
                                    controller: _nameController,
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
                                      fillColor: themeProvider.fillColor,
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
                                color:themeProvider.containerColor,
                                border: Border.all(
                                  color: themeProvider.primaryColor,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                    color: themeProvider.primaryColor,
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
                                color: themeProvider.primaryColor,
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
        );
      },
    ).whenComplete(() {
      _nameController.text = "";
      _validatename = "";
    });
    ;
  }
}
