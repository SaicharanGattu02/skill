import 'package:flutter/material.dart';
import 'package:skill/screens/dashboard.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  // Checkbox state
  bool _rememberMe = false; // Variable to hold the checkbox state

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
                        child: const Text(
                          'Sign In to your Account',
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
                    const SizedBox(height: 12),
                    const Text(
                      'Login Your Account',
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
          ),
          Positioned(
            top: h * 0.35,
            left: w * 0.1,
            right: w * 0.1,
            child: SingleChildScrollView(
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
                      controller: _emailController,
                      focusNode: _focusNodeEmail,
                      hintText: "Enter Your Email",
                      validationMessage: 'Please enter your email',
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _passwordController,
                      focusNode: _focusNodePassword,
                      hintText: "Enter Your Password",
                      validationMessage: 'Please enter your password',
                      obscureText: true, // Make password obscured
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false; // Handle null value
                            });
                          },
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Remember me",
                          style: TextStyle(
                            color: Color(0xff1C1C1C),
                            fontFamily: "Inter",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 21 / 14,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Handle forgot password
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color(0xff8856F4),
                              fontFamily: "Inter",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 19.06 / 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        // Navigate to Dashboard
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
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
                            "Log In",
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
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Color(0xff6C7278),
                            fontWeight: FontWeight.w500,
                            height: 19.6 / 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            // Navigate to the sign-up screen if necessary
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              color: Color(0xff8856F4),
                              fontWeight: FontWeight.w500,
                            ),
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required FocusNode focusNode,
    bool obscureText = false,
    required String hintText,
    required String validationMessage,
    TextInputType keyboardType = TextInputType.text,
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
