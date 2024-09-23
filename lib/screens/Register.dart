import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // First Container
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                height: h * 0.5, // Half of the screen height
                width: w,
                decoration: BoxDecoration(
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
                    ),
                    SizedBox(height: 24),
                    Container(
                      width: 221, // Fixed width for the text
                      child: Text(
                        'Sign up to your Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 32,
                          color: Color(0xffEEEEEE),
                          fontWeight: FontWeight.w700,
                          height: 38.4 / 32, // Line-height
                          letterSpacing: -0.02,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Company Information',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Color(0xffEEEEEE),
                        fontWeight: FontWeight.w500,
                        height: 16.8 / 12,
                        letterSpacing: -0.01,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ), // Second Container positioned 100px above the first container
          Positioned(
            top: h * 0.5 - 80, // Start 100px above the end of the first container
            left: 40,
            right: 40,

            child: Container(
              height: h*0.5,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
