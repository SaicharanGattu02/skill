import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skill/Providers/ThemeProvider.dart';
import '../Model/GetEditProjectNoteModel.dart';
import '../Model/ProjectNoteModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/ShakeWidget.dart';
import 'package:path/path.dart' as p;

import '../utils/app_colors.dart';

class ProjectNotes extends StatefulWidget {
  final String id;
  const ProjectNotes({super.key, required this.id});

  @override
  State<ProjectNotes> createState() => _ProjectNotesState();
}

class _ProjectNotesState extends State<ProjectNotes> {
  // final TextEditingController _createdDateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNodetitle = FocusNode();

  String _validateTittle = "";
  String _validateDescription = "";
  String _validatefile = "";
  String filename = "";

  XFile? _imageFile;
  File? filepath;
  bool _isLoading = true;
  bool isLoading = false;
  final spinkit = Spinkits();

  @override
  void initState() {
    filteredData = List.from(data);
    _searchController.addListener(filterData); // Add listener for search
    GetNote();
    super.initState();
  }

  void filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredData = data.where((item) {
        return (item.title?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  List<Data> data = []; // Original list of notes
  List<Data> filteredData = []; // Filtered list for search
  Future<void> GetNote() async {
    var res = await Userapi.GetProjectNote(widget.id);
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          _isLoading = false;
          data = res.data ?? [];
          filteredData = res.data ?? [];
        } else {
          _isLoading = false;
          CustomSnackBar.show(context, res.settings?.message ?? "");
        }
      } else {
        print("Task Failure  ${res?.settings?.message}");
      }
    });
  }

  Future<void> PostAddNoteApi(String editid) async {
    var res;
    if (editid != "") {
      res = await Userapi.PutEditNote(
        editid,
        _titleController.text,
        _descriptionController.text,
        filepath,
        widget.id,
      );
    } else {
      res = await Userapi.PostAddNote(
        _titleController.text,
        _descriptionController.text,
        filepath, // Pass null if no image
        widget.id,
      );
    }
    if (res != null) {
      setState(() {
        if (res.settings?.success == 1) {
          isLoading = false;
          Navigator.pop(context);
          GetNote();
        } else {
          isLoading = false;
        }
      });
    } else {
      print("PostAddNoteApi >>>${res?.settings?.message}");
      CustomSnackBar.show(context, "${res?.settings?.message}");
    }
  }

  EditData? editData;
  Future<void> EditNoteApi(String editid) async {
    var res = await Userapi.GetProjectEditNotes(editid);
    setState(() {
      _isLoading = false;
      if (res != null) {
        if (res.editData != null) {
          _titleController.text = res.editData?.title ?? "";
          _descriptionController.text = res.editData?.description ?? "";
          String fileUrl = res.editData?.file ?? "";
          if (fileUrl != "") {
            filename = getFileName(fileUrl);
          }
          _showBottomSheet1(context, "Edit", editid ?? "", filename);

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

  Future<void> DelateApi(String id) async {
    var res = await Userapi.ProjectDelateNotes(id);

    if (res != null) {
      setState(() {
        _isLoading = false;
        if (res.settings?.success == 1) {
          GetNote();
          CustomSnackBar.show(context, "${res.settings?.message}");
        } else {
          CustomSnackBar.show(context, "${res.settings?.message}");
        }
      });
    } else {
      print("DelateApi >>>${res?.settings?.message}");
      CustomSnackBar.show(context, "${res?.settings?.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
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
                        _showBottomSheet1(context, "Add", "", "");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
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
              _isLoading
                  ? _buildShimmerList()
                  : filteredData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.24,
                              ),
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
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            final note = filteredData[index];
                            String isoDate = note.createdTime ?? "";
                            String formattedDate = DateTimeFormatter.format(
                                isoDate,
                                includeDate: true,
                                includeTime: false); // Date only
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
                                          EditNoteApi(note.id ?? "");
                                        },
                                        child: Image.asset(
                                          "assets/edit.png",
                                          fit: BoxFit.contain,
                                          width: w * 0.06,
                                          height: w * 0.05,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: w * 0.02,
                                      ),
                                      if (note.file != null &&
                                          note.file!.isNotEmpty) ...[
                                        InkWell(
                                          onTap: () {
                                            // Check if note.file is not null before showing the bottom sheet
                                            if (note.file != null &&
                                                note.file!.isNotEmpty) {
                                              _showBottomSheet(
                                                  context, note.file!);
                                            } else {
                                              // Optionally, show a message or handle the case when the file is null
                                              print('No file to display');
                                            }
                                          },
                                          child: Image.asset(
                                            "assets/eye.png",
                                            fit: BoxFit.contain,
                                            width: w * 0.06,
                                            height: w * 0.05,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                      // SizedBox(
                                      //   width: w * 0.02,
                                      // ),
                                      // Image.asset(
                                      //   "assets/download.png",
                                      //   fit: BoxFit.contain,
                                      //   width: w * 0.06,
                                      //   height: w * 0.05,
                                      //   color: Color(0xff8856F4),
                                      // ),
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
                                  // const SizedBox(height: 20),
                                  // InkWell(
                                  //   onTap: () {
                                  //     DelateApi(note.id ?? "");
                                  //   },
                                  //   child: Text(
                                  //     "Remove",
                                  //     style: TextStyle(
                                  //       color: Color(0xff8856F4),
                                  //       fontFamily: 'Inter',
                                  //       fontSize: 15,
                                  //       fontWeight: FontWeight.w500,
                                  //       height: 19.36 / 15,
                                  //       decoration: TextDecoration.underline,
                                  //       decorationColor: Color(0xff8856F4),
                                  //     ),
                                  //   ),
                                  // )
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

  Widget _buildShimmerList() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      itemCount: 10, // Adjust the number of shimmer items as needed
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
                  shimmerRectangle(20, context), // Shimmer for calendar icon
                  const SizedBox(width: 8),
                  shimmerText(100, 15, context), // Shimmer for due date
                  const Spacer(),
                  shimmerRectangle(20, context), // Shimmer for edit icon
                  const SizedBox(width: 8),
                  shimmerRectangle(20, context), // Shimmer for eye icon (file)
                ],
              ),
              const SizedBox(height: 20),
              shimmerText(150, 20, context), // Shimmer for note title
              const SizedBox(height: 4),
              shimmerText(280, 15, context), // Shimmer for note description
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheet1(
      BuildContext context, String mode, String id, String file) {
    double h = MediaQuery.of(context).size.height * 0.5;
    double w = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
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
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
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
                              ("${mode} Note"),
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
                                _label(context, text: 'Title'),
                                SizedBox(height: 4),
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.050,
                                  child: TextFormField(
                                    controller: _titleController,
                                    focusNode: _focusNodetitle,
                                    keyboardType: TextInputType.text,
                                    cursorColor: Color(0xff8856F4),
                                    onTap: () {
                                      setState(() {
                                        _validateTittle = "";
                                      });
                                    },
                                    onChanged: (v) {
                                      setState(() {
                                        _validateTittle = "";
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter Title",
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
                                if (_validateTittle.isNotEmpty) ...[
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
                                        _validateTittle,
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
                                _label(context, text: 'Description'),
                                SizedBox(height: 4),
                                Container(
                                  height: h * 0.2,
                                  decoration: BoxDecoration(
                                      color:themeProvider.containerColor,
                                      borderRadius: BorderRadius.circular(20),
                                      ),
                                  child: TextFormField(
                                    cursorColor: Color(0xff8856F4),
                                    scrollPadding:
                                        const EdgeInsets.only(top: 5),
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
                                      contentPadding: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      hintText: "Description",
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 0,
                                        height: 1.2,
                                        color: Color(0xffAFAFAF),
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
                                        borderRadius:
                                            BorderRadius.circular(7.0),
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
                                                      leading: Icon(
                                                          Icons.camera_alt),
                                                      title:
                                                          Text('Take a photo'),
                                                      onTap: () {
                                                        _pickImage(
                                                            ImageSource.camera);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                          Icons.photo_library),
                                                      title: Text(
                                                          'Choose from gallery'),
                                                      onTap: () {
                                                        _pickImage(ImageSource
                                                            .gallery);
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
                                              color: AppColors.primaryColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Choose File',
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
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
                                                overflow:
                                                    TextOverflow.ellipsis),
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
                                    color: AppColors.primaryColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: Text(
                                    'Close',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
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
                                  _validateTittle =
                                      _titleController.text.isEmpty
                                          ? "Please enter a title"
                                          : "";
                                  _validateDescription =
                                      _descriptionController.text.isEmpty
                                          ? "Please enter a description"
                                          : "";
                                  // _validatefile = _imageFile == null
                                  //     ? "Please choose file."
                                  //     : "";
                                  _isLoading = _validateTittle.isEmpty &&
                                      _validateDescription.isEmpty;
                                  // && _validatefile.isEmpty;
                                });
                                if (_isLoading) {
                                  if (mode == "Edit") {
                                    PostAddNoteApi(id);
                                  } else {
                                    PostAddNoteApi("");
                                  }
                                }
                              },
                              child: Container(
                                height: 40,
                                width: w * 0.43,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: isLoading
                                      ? spinkit.getFadingCircleSpinner()
                                      : Text(
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
      _titleController.text = "";
      _descriptionController.text = "";
      filename = "";
      _validateTittle = "";
      _validateDescription = "";
      _validatefile = "";
    });
    ;
  }

  Widget _label(BuildContext context, {required String text}) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
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

  // Widget _showDialog(BuildContext context) {
  //   return AlertDialog(
  //     contentPadding: EdgeInsets.all(20.0), // Optional padding
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20.0), // Rounded corners
  //     ),
  //     content: Card(
  //       elevation: 5.0,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(15.0), // Rounded corners
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min, // Adjust the size to wrap content
  //         children: [
  //           Image.asset(
  //             'assets/your_image.png', // Replace with your image asset path
  //             fit: BoxFit.cover,
  //             width: 150.0, // Set width for image
  //             height: 150.0, // Set height for image
  //           ),
  //           SizedBox(height: 20.0), // Spacing between image and description
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _showBottomSheet(
    BuildContext context,
    String? file,
  ) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    String? selectedImage = file;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: h * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "View Images",
                        style: TextStyle(
                          color: Color(0xff1C1D22),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          height: 18 / 18,
                          fontFamily: 'Inter',
                        ),
                      ),
                      InkResponse(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Color(0xffE5E5E5),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                            "assets/crossblue.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: w,
                    height: h * 0.3,

                    child: selectedImage != null
                        ? ClipRect(
                            child: Image.network(
                              selectedImage,
                              fit: BoxFit.fill,
                            ),
                          )
                        : Container(), // Show empty container if no image is selected
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
