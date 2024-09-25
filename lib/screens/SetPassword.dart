import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key});

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
                        width: w * 0.4,
                        child: Text(
                          'Set New Password',
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
                    SizedBox(
                      width: w * 0.6,
                      child: Text(
                        'Create a new password. Ensure it differs from previous ones for security',
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
                      controller: _passwordController,
                      focusNode: _focusNodePassword,
                      hintText: "Password",
                      obscureText: _obscurePassword,
                      validationMessage: 'Please enter your password',
                      prefixIcon: Image.asset(
                        "assets/Lock.png",
                        width: 21,
                        height: 21,
                        fit: BoxFit.contain,
                        color: Color(0xffAFAFAF),
                      ),
                      toggleObscure: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _confirmPasswordController,
                      focusNode: _focusNodeConfirmPassword,
                      hintText: "Confirm Password",
                      obscureText: _obscureConfirmPassword,
                      validationMessage: 'Please confirm your password',
                      prefixIcon: Image.asset(
                        "assets/Lock.png",
                        width: 21,
                        height: 21,
                        fit: BoxFit.contain,
                        color: Color(0xffAFAFAF),
                      ),
                      toggleObscure: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                      },
                      child: Container(
                        width: w,
                        height: w * 0.1,
                        decoration: BoxDecoration(
                          color: const Color(0xff8856F4),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text(
                            "Update Password",
                            style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 20 / 14,
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
    required String hintText,
    required String validationMessage,
    bool obscureText = false,
    Widget? prefixIcon,
    required VoidCallback toggleObscure,
    TextInputType keyboardType = TextInputType.text,
  }) {
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
            child: prefixIcon,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Color(0xffAFAFAF),size: 18,
            ),
            onPressed: toggleObscure,
          ),
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
