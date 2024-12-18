import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skill/Providers/ProjectCommentProviders.dart';
import 'package:skill/Model/ProjectCommentsModel.dart';
import 'package:path/path.dart' as p;
import '../Providers/ThemeProvider.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/ShakeWidget.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class ProjectComment extends StatefulWidget{
  final String id;
  ProjectComment({super.key, required this.id});

  @override
  State<ProjectComment> createState() => _ProjectCommentState();
}

class _ProjectCommentState extends State<ProjectComment> {
  TextEditingController _commentController = TextEditingController();
  final FocusScopeNode focusScopeNode = FocusScopeNode();
  bool isSaving = false;
  final spinkit = Spinkits();

  XFile? _imageFile;
  File? filepath;
  String filename = "";

  @override
  void initState() {
    super.initState();
    Provider.of<ProjectCommentProviders>(context, listen: false)
        .GetProjectCommentsApi(widget.id);
  }

  String validatecomment = "";
  String _validatefile = "";

  Future<void> _pickImage(ImageSource source) async {
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

    final ImagePicker picker = ImagePicker();
    XFile? selectedImage = await picker.pickImage(source: source);

    if (selectedImage != null) {
      setState(() {
        Provider.of<ProjectCommentProviders>(context)
            .imageList
            .add(selectedImage);
        _validatefile = "";
      });
      print("Selected Image: ${selectedImage.path}");
    } else {
      print('User canceled the file picking');
    }
  }

