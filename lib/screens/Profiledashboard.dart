
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill/Services/UserApi.dart';
import 'package:skill/utils/CustomAppBar.dart';
import 'package:skill/utils/CustomSnackBar.dart';

import '../Model/UserDetailsModel.dart';
import '../utils/Preferances.dart';
import '../utils/ShakeWidget.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Focus nodes
  final FocusNode _focusNodeFirstName = FocusNode();
  final FocusNode _focusNodeLastName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();


  String _validateFirstName="";
  String _validateLastName="";
  String _validateemail="";
  String _validatePhone="";
  String _validateimage="";

  int image_selected=0;

final spinkit=Spinkits();

  String get Fullname {
    return "${_firstNameController.text} ${_lastNameController.text}".trim();
  }


  File? _image;
  XFile? _pickedFile;
  CroppedFile? _croppedFile;


  bool _isLoading= false;
  void _validateFields() {
    setState(() {
      _validateFirstName = _firstNameController.text.isEmpty
          ? "Please enter a firstName"
          : "";
      _validateLastName = _lastNameController.text.isEmpty
          ? "Please enter a lastName"
          : "";
      _validateemail = _emailController.text.isEmpty
          ? "Please enter a valid email"
          : "";
      _validatePhone = _phoneController.text.isEmpty
          ? "Please enter a phonenumber"
          : "";
      _validateimage = _image==null && image_selected==1
          ? "Please select the image."
          : "";
    });

    if (_validateFirstName.isEmpty && _validateLastName.isEmpty&&_validateemail.isEmpty&& _validatePhone.isEmpty && (image_selected==1 || _validateimage.isEmpty)) {
      UpdateProfile();
    }
  }



  Future<void> UpdateProfile() async {
    var res = await Userapi.UpdateUserDetails(Fullname, _phoneController.text,_image);
    if (res != null) {
      if (res.settings?.success == 1) {
        Navigator.pop(context, true);
        CustomSnackBar.show(context, "${res.settings?.message}");
      } else {
        print("Update failure: ${res.settings?.message}");
        CustomSnackBar.show(context, "${res.settings?.message}");
      }
    } else {
      print("Update failed: ${res?.settings?.message}");
      CustomSnackBar.show(context, "${res?.settings?.message}");
    }
  }


  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _pickedFile = pickedFile;
        image_selected=1;
      });
    }
  }


  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Color(0xff8856F4),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPresetCustom(),
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPresetCustom(),
            ],
          ),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
            size: const CropperSize(
              width: 520,
              height: 520,
            ),
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
          _image= File(_croppedFile!.path);
        });
      }
    }
  }

  @override
  void initState() {
    GetUserDeatails();
    super.initState();
  }

  UserData? userdata;
  Future<void> GetUserDeatails() async {
    var res = await Userapi.GetUserdetails();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          _isLoading=false;
          userdata = res.data;
          final fullName = res.data?.fullName ?? "";
          final nameParts = fullName.split(' ');

          // Set first name and last name accordingly
          if (nameParts.length > 0) {
            _firstNameController.text = nameParts[0]; // Set first name
          }
          if (nameParts.length > 1) {
            _lastNameController.text = nameParts.sublist(1).join(' '); // Set last name
          } else {
            _lastNameController.text = ""; // Clear last name if no last part
          }

          _phoneController.text = res.data?.mobile ?? "";
          _emailController.text = res.data?.email ?? "";

          PreferenceService().saveString("user_id", userdata?.id ?? "");
        } else {
          _isLoading=false;
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      resizeToAvoidBottomInset: true,
      appBar:CustomAppBar(title: 'Update Profile', actions: [Container()]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25,),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        backgroundImage: _croppedFile != null
                            ? FileImage(File(_croppedFile!.path))
                            : _pickedFile != null
                            ? FileImage(File(_pickedFile!.path))
                            : userdata?.image != null && userdata!.image!.isNotEmpty
                            ? NetworkImage(userdata!.image!)
                            : AssetImage('assets/avatar_placeholder.png') as ImageProvider,
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit, color:Color(0xFF8856F4),size: 18,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                if(_pickedFile!=null)...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (_croppedFile == null)
                        Container(
                          width: 46, // Adjust the width as needed
                          height: 46, // Adjust the height as needed
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: const Color(0xFF8856F4), // Background color
                          ),
                          child: InkWell(
                            onTap: () {
                              _cropImage();
                            },
                            borderRadius: BorderRadius.circular(28), // To match the circular shape
                            child: const Icon(
                              Icons.crop,
                              color: Colors.white, // Icon color
                            ),
                          ),
                        ),
                    ],
                  ),

                ],
                SizedBox(height: 12),
                _label(text: 'First Name'),
                SizedBox(height: 6),

                Container(
                  height:
                  MediaQuery.of(context).size.height * 0.055,
                  child: TextFormField(
                    controller: _firstNameController,
                    focusNode: _focusNodeFirstName,
                    keyboardType: TextInputType.text,
                    cursorColor: Color(0xff8856F4),
                    onTap: () {
                      setState(() {
                        _validateFirstName = "";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validateFirstName = "";
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: "Enter FirstName",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 19.36 / 14,
                        color: Color(0xffAFAFAF),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Container(
                        width: 18,
                        height: 18,
                        padding: EdgeInsets.only(top: 14, bottom: 14, left: 6),
                        child: Image.asset(
                          "assets/profilep.png",
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        ),
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
                    style: TextStyle(
                      fontSize: 14,  // Ensure font size fits within height
                      overflow: TextOverflow.ellipsis,  // Add ellipsis for long text
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                if (_validateFirstName.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateFirstName,
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
                  SizedBox(height: 8),
                ],
                _label(text: 'Last Name'),
                SizedBox(height: 6),

                Container(
                  height:
                  MediaQuery.of(context).size.height * 0.050,
                  child: TextFormField(
                    controller: _lastNameController,
                    focusNode: _focusNodeLastName,
                    keyboardType: TextInputType.text,
                    cursorColor: Color(0xff8856F4),
                    onTap: () {
                      setState(() {
                        _validateLastName = "";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validateLastName = "";
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: "Enter Last Name",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 19.36 / 14,
                        color: Color(0xffAFAFAF),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Container(
                        width: 21,
                        height: 21,
                        padding: EdgeInsets.only(top: 12, bottom: 12, left: 6),
                        child: Image.asset(
                          "assets/profilep.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        ),
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
                    style: TextStyle(
                      fontSize: 14,  // Ensure font size fits within height
                      overflow: TextOverflow.ellipsis,  // Add ellipsis for long text
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                if (_validateLastName.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateLastName,
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
                  SizedBox(height: 8),
                ],

                _label(text: 'Phone Number'),
                SizedBox(height: 6),
                Container(
                  height:
                  MediaQuery.of(context).size.height * 0.050,
                  child: TextFormField(
                    controller: _phoneController,
                    focusNode: _focusNodePhone,
                    keyboardType: TextInputType.phone,
                    cursorColor: Color(0xff8856F4),
                    onTap: () {
                      setState(() {
                        _validatePhone = "";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validatePhone = "";
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: "Phone Number",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 19.36 / 14,
                        color: Color(0xffAFAFAF),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Container(
                        width: 21,
                        height: 21,
                        padding: EdgeInsets.only(top: 12, bottom: 12, left: 6),
                        child: Image.asset(
                          "assets/call.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        ),
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
                    style: TextStyle(
                      fontSize: 14,  // Ensure font size fits within height
                      overflow: TextOverflow.ellipsis,  // Add ellipsis for long text
                    ),
                    textAlignVertical: TextAlignVertical.center,

                  ),
                ),
                if (_validatePhone.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validatePhone,
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
                  SizedBox(height: 8),
                ],
                _label(text: 'Email'),
                SizedBox(height: 6),
                Container(
                  height: MediaQuery.of(context).size.height * 0.050,
                  child: TextFormField(
                    controller: _emailController,
                    focusNode: _focusNodeEmail,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Color(0xff8856F4),
                    maxLines: 1,
                    onTap: () {
                      setState(() {
                        _validateemail = "";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validateemail = "";
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: "Enter Email Address",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 19.36 / 14,
                        color: Color(0xffAFAFAF),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Container(
                        width: 21,
                        height: 21,
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 6),
                        child: Image.asset(
                          "assets/gmail.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        ),
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
                    style: TextStyle(
                      fontSize: 14,  // Ensure font size fits within height
                      overflow: TextOverflow.ellipsis,  // Add ellipsis for long text
                    ),
                    textAlignVertical: TextAlignVertical.center,  // Vertically center the text
                  ),
                ),
                if (_validateemail.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateemail,
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
                  SizedBox(height: 8),
                ],


              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            InkResponse(
              onTap: (){
                Navigator.pop(context,true);
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
                _validateFields();
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
                  child: _isLoading
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
      ),

    );
  }
  Widget _label({
    required String text,
  }) {
    return Text(text,
        style: TextStyle(
            color: Color(0xff141516),
            fontFamily: 'Inter',
            fontSize: 14,
            height: 16.36 / 14,
            fontWeight: FontWeight.w400));
  }
}
