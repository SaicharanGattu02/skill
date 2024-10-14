import 'package:flutter/material.dart';
import 'package:skill/screens/ForgotPassword.dart';
import 'package:skill/screens/PersnalInformation.dart';
import 'package:skill/screens/Register.dart';
import 'package:skill/screens/dashboard.dart';

import '../Services/UserApi.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/Preferances.dart';
import '../utils/ShakeWidget.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _isPasswordVisible = false;
  // String token="";
  String _validateEmail = "";
  String _validatePassword = "";
  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();

    super.dispose();
  }

  final spinkit=Spinkits();
  Future<void> LoginApi() async {
    final fcm_token = await PreferenceService().getString("fbstoken") ?? "";
    var data = await Userapi.PostLogin(_emailController.text, _passwordController.text,fcm_token,"android_token");
    if (data != null) {
      setState(() {
        if (data.settings?.success == 1) {
          _loading = false;
          PreferenceService().saveString("token", data.data?.access ?? "");
          CustomSnackBar.show(context, "${data.settings?.message}");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          print("Login failure");
          CustomSnackBar.show(context, "${data.settings?.message}");
        }
      });
    } else {
      print("Login >>>${data?.settings?.message}");
      CustomSnackBar.show(context, "${data?.settings?.message}");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _validateFields() {
    setState(() {
      // Check if the fields are empty and set validation messages accordingly
      _validateEmail =
          _emailController.text.isEmpty ? "Please enter an email address" : "";
      _validatePassword =
          _passwordController.text.isEmpty ? "Please enter a password" : "";
    });

    // Check if both validations are empty (no errors)
    if (_validateEmail.isEmpty && _validatePassword.isEmpty) {
      // Proceed with the API call if validations pass
      LoginApi();
    }else{
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
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
                      image: AssetImage(
                        "assets/Background.png",
                      ),
                      fit: BoxFit.cover),
                ),
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
                        width: 221,
                        child: Text(
                          'Sign up to your Account',
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
                    const SizedBox(height: 8),
                    Text(
                      'Login Your Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: Color(0xffEEEEEE),
                        fontWeight: FontWeight.w500,
                        height: 16.8 / 10,
                        letterSpacing: -0.01,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: h * 0.36,
            left: w * 0.08,
            right: w * 0.08,
            bottom: w * 0.08,
            child: SingleChildScrollView(
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
                            _validateEmail = "";
                          });
                        },
                        onChanged: (v) {
                          setState(() {
                            _validateEmail = "";
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis for long text
                        ),
                        textAlignVertical: TextAlignVertical
                            .center, // Vertically center the text
                      ),
                    ),
                    if (_validateEmail.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateEmail,
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
                    // _buildTextFormField(
                    //     controller: _passwordController,
                    //     focusNode: _focusNodePassword,
                    //     hintText: "Password",
                    //     validationMessage: 'Please select your city',
                    //     prefixicon: Image.asset(
                    //       "assets/Lock.png",
                    //       width: 21,
                    //       height: 21,
                    //       fit: BoxFit.contain,
                    //       color: Color(0xffAFAFAF),
                    //     )),
                    // SizedBox(height: 16),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.050,
                      child: TextFormField(
                        controller: _passwordController,
                        focusNode: _focusNodePassword,
                        keyboardType: TextInputType.text,
                        cursorColor: Color(0xff8856F4),
                        onTap: () {
                          setState(() {
                            _validatePassword = "";
                          });
                        },
                        onChanged: (v) {
                          setState(() {
                            _validatePassword = "";
                          });
                        },
                        decoration: InputDecoration(
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
                            padding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 6),
                            child: Image.asset(
                              "assets/Lock.png",
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
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        ),
                        style: TextStyle(
                          fontSize: 14, // Ensure font size fits within height
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis for long text
                        ),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    if (_validatePassword.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validatePassword,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Container(
                        //   width: w * 0.038,
                        //   height: w * 0.038,
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(3),
                        //       border: Border.all(
                        //         color: Color(0xff9AADB6),
                        //         width: 1.3,
                        //       )),
                        // ),
                        // SizedBox(
                        //   width: w * 0.02,
                        // ),
                        // Text(
                        //   "Remember me",
                        //   style: TextStyle(
                        //     color: Color(0xff70778B),
                        //     fontFamily: "Inter",
                        //     fontSize: 12,
                        //     letterSpacing: -0.01,
                        //     fontWeight: FontWeight.w500,
                        //     height: 21 / 14,
                        //   ),
                        // ),
                        // const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Color(0xff8856F4),
                                fontFamily: "Inter",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 19.06 / 12,
                                letterSpacing: -0.01),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Center(
                    //   child: Text(
                    //     "Login With OTP",
                    //     style: TextStyle(
                    //         color: Color(0xff8856F4),
                    //         fontFamily: "Inter",
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w500,
                    //         height: 19.06 / 12,
                    //         letterSpacing: -0.01),
                    //   ),
                    // ),
                    // const SizedBox(height: 24),
                    InkResponse(
                      onTap: () {
                        if(_loading){

                        }else{
                          setState(() {
                            _loading=true;
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
                          child:
                              _loading?spinkit.getFadingCircleSpinner():
                              Text(
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
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don’t have an account?",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Color(0xff6C7278),
                              fontWeight: FontWeight.w400,
                              height: 19.6 / 12,
                              letterSpacing: -0.01),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PersonalInformation()));
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xff8856F4),
                                color: Color(0xff8856F4),
                                height: 19.6 / 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.01),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField(
      {required TextEditingController controller,
      required FocusNode focusNode,
      bool obscureText = false,
      required String hintText,
      required String validationMessage,
      TextInputType keyboardType = TextInputType.text,
      Widget? prefixicon}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.045,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Container(
              width: 21,
              height: 21,
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 6),
              child: prefixicon),
          hintStyle: const TextStyle(
            fontSize: 14,
            letterSpacing: 0,
            height: 19.36 / 14,
            color: Color(0xffAFAFAF),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: const Color(0xffffffff),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
