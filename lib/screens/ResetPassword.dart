import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skill/screens/SetPassword.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    const Color backgroundColor = Color(0xffF3ECFB);
    const Color primaryColor = Color(0xff8856F4);
    const Color textColorWhite = Color(0xffEEEEEE);
    const Color textColorDark = Color(0xff330066);
    const Color textColorGrey = Color(0xff4A4A4A);

    return Scaffold(
      backgroundColor: backgroundColor,
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
                        width: 150,
                        child: Text(
                          'Password Reset',
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
                    SizedBox(width: w*0.7,
                      child: Text(
                        'Your password has been successfully reset. click confirm to set a new password',
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
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password Reset",
                      style: TextStyle(
                        color: textColorDark,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 24.06 / 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Your password has been successfully reset. Click confirm to set a new password.",
                      style: TextStyle(
                        color: textColorGrey,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 19.06 / 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SetPassword()),
                        );
                      },
                      child: Container(
                        width: w,
                        height: w * 0.1,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              color: textColorWhite,
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
}
