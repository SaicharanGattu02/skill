import 'package:flutter/material.dart';
import 'package:skill/screens/dashboard.dart';

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

  // Focus nodes
  final FocusNode _focusNodeFirstName = FocusNode();
  final FocusNode _focusNodeLastName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();

  // Gender selection
  String? _gender; // Variable to hold selected gender

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
                          'Sign up to your Account',
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
                    Text(
                      'Personal information',
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
            bottom: w * 0.1,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFormField(
                      controller: _firstNameController,
                      focusNode: _focusNodeFirstName,
                      hintText: "Company Name",
                      validationMessage: 'Please enter your company name',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _lastNameController,
                      focusNode: _focusNodeLastName,
                      hintText: "Enter Your Company Size",
                      validationMessage: 'Please enter your company size',
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _emailController,
                      focusNode: _focusNodeEmail,
                      hintText: "Enter Your Category",
                      validationMessage: 'Please enter your category',
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _phoneController,
                      focusNode: _focusNodePhone,
                      hintText: "Enter Your City",
                      validationMessage: 'Please select your city',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Gender",

                      style: TextStyle(
                        color: Color(0xff1C1C1C),
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 19.36 / 16,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'FeMale',
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                            ),
                            const Text('FeMale'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Male',
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                            ),
                            const Text('Male'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    InkWell(onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
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
                            letterSpacing: -0.01,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff8856F4),
                            color: Color(0xff8856F4),
                            fontWeight: FontWeight.w500,
                            height: 19.6 / 14,
                            letterSpacing: -0.01,
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
