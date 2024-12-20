import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skill/Authentication/Otp.dart';
import 'package:skill/screens/dashboard.dart';

import '../Providers/ConnectivityProviders.dart';
import '../Services/UserApi.dart';
import '../Services/otherservices.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Preferances.dart';
import '../utils/ShakeWidget.dart';
import 'LogInScreen.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  // Text Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  // Focus nodes
  final FocusNode _focusNodeFirstName = FocusNode();
  final FocusNode _focusNodeLastName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  bool _obscureText = true;

  String _validateFirstName = "";
  String _validateLastName = "";
  String _validateemail = "";
  String _validatePhone = "";
  String _validatePwd = "";
  String _validateGender = "";

  String get Fullname {
    return "${_firstNameController.text} ${_lastNameController.text}".trim();
  }

  @override
  void initState() {
    Provider.of<ConnectivityProviders>(context, listen: false)
        .initConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }

  final spinkit = Spinkits();

  String _gender = "";
  bool _loading = false;
  void _validateFields() {
    setState(() {
      _validateFirstName = _validateField(
          _firstNameController.text, "Please enter a first name");
      _validateLastName =
          _validateField(_lastNameController.text, "Please enter a last name");
      _validateemail =
          _validateEmail(_emailController.text, "Please enter a valid email");
      _validatePhone = _validatePhoneNumber(
          _phoneController.text, "Please enter a valid phone number");
      _validatePwd =
          _validateField(_pwdController.text, "Please enter a password");
      _validateGender =
          _validategender(_gender?.isEmpty == true, "Please select a gender");
    });

    if (_areFieldsValid()) {
      RegisterApi();
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  String _validateField(String value, String errorMessage) {
    return value.isEmpty ? errorMessage : "";
  }

  String _validateEmail(String value, String errorMessage) {
    if (value.isEmpty) {
      return errorMessage; // Return error if empty
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return errorMessage; // Return error if not a valid email
    }
    return ""; // Return an empty string if validation passes
  }

  String _validategender(bool value, String errorMessage) {
    return value ? errorMessage : "";
  }

  String _validatePhoneNumber(String value, String errorMessage) {
    return value.isEmpty || value.length < 10 ? errorMessage : "";
  }

  bool _areFieldsValid() {
    return _validateFirstName.isEmpty &&
        _validateLastName.isEmpty &&
        _validateemail.isEmpty &&
        _validatePhone.isEmpty &&
        _validatePwd.isEmpty &&
        _validateGender.isEmpty;
  }

  Future<void> RegisterApi() async {
    var data = await Userapi.PostRegister(Fullname, _emailController.text,
        _phoneController.text, _pwdController.text, _gender ?? "");
    if (data != null) {
      setState(() {
        if (data.settings?.success == 1) {
          _loading = false;
          CustomSnackBar.show(context, "${data.settings?.message}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Otp(
                        email: _emailController.text,
                        mobile: _phoneController.text,
                      )));
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) =>LogInScreen()));
        } else {
          _loading = false;
          CustomSnackBar.show(context, "${data.settings?.message}");
          print("Register failure");
        }
      });
    } else {
      print("Register >>>${data?.settings?.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
            connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
            backgroundColor: const Color(0xffF3ECFB),
            resizeToAvoidBottomInset: true,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: h * 0.45,
                      width: w,
                      decoration: const BoxDecoration(
                          color: Color(0xff8856F4),
                          image: DecorationImage(
                              image: AssetImage("assets/Background.png"),
                              fit: BoxFit.cover)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: w * 0.20,
                          ),
                          Image.asset(
                            "assets/skillLogo.png",
                            height: h * 0.06,
                            fit: BoxFit.contain,
                            alignment: Alignment.topCenter,
                          ),
                          const SizedBox(height: 18),
                          SingleChildScrollView(
                            child: SizedBox(
                              // width: 221,
                              child: Text(
                                'Personal information',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 25,
                                  color: Color(0xffEEEEEE),
                                  fontWeight: FontWeight.w700,
                                  height: 38.4 / 32,
                                  letterSpacing: -0.02,
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 8),
                          // Text(
                          //   'Personal information',
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //     fontFamily: 'Inter',
                          //     fontSize: 10,
                          //     color: Color(0xffEEEEEE),
                          //     fontWeight: FontWeight.w500,
                          //     height: 16.8 / 10,
                          //     letterSpacing: -0.01,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: h * 0.3,
                  left: w * 0.08,
                  right: w * 0.08,
                  bottom: w * 0.08,
                  child: SingleChildScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
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
                                  padding: EdgeInsets.only(
                                      top: 14, bottom: 14, left: 6),
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
                                fontSize:
                                    14, // Ensure font size fits within height
                                overflow: TextOverflow
                                    .ellipsis, // Add ellipsis for long text
                              ),
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                          if (_validateFirstName.isNotEmpty) ...[
                            Container(
                              alignment: Alignment.topLeft,
                              margin:
                                  EdgeInsets.only(left: 8, bottom: 10, top: 5),
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
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
                                  padding: EdgeInsets.only(
                                      top: 12, bottom: 12, left: 6),
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
                                fontSize:
                                    14, // Ensure font size fits within height
                                overflow: TextOverflow
                                    .ellipsis, // Add ellipsis for long text
                              ),
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                          if (_validateLastName.isNotEmpty) ...[
                            Container(
                              alignment: Alignment.topLeft,
                              margin:
                                  EdgeInsets.only(left: 8, bottom: 10, top: 5),
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
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
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 6),
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
                                fontSize:
                                    14, // Ensure font size fits within height
                                overflow: TextOverflow
                                    .ellipsis, // Add ellipsis for long text
                              ),
                              textAlignVertical: TextAlignVertical
                                  .center, // Vertically center the text
                            ),
                          ),
                          if (_validateemail.isNotEmpty) ...[
                            Container(
                              alignment: Alignment.topLeft,
                              margin:
                                  EdgeInsets.only(left: 8, bottom: 10, top: 5),
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
                          Container(
                            height: MediaQuery.of(context).size.height * 0.050,
                            child: TextFormField(
                              controller: _phoneController,
                              focusNode: _focusNodePhone,
                              keyboardType: TextInputType.phone,
                              cursorColor: Color(0xff8856F4),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
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
                                  padding: EdgeInsets.only(
                                      top: 12, bottom: 12, left: 6),
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
                                fontSize:
                                    14, // Ensure font size fits within height
                                overflow: TextOverflow
                                    .ellipsis, // Add ellipsis for long text
                              ),
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                          if (_validatePhone.isNotEmpty) ...[
                            Container(
                              alignment: Alignment.topLeft,
                              margin:
                                  EdgeInsets.only(left: 8, bottom: 10, top: 5),
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
                          Container(
                            height: MediaQuery.of(context).size.height * 0.050,
                            child: TextFormField(
                              obscureText: _obscureText,
                              controller: _pwdController,
                              focusNode: _focusNodePassword,
                              keyboardType: TextInputType.text,
                              cursorColor: Color(0xff8856F4),
                              onTap: () {
                                setState(() {
                                  _validatePwd = "";
                                });
                              },
                              onChanged: (v) {
                                setState(() {
                                  _validatePwd = "";
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                hintText: "Enter Password",
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
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 6),
                                  child: Image.asset(
                                    "assets/Lock.png",
                                    width: 21,
                                    height: 21,
                                    fit: BoxFit.contain,
                                    color: Color(0xffAFAFAF),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xffAFAFAF),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText =
                                          !_obscureText; // Toggle the visibility
                                    });
                                  },
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
                                fontSize:
                                    14, // Ensure font size fits within height
                                overflow: TextOverflow
                                    .ellipsis, // Add ellipsis for long text
                              ),
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                          if (_validatePwd.isNotEmpty) ...[
                            Container(
                              alignment: Alignment.topLeft,
                              margin:
                                  EdgeInsets.only(left: 8, bottom: 10, top: 5),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: ShakeWidget(
                                key: Key("value"),
                                duration: Duration(milliseconds: 700),
                                child: Text(
                                  _validatePwd,
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
                          Text(
                            "Gender",
                            style: TextStyle(
                              color: Color(0xff1C1C1C),
                              fontFamily: "Inter",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 19.36 / 12,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.9,
                                    child: Radio<String>(
                                      value: 'Female',
                                      groupValue: _gender,
                                      activeColor: Color(
                                          0xff8856F4), // Change the active color
                                      onChanged: (value) {
                                        setState(() {
                                          _gender = value!;
                                        });
                                      },
                                    ),
                                  ), // Decrease the space between the Radio and the Text
                                  Text('Female'),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale:
                                        0.9, // Adjust the scale to decrease the size
                                    child: Radio<String>(
                                      value: 'Male',
                                      groupValue: _gender,
                                      activeColor: Color(
                                          0xff8856F4), // Change the active color
                                      onChanged: (value) {
                                        setState(() {
                                          _gender = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  // Decrease the space between the Radio and the Text
                                  const Text('Male'),
                                ],
                              ),
                            ],
                          ),
                          if (_validateGender.isNotEmpty) ...[
                            Container(
                              alignment: Alignment.topLeft,
                              margin:
                                  EdgeInsets.only(left: 8, bottom: 10, top: 5),
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
                          const SizedBox(height: 8),
                          InkResponse(
                            onTap: () {
                              if (_loading) {
                              } else {
                                setState(() {
                                  _loading = true;
                                });
                                _validateFields();
                              }
                            },
                            child: Container(
                              width: w,
                              height: w * 0.1,
                              decoration: BoxDecoration(
                                color: const Color(0xff8856F4),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: _loading
                                    ? spinkit.getFadingCircleSpinner()
                                    : Text(
                                        "Continue",
                                        style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          height: 20 / 16,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: Color(0xff6C7278),
                                  fontWeight: FontWeight.w400,
                                  height: 19.6 / 14,
                                  letterSpacing: -0.01,
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LogInScreen()));
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xff8856F4),
                                    color: Color(0xff8856F4),
                                    fontWeight: FontWeight.w600,
                                    height: 19.6 / 12,
                                    letterSpacing: -0.01,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : NoInternetWidget();
  }
}
