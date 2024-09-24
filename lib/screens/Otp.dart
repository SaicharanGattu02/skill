import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skill/screens/LogInScreen.dart';

import 'dashboard.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final TextEditingController _emailOtpController = TextEditingController();
  final TextEditingController _smsOtpController = TextEditingController();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeSms = FocusNode();

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
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/skillLogo.png",
                      height: h * 0.06,
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                    ),
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      child: SizedBox(
                        width: 221,
                        child: Text(
                          'Enter OTP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 32,
                            color: Color(0xffEEEEEE),
                            fontWeight: FontWeight.w700,
                            height: 38.4 / 32,
                            letterSpacing: -0.02,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: h * 0.35,
            left: w * 0.1,
            right: w * 0.1,
            bottom: w * 0.1,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFormField(
                      controller: _emailOtpController,
                      focusNode: _focusNodeEmail,
                      hintText: "Enter Email Otp",
                      validationMessage: 'Please enter your first name',
                      keyboardType: TextInputType.text,
                      prefixicon: Image.asset(
                        "assets/gmail.png",
                        width: 21,
                        height: 21,
                        fit: BoxFit.contain,
                        color: Color(0xffAFAFAF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Resend',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 19.6 / 14,
                            letterSpacing: -0.01 * 16,
                            color: Color(0xff8856F4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildTextFormField(
                      controller: _smsOtpController,
                      focusNode: _focusNodeSms,
                      hintText: "Enter SMS Otp",
                      validationMessage: 'Please enter your last size',
                      prefixicon: Image.asset(
                        "assets/call.png",
                        width: 21,
                        height: 21,
                        fit: BoxFit.contain,
                        color: Color(0xffAFAFAF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'OTP Resent On Phone',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 19.6 / 14,
                            letterSpacing: -0.01 * 16,
                            color: Color(0xff8856F4),
                          ),
                        ),
                        Text(
                          'Resend',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 19.6 / 14,
                            letterSpacing: -0.01 * 16,
                            color: Color(0xff8856F4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogInScreen()));
                      },
                      child: Container(
                        width: w,
                        decoration: BoxDecoration(
                          color: const Color(0xff8856F4),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          child: const Text(
                            "Continue",
                            textAlign: TextAlign.center,
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
    Widget? sufexicon,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
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
              padding: EdgeInsets.only(top: 12, bottom: 12, left: 10),
              child: prefixicon),
          suffixIcon: Container(
            height: 20,
            width: 50,
            margin: EdgeInsets.only(top: 8, bottom: 8, right: 5),
            decoration: BoxDecoration(
                color: Color(0xffE2FDF2), borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                'Verify',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 19.2 / 12,
                  letterSpacing: 0.14,
                  color: Color(0xff2A9266),
                ),
              ),
            ),
          ),
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
