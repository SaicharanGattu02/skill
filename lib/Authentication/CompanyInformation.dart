import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:skill/screens/LogInScreen.dart';
import 'package:skill/Authentication/PersnalInformation.dart';

import '../utils/ShakeWidget.dart';

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

  // Validation messages
  String _validateCompanyName = "";
  String _validateCompanySize = "";
  String _validateCategory = "";
  String _validateCity = "";
  String _validateState = "";
  String _validateCountry = "";

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _companyController.addListener(() {
      setState(() {
        _validateCompanyName = "";
      });
    });
    _companySizeController.addListener(() {
      setState(() {
        _validateCompanySize = "";
      });
    });
    _selectCategory.addListener(() {
      setState(() {
        _validateCategory = "";
      });
    });
    _enterCityController.addListener(() {
      setState(() {
        _validateCity = "";
      });
    });
    _stateController.addListener(() {
      setState(() {
        _validateState = "";
      });
    });
    _countryController.addListener(() {
      setState(() {
        _validateCountry = "";
      });
    });
  }

  @override
  void dispose() {
    // Dispose of controllers
    _companyController.dispose();
    _companySizeController.dispose();
    _selectCategory.dispose();
    _enterCityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _validateCompanyName =
      _companyController.text.isEmpty ? "Please enter company name" : "";
      _validateCompanySize =
      _companySizeController.text.isEmpty ? "Please enter company size" : "";
      _validateCategory =
      _selectCategory.text.isEmpty ? "Please enter your category" : "";
      _validateCity =
      _enterCityController.text.isEmpty ? "Please enter city" : "";
      _validateState =
      _stateController.text.isEmpty ? "Please select state" : "";
      _validateCountry =
      _countryController.text.isEmpty ? "Please select country" : "";

      // Check if all validations are passed
      _isLoading = _validateCompanyName.isEmpty &&
          _validateCompanySize.isEmpty &&
          _validateCategory.isEmpty &&
          _validateCity.isEmpty &&
          _validateState.isEmpty &&
          _validateCountry.isEmpty;

      if (_isLoading) {
        // Proceed with your API call or next steps
        // CreateTaskApi();
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => PersonalInformation()));
      }
    });
  }




  final List<String> items = List.generate(100, (index) => 'Item ${index + 1}');

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();


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
                        validationMessage: _validateCompanyName,
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
                        validationMessage: _validateCompanySize,
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
                        validationMessage: _validateCategory,
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
                        validationMessage: _validateCity,
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
                        validationMessage: _validateState,
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
                        validationMessage:_validateCountry,
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
                        _validateFields();
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
    return Column(
      children: [
        Container(
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
        ),
        if (validationMessage.isNotEmpty) ...[
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
                left: 8,top: 5),
            width: MediaQuery.of(context).size.width * 0.6,
            child: ShakeWidget(
              key: Key("value"),
              duration: Duration(milliseconds: 700),
              child: Text(
                validationMessage,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