  // Future<void> _pickImage(ImageSource source) async {
  //   if (source == ImageSource.camera) {
  //     var status = await Permission.camera.status;
  //     if (!status.isGranted) {
  //       await Permission.camera.request();
  //     }
  //   } else if (source == ImageSource.gallery) {
  //     var status = await Permission.photos.status;
  //     if (!status.isGranted) {
  //       await Permission.photos.request();
  //     }
  //   }
  //   // After permissions are handled, proceed to pick an image
  //   final ImagePicker picker = ImagePicker();
  //   XFile? selected = await picker.pickImage(source: source);
  //
  //   setState(() {
  //     _imageFile = selected;
  //   });
  //
  //   if (selected != null) {
  //     setState(() {
  //       filepath = File(selected.path);
  //       filename = p.basename(selected.path);
  //       _validatefile="";
  //     });
  //     print("Selected Image: ${selected.path}");
  //   } else {
  //     print('User canceled the file picking');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final commentProvider = Provider.of<ProjectCommentProviders>(context);
    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeProvider.themeData == lightTheme
                    ? Color(0xffffffff)
                    : AppColors.darkmodeContainerColor,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [
                  //     // if ( projectfile.fileUrl!= null)
                  //     Padding(
                  //       padding: const EdgeInsets.only(right: 4.0),
                  //       child: ClipOval(
                  //         child: Image.asset(
                  //           "assets/prashanth.png",
                  //           width: w * 0.15,
                  //           height: w * 0.15,
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: w * 0.01,
                  //     ),
                  //     Column(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           "Prashanth Chary",
                  //           style: TextStyle(
                  //             color: Color(0xff000000),
                  //             fontFamily: 'Inter',
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //             height: 18.36 / 16,
                  //           ),
                  //         ),
                  //         Text(
                  //           "Ux Designer",
                  //           style: TextStyle(
                  //             color: Color(0xff6C848F),
                  //             fontFamily: 'Inter',
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w400,
                  //             height: 14.36 / 14,
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Write Comment",
                    style: TextStyle(
                      color: themeProvider.themeData == lightTheme
                          ? Color(0xff141516)
                          : themeProvider.textColor,
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 18.36 / 16,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    height: h * 0.1,
                    child: TextFormField(
                      cursorColor: Color(0xff8856F4),
                      scrollPadding: const EdgeInsets.only(top: 5),
                      controller: _commentController,
                      focusNode: focusScopeNode,
                      textInputAction: TextInputAction.done,
                      maxLines: 100,
                      onTap: () {
                        setState(() {
                          validatecomment = "";
                        });
                      },
                      onChanged: (v) {
                        setState(() {
                          validatecomment = "";
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 10, top: 10),
                        hintText: "Type Comment",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0,
                          height: 1.2,
                          color: Color(0xffAFAFAF),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: themeProvider.containerColor,
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
                  if (validatecomment.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(bottom: 5),
                      child: ShakeWidget(
                        key: Key("value"),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          validatecomment,
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
                              backgroundColor: themeProvider.containerColor,
                              context: context,
                              builder: (BuildContext context) {
                                return SafeArea(
                                  child: Wrap(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text('Upload File'),
                                        onTap: () {
                                          _pickImage(ImageSource.camera);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text('Choose from gallery'),
                                        onTap: () {
                                          _pickImage(ImageSource.gallery);
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
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                'Upload File',
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
                        if (commentProvider.imageList.isNotEmpty) ...[
                          Expanded(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(width: 5),
                                  for (int i = 0;
                                      i < commentProvider.imageList.length;
                                      i++)
                                    Stack(
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 0,
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: FileImage(File(
                                                    commentProvider
                                                        .imageList[i].path)),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  commentProvider.imageList
                                                      .removeAt(i);
                                                });
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFE8ECFF),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  padding: EdgeInsets.all(2.0),
                                                  child: Icon(Icons.clear,
                                                      size: 15,
                                                      color:
                                                          Color(0xff6977C2)))),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          Center(
                            child: Text(
                              'No File Chosen',
                              style: TextStyle(
                                color: Color(0xffAFAFAF),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
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
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: commentProvider.isLoading
                  ? _buildShimmerList()
                  : commentProvider.projectComments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
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
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: commentProvider.projectComments.length,
                          itemBuilder: (context, index) {
                            final comments =
                                commentProvider.projectComments[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: themeProvider.themeData == lightTheme
                                    ? Color(0xffffffff)
                                    : AppColors.darkmodeContainerColor,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (comments.commentByImage != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: ClipOval(
                                            child: Image.network(
                                              comments.commentByImage ?? "",
                                              width: w * 0.08,
                                              height: w * 0.08,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                      SizedBox(
                                        width: w * 0.01,
                                      ),
                                      Text(
                                        comments.commentBy ?? "",
                                        style: TextStyle(
                                          color: themeProvider.textColor,
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          height: 18.36 / 16,
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          var res = await commentProvider
                                              .DeleteComment(comments.id ?? "");
                                          if (res == 1) {
                                            CustomSnackBar.show(context,
                                                "Comment Deleted Successfully!");
                                          } else {
                                            CustomSnackBar.show(context,
                                                "Comment Deleted Failed!");
                                          }
                                        },
                                        child: Image.asset(
                                          "assets/delete_icon.png",
                                          fit: BoxFit.contain,
                                          width: w * 0.06,
                                          height: w * 0.045,
                                        ),
                                      ),
                                      // SizedBox(
                                      //   width: w * 0.025,
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
                                  SizedBox(height: 12),
                                  Text(
                                    comments.comment ?? "",
                                    style: TextStyle(
                                      color:
                                          themeProvider.themeData == lightTheme
                                              ? Color(0xff6C848F)
                                              : themeProvider.textColor,
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 20 / 14,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  if (comments.commentFiles != null &&
                                      comments.commentFiles!.isNotEmpty)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          padding: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: Color(0xffF5E6FE),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Image.asset(
                                            "assets/gallery.png",
                                            fit: BoxFit.contain,
                                            color: Color(0xffBE63F9),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: w * 0.45,
                                          child: Text(
                                            comments.commentFiles![0]
                                                    .fileName ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 21.78 / 15,
                                              color: themeProvider.themeData ==
                                                      lightTheme
                                                  ? Color(0xff1D1C1D)
                                                  : themeProvider.textColor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            focusScopeNode.unfocus();
                                            _showBottomSheet(
                                                context,
                                                comments.commentFiles!,
                                                comments.createdTime,
                                                comments.comment);
                                          },
                                          child: Text(
                                            "Click to view",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              height: 16.94 / 14,
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Inter',
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  Color(0xff8856F4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(color: themeProvider.containerbcColor),
        child: Row(
          children: [
            InkResponse(
              onTap: () {
                setState(() {
                  _commentController.text = "";
                  _imageFile = null;
                  filepath = null;
                  filename = "";
                  // commentProvider.imageList = [];
                });
              },
              child: Container(
                height: 40,
                width: w * 0.43,
                decoration: BoxDecoration(
                  color: themeProvider.containerbcColor,
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
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
                setState(() async {
                  validatecomment = _commentController.text.isEmpty
                      ? "Please enter comment"
                      : "";
                  // _validatefile = _imageList.length == 0 ? "Please select a file" : "";
                  isSaving = validatecomment.isEmpty;
                  if (isSaving) {
                    isSaving = false;
                    var res = await commentProvider.SendComments(
                        _commentController.text, widget.id);
                    if (res == 1) {
                      _commentController.text = "";
                      CustomSnackBar.show(
                          context, "Comment Added Successfully!");
                    } else {
                      CustomSnackBar.show(context, "Comment Added Failed!");
                    }
                  } else {
                    isSaving = false;
                  }
                });
              },
              child: Container(
                height: 40,
                width: w * 0.43,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: isSaving
                      ? spinkit.getFadingCircleSpinner()
                      : Text(
                          'Submit',
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
      ),
    );
  }

  Widget _buildShimmerList() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      itemCount: 5,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  shimmerCircle(30, context), // Shimmer for user image
                  const SizedBox(width: 8),
                  shimmerText(100, 16, context), // Shimmer for user name
                  const Spacer(),
                  shimmerRectangle(20, context), // Shimmer for delete icon
                ],
              ),
              const SizedBox(height: 12),
              shimmerText(200, 14, context), // Shimmer for comment text
              const SizedBox(height: 20),
              if (index % 2 == 0) // Show files for some shimmer items
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerRectangle(20, context), // Shimmer for file icon
                    const SizedBox(width: 8),
                    shimmerText(120, 15, context), // Shimmer for file name
                    const Spacer(),
                    shimmerText(
                        80, 14, context), // Shimmer for "Click to view" text
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, List<CommentFiles> files,
      String? createdTime, String? comment) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    String? selectedImage = files.isNotEmpty ? files[0].file.toString() : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: h * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "View Comments",
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
                  // Image List
                  Container(
                    height: h * 0.080,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final commentfiles = files[index];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImage = commentfiles.file.toString();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            width: w * 0.18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selectedImage == commentfiles.file
                                    ? Color(0xff8856F4)
                                    : Colors.white,
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                commentfiles.file.toString() ?? "",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Date row
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
                        "${createdTime}",
                        style: TextStyle(
                          color: const Color(0xff6C848F),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          height: 19.41 / 15,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: "Inter",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Comment
                  Flexible(
                    child: Container(
                      child: Text(
                        "${comment}",
                        style: TextStyle(
                          color: const Color(0xff141516),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          height: 23 / 15,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Selected image display
                  Container(
                    width: w,
                    height: h * 0.3,

                    child: selectedImage != null
                        ? ClipRect(
                            child: Image.network(
                              selectedImage!,
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
