import 'package:flutter/material.dart';
import 'package:skill/screens/LogInScreen.dart';
import 'package:skill/Authentication/PersnalInformation.dart';

class CompanyInformation extends StatefulWidget {
  const CompanyInformation({super.key});

  @override
  State<CompanyInformation> createState() => _CompanyInformationState();
}

class _CompanyInformationState extends State<CompanyInformation> {
  // Text Controllers
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _companySizeController = TextEditingController();
  final TextEditingController _selectCategory = TextEditingController();
  final TextEditingController _enterCityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  // Focus nodes (optional for managing focus state)
  final FocusNode _focusNodeCompany = FocusNode();
  final FocusNode _focusNodeCompanySize = FocusNode();
  final FocusNode _focusNodeSelectCategory = FocusNode();
  final FocusNode _focusNodeCity = FocusNode();
  final FocusNode _focusNodeState = FocusNode();
  final FocusNode _focusNodeCountry = FocusNode();


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
                      'Company Information',
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
              // Enable scrolling when content overflows
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  children: [
                    _buildTextFormField(
                        controller: _companyController,
                        focusNode: _focusNodeCompany,
                        hintText: "Company Name",
                        validationMessage: 'Please enter your company name',
                        keyboardType: TextInputType.text,
                        prefixicon: Image.asset(
                          "assets/company.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                        controller: _companySizeController,
                        focusNode: _focusNodeCompanySize,
                        hintText: "Enter Company Size",
                        validationMessage: 'Please enter your company size',
                        prefixicon: Image.asset(
                          "assets/csize.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        )),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                        controller: _selectCategory,
                        focusNode: _focusNodeSelectCategory,
                        hintText: "Select Category",
                        validationMessage: 'Please enter your category',
                        prefixicon: Image.asset(
                          "assets/categoryselect.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        )),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                        controller: _enterCityController,
                        focusNode: _focusNodeCity,
                        hintText: "Enter City",
                        validationMessage: 'Please select your city',
                        prefixicon: Image.asset(
                          "assets/city.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        )),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                        controller: _stateController,
                        focusNode: _focusNodeState,
                        hintText: "State",
                        validationMessage: 'Please select your state',
                        prefixicon: Image.asset(
                          "assets/state.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        )),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                        controller: _countryController,
                        focusNode: _focusNodeCountry,
                        hintText: "Country",
                        validationMessage: 'Please select your country',
                        prefixicon: Image.asset(
                          "assets/country.png",
                          width: 21,
                          height: 21,
                          fit: BoxFit.contain,
                          color: Color(0xffAFAFAF),
                        )),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => PersonalInformation()));
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
                            "Continue",
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
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Color(0xff6C7278),
                            fontWeight: FontWeight.w400,
                            height: 19.6 / 14,
                            letterSpacing: -0.01,
                          ),
                        ),
                        const SizedBox(width: 6),
                         InkWell(onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInScreen()));
                         },
                           child: Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xff8856F4),
                              color: Color(0xff8856F4),
                              fontWeight: FontWeight.w600,
                              height: 19.6 / 12,
                              letterSpacing: -0.01,
                            ),
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
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 6),
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
