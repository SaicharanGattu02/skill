import 'package:flutter/material.dart';

import '../utils/CustomSnackBar.dart';
import '../utils/ShakeWidget.dart';

class GeneralInfo extends StatefulWidget {
  const GeneralInfo({super.key});

  @override
  State<GeneralInfo> createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _linkdnController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Focus nodes
  final FocusNode _focusNodeFirstName = FocusNode();
  final FocusNode _focusNodeLastName = FocusNode();
  final FocusNode _focusNodeLinkdn = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();
  final FocusNode _focusNodeAddress = FocusNode();

  String _validateFirstName = "";
  String _validateLastName = "";
  String _validateLinkdn = "";
  String _validatePhone = "";
  String _validateAddress = "";
  String _validateGender = "";
  String _gender = "";

  bool _isLoading = false;

  final spinkit = Spinkits();

  void _validateFields() {
    setState(() {
      _validateFirstName =
          _firstNameController.text.isEmpty ? "Please enter a firstName" : "";
      _validateLastName =
          _lastNameController.text.isEmpty ? "Please enter a lastName" : "";
      _validateLinkdn = _linkdnController.text.isEmpty
          ? "Please enter a valid linkdn url"
          : "";
      _validatePhone =
          _phoneController.text.isEmpty ? "Please enter a phonenumber" : "";
      _validateAddress =
          _addressController.text.isEmpty ? "Please enter a address" : "";
    });

    if (_validateFirstName.isEmpty &&
        _validateLastName.isEmpty &&
        _validateLinkdn.isEmpty &&
        _validatePhone.isEmpty) {
      // UpdateProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffF3ECFB),
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(7)),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label(text: 'First Name'),
                SizedBox(height: 6),
                Container(
                  height: MediaQuery.of(context).size.height * 0.055,
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                        padding:
                            EdgeInsets.only(top: 14, bottom: 14, left: 6),
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
                      fontSize: 14, // Ensure font size fits within height
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis for long text
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                if (_validateFirstName.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
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
                  height: MediaQuery.of(context).size.height * 0.050,
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                        padding:
                            EdgeInsets.only(top: 12, bottom: 12, left: 6),
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
                      fontSize: 14, // Ensure font size fits within height
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis for long text
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                if (_validateLastName.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
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
                _label(text: 'Gender'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.9,
                          child: Radio<String>(
                            value: 'Male',
                            groupValue: _gender,
                            activeColor:
                                Color(0xff8856F4), // Change the active color
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ), // Decrease the space between the Radio and the Text
                        Text('Male',
                            style: TextStyle(
                                color: Color(0xff4A4A4A),
                                fontFamily: 'Inter',
                                fontSize: 14,
                                height: 16.36 / 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.9, // Adjust the scale to decrease the size
                          child: Radio<String>(
                            value: 'FeMale',
                            groupValue: _gender,
                            activeColor:
                                Color(0xff8856F4), // Change the active color
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ),
                        // Decrease the space between the Radio and the Text
                        const Text('FeMale',
                            style: TextStyle(
                                color: Color(0xff4A4A4A),
                                fontFamily: 'Inter',
                                fontSize: 14,
                                height: 16.36 / 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.9, // Adjust the scale to decrease the size
                          child: Radio<String>(
                            value: 'Other',
                            groupValue: _gender,
                            activeColor:
                            Color(0xff8856F4), // Change the active color
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ),
                        // Decrease the space between the Radio and the Text
                        const Text('Other',
                            style: TextStyle(
                                color: Color(0xff4A4A4A),
                                fontFamily: 'Inter',
                                fontSize: 14,
                                height: 16.36 / 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ],
                ),
                if (_validateGender.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateGender,
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
                  height: MediaQuery.of(context).size.height * 0.050,
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                        padding:
                            EdgeInsets.only(top: 12, bottom: 12, left: 6),
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
                      fontSize: 14, // Ensure font size fits within height
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis for long text
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                if (_validatePhone.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
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
                _label(text: 'Linkedin'),
                SizedBox(height: 6),
                Container(
                  height: MediaQuery.of(context).size.height * 0.050,
                  child: TextFormField(
                    controller: _linkdnController,
                    focusNode: _focusNodeLinkdn,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Color(0xff8856F4),
                    maxLines: 1,
                    onTap: () {
                      setState(() {
                        _validateLinkdn = "";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validateLinkdn = "";
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: "Enter Email Linkdn Url",
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
                        padding:
                            EdgeInsets.only(top: 10, bottom: 10, left: 6),
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
                      fontSize: 14, // Ensure font size fits within height
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis for long text
                    ),
                    textAlignVertical: TextAlignVertical
                        .center, // Vertically center the text
                  ),
                ),
                if (_validateLinkdn.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateLinkdn,
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
                _label(text: 'Address'),
                SizedBox(height: 6),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: TextFormField(
                    controller: _addressController,
                    focusNode: _focusNodeAddress,
                    keyboardType: TextInputType.text,
                    cursorColor: Color(0xff8856F4),
                    maxLines: 1,
                    onTap: () {
                      setState(() {
                        _validateAddress = "";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validateAddress = "";
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: "Enter Address",
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
                        padding:
                            EdgeInsets.only(top: 14, bottom: 14, left: 6),
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
                      fontSize: 14, // Ensure font size fits within height
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis for long text
                    ),
                    textAlignVertical: TextAlignVertical
                        .center, // Vertically center the text
                  ),
                ),
                if (_validateAddress.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateAddress,
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
          )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            InkResponse(
              onTap: (){
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
                _validateFields();
              },
              child:
              Container(
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
                child:
                Center(
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
