import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:skill/Authentication/ResetPassword.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode focusNodeOTP = FocusNode();

  bool _isOtpVisible = false; // To control OTP field visibility
  bool _loading =false;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      resizeToAvoidBottomInset: true,
      body:
      Stack(
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
                        width: 150,
                        child: Text(
                          'Forgot Password',
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
                      'Personal information',
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
                    _buildTextFormField(
                      controller: _emailController,
                      focusNode: _focusNodeEmail,
                      hintText: "Email Address",
                      validationMessage: 'Please enter your email',
                      prefixicon: Image.asset(
                        "assets/gmail.png",
                        width: 21,
                        height: 21,
                        fit: BoxFit.contain,
                        color: Color(0xffAFAFAF),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isOtpVisible) ...[
                      Center(
                        child: Text(
                          "Enter OTP",
                          style: TextStyle(
                            color: Color(0xff1C1D22),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 19.36 / 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      PinCodeTextField(
                        appContext: context,
                        length: 5,
                        focusNode: focusNodeOTP,
                        controller: otpController,
                        autoFocus: true,

                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(7),
                          fieldHeight: 40,
                          fieldWidth: 40,
                          activeFillColor: Color(0xFFD0CBDB),
                          inactiveFillColor: Color(0xFFD0CBDB),
                          selectedFillColor:Color(0xFFD0CBDB),
                        ),
                        textStyle: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                        cursorColor: Color(0xff8856F4),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                    SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_isOtpVisible) {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassword()));

                          } else {
                            _isOtpVisible = true;

                          }
                        });
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
                          _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
                          Text(
                            _isOtpVisible ? "Reset Password" : "Send Otp",
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required FocusNode focusNode,
    bool obscureText = false,
    required String hintText,
    required String validationMessage,
    TextInputType keyboardType = TextInputType.text,
    Widget? prefixicon,
  }) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixicon != null
              ? Container(
            width: 21,
            height: 21,
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 10),
            child: prefixicon,
          )
              : null,
          hintStyle: const TextStyle(
            fontSize: 15,
            letterSpacing: 0,
            height: 1.2,
            color: Color(0xffAFAFAF),
            fontFamily: 'Poppins',
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
