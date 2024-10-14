import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skill/Services/UserApi.dart';
import 'package:skill/Model/ProjectCommentsModel.dart';
import 'package:path/path.dart' as p;
import 'package:skill/utils/CustomAppBar.dart';

import '../utils/CustomSnackBar.dart';
import '../utils/ShakeWidget.dart';

class ProjectComment extends StatefulWidget {
  final String id;
  ProjectComment({super.key, required this.id});

  @override
  State<ProjectComment> createState() => _ProjectCommentState();
}

class _ProjectCommentState extends State<ProjectComment> {
  TextEditingController _commentController = TextEditingController();
  bool _loading = true;
  final spinkit=Spinkits();

  XFile? _imageFile;
  File? filepath;
  String filename = "";

  @override
  void initState() {
    GetProjectCommentsApi();
    super.initState();
  }

  String validatecomment = "";
  String _validatefile = "";

  List<Data> data = [];
  Future<void> GetProjectCommentsApi() async {
    var res = await Userapi.GetProjectComments(widget.id);
    setState(() {

      if (res != null) {
        _loading=false;
        if (res.settings?.success==1) {

          data = res.data ?? [];
        } else {

          CustomSnackBar.show(context,res.settings?.message??"");
        }
      } else {
        _loading=false;
        print("not fetch");
      }
    });
  }

  Future<void> SendComments() async {
    var res = await Userapi.sendComment(_commentController.text,widget.id,_imageList);
    setState(() {
      if (res != null) {
        _loading=false;
        if (res.data != null) {
          CustomSnackBar.show(context,"${res.settings?.message}");
          _imageList=[];
          _commentController.text="";
          GetProjectCommentsApi();
        } else {
          CustomSnackBar.show(context,"${res.settings?.message}");
        }
      } else {
        _loading=false;
        print("not fetch");
      }
    });
  }

  List<XFile> _imageList = [];
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
        _imageList.add(selectedImage); // Append the selected image to the list
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
    return Scaffold(
      backgroundColor: const Color(0xffEFE2FF).withOpacity(0.1),
      resizeToAvoidBottomInset: true,
      body:
      _loading
          ? Center(
              child: CircularProgressIndicator(
              color: Color(0xff8856F4),
            ))
          :
      Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            color: Color(0xff141516),
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
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xffE8ECFF))),
                          child: TextFormField(
                            cursorColor: Color(0xff8856F4),
                            scrollPadding: const EdgeInsets.only(top: 5),
                            controller: _commentController,
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
                                              leading:
                                                  Icon(Icons.photo_library),
                                              title:
                                                  Text('Choose from gallery'),
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
                                    color: Color(0xffF8FCFF),
                                    border: Border.all(
                                      color: Color(0xff8856F4),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Upload File',
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
                              if (_imageList.isNotEmpty) ...[
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        SizedBox(width: 5),
                                        for (int i = 0;
                                            i < _imageList.length;
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
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: FileImage(File(
                                                          _imageList[i].path)),
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
                                                        _imageList.removeAt(i);
                                                      });
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xFFE8ECFF),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        20))),
                                                        padding:
                                                            EdgeInsets.all(2.0),
                                                        child: Icon(Icons.clear,
                                                            size: 15,
                                                            color: Color(
                                                                0xff6977C2)))),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]else...[
                                Center(
                                  child: Text(
                                    'No File Chosen',
                                    style: TextStyle(
                                      color: Color(0xff3C3C3C),
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final comments = data[index];

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display user image and name
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
                                      color: Color(0xff000000),
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 18.36 / 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                comments.comment ?? "",
                                style: TextStyle(
                                  color: Color(0xff6C848F),
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
                                    Container(
                                      width: w * 0.45,
                                      child: Text(
                                        comments.commentFiles![0].fileName ??
                                            "",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          height: 21.78 / 15,
                                          color: Color(0xff1D1C1D),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
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
                                          color: Color(0xff8856F4),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xff8856F4),
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
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            Container(
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
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xff8856F4),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            Spacer(),
            InkResponse(
              onTap: () {
                setState(() {

                  validatecomment = _commentController.text.isEmpty
                      ? "Please enter comment"
                      : "";
                  _validatefile = _imageList.length == 0 ? "Please select a file" : "";
                   _loading =
                      validatecomment.isEmpty && _validatefile.isEmpty;
                  if (_loading) {
                    SendComments();
                  } else {

                  }
                });
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
                  _loading?spinkit.getFadingCircleSpinner():
                  Text(
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
                  // Title and close button
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
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/delete_icon.png",
                        fit: BoxFit.contain,
                        width: w * 0.06,
                        height: w * 0.045,
                      ),
                      SizedBox(
                        width: w * 0.025,
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

                  Spacer(),
                  Positioned(
                    bottom: 0,
                    child: Row(
                      children: [
                        Container(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/conatainer_close.png",
                                fit: BoxFit.contain,
                                width: w * 0.06,
                                height: w * 0.05,
                                color: Color(0xff8856F4),
                              ),
                              SizedBox(
                                width: 0.02,
                              ),
                              Text(
                                'Close',
                                style: TextStyle(
                                  color: Color(0xff8856F4),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        InkResponse(
                          onTap: () {
                            // _validateFields();
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/container_correct.png",
                                  fit: BoxFit.contain,
                                  width: w * 0.06,
                                  height: w * 0.05,
                                ),
                                SizedBox(
                                  width: 0.01,
                                ),
                                _loading?spinkit.getFadingCircleSpinner():
                                Text(
                                  'Okay',
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
