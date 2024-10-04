import 'package:flutter/material.dart';
import 'package:skill/screens/Otp.dart';
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
  final TextEditingController _pwdController = TextEditingController();

  // Focus nodes
  final FocusNode _focusNodeFirstName = FocusNode();
  final FocusNode _focusNodeLastName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  // Gender selection
  String? _gender; // Variable to hold selected gender
  bool _loading= false;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      resizeToAvoidBottomInset: true,
      body:

      _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
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
                        controller: _firstNameController,
                        focusNode: _focusNodeFirstName,
                        hintText: "First Name",
                        validationMessage: 'Please enter your first name',
                        keyboardType: TextInputType.text,
                        prefixicon: Image.asset(
                          "assets/profilep.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        )),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                        controller: _lastNameController,
                        focusNode: _focusNodeLastName,
                        hintText: "Last Name",
                        validationMessage: 'Please enter your last size',
                        prefixicon: Image.asset(
                          "assets/profilep.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        )),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                        controller: _emailController,
                        focusNode: _focusNodeEmail,
                        hintText: "Email Address",
                        validationMessage: 'Please enter your category',
                        prefixicon: Image.asset(
                          "assets/gmail.png",
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        )),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                        controller: _phoneController,
                        focusNode: _focusNodePhone,
                        hintText: "Phone Number",
                        validationMessage: 'Please enter your phoneNumber',
                        prefixicon: Image.asset(
                          "assets/call.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        )),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                        controller: _pwdController,
                        focusNode: _focusNodePassword,
                        hintText: "Password",
                        validationMessage: 'Please select your city',
                        prefixicon: Image.asset(
                          "assets/Lock.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        )),

                     SizedBox(height: 16),
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
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.9,
                              child: Radio<String>(
                                value: 'Female',
                                groupValue: _gender,
                                activeColor: Color(0xff8856F4), // Change the active color
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value;
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
                              scale: 0.9, // Adjust the scale to decrease the size
                              child: Radio<String>(
                                value: 'Male',
                                groupValue: _gender,
                                activeColor: Color(0xff8856F4), // Change the active color
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value;
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


                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Otp()));
                      },
                      child: Container(
                        width: w,
                        height: w*0.1,
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
              width: 20,
              height: 20,
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 6),
              child: prefixicon),
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
