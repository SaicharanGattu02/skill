import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skill/screens/LogInScreen.dart';

import '../Services/UserApi.dart';
import '../screens/dashboard.dart';
import '../utils/CustomSnackBar.dart';

class Otp extends StatefulWidget {
  final String email;
  final String mobile;

  const Otp({Key? key, required this.email, required this.mobile}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final TextEditingController _emailOtpController = TextEditingController();
  final TextEditingController _smsOtpController = TextEditingController();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeSms = FocusNode();

  bool email_verified=false;
  bool mobile_verified=false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> VerifyEmailApi() async {
    var data = await Userapi.VerifyEmail(widget.email, _emailOtpController.text);
    if (data != null) {
      setState(() {
        if (data.settings?.success == 1) {
          email_verified=true;
          CustomSnackBar.show(context, "${data.settings?.message}");
        } else {
          CustomSnackBar.show(context, "${data.settings?.message}");
        }
      });
    } else {
    }
  }

  Future<void> VerifyMobileApi() async {
    var data = await Userapi.VerifyMobile(widget.mobile, _smsOtpController.text);
    if (data != null) {
      setState(() {
        if (data.settings?.success == 1) {
          mobile_verified=true;
          CustomSnackBar.show(context, "${data.settings?.message}");
        } else {
          CustomSnackBar.show(context, "${data.settings?.message}");
        }
      });
    } else {
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
                          'Enter OTP',
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
              physics: NeverScrollableScrollPhysics(),
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
                      controller: _emailOtpController,
                      focusNode: _focusNodeEmail,
                      hintText: "Enter Email Otp",
                      validationMessage: 'Please enter your first name',
                      prefixicon: Image.asset(
                        "assets/gmail.png",
                        width: 21,
                        height: 21,
                        fit: BoxFit.contain,
                        color: Color(0xffAFAFAF),
                      ),
                    ),
                     SizedBox(height: w*0.004),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Resend',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 19.6 / 12,
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
                     SizedBox(height: w*0.004),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'OTP Resent On Phone',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 19.6 / 12,
                            letterSpacing: -0.01 * 16,
                            color: Color(0xff8856F4),
                          ),
                        ),
                        Text(
                          'Resend',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 19.6 / 12,
                            letterSpacing: -0.01,
                            color: Color(0xff8856F4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        if(email_verified && mobile_verified){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogInScreen()));
                        }
                      },
                      child: Container(
                        width: w,
                        height: w * 0.1,
                        decoration: BoxDecoration(
                          color: const Color(0xff8856F4),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child:  Center(
                          child: Text(
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
    Widget? prefixicon,
    Widget? sufexicon,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.045,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.phone,
        obscureText: obscureText,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6)
        ],
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Container(
              width: 21,
              height: 21,
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 6),
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
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 19.2 / 10,
                  letterSpacing: 0.14,
                  color: Color(0xff2A9266),
                ),
              ),
            ),
          ),
          hintStyle: const TextStyle(
            fontSize: 12,
            letterSpacing: 0,
            height: 19.36/12,
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
