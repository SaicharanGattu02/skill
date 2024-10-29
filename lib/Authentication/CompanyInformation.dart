import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:skill/Authentication/LogInScreen.dart';
import 'package:skill/Authentication/PersnalInformation.dart';

import '../Model/CountriesModel.dart';
import '../Model/StatesModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomSnackBar.dart';
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
  final TextEditingController _companyAddressController = TextEditingController();
  final TextEditingController _enterCityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  // Focus nodes (optional for managing focus state)
  final FocusNode _focusNodeCompany = FocusNode();
  final FocusNode _focusNodeCompanySize = FocusNode();
  final FocusNode _focusNodeCompanyAddress = FocusNode();
  final FocusNode _focusNodeCity = FocusNode();


  // Validation messages
  String _validateCompanyName = "";
  String _validateCompanySize = "";
  String _validateCompanyAddress = "";
  String _validateCity = "";
  String _validateState = "";
  String _validateCountry = "";

  bool _isLoading = false;
  bool isStatesDropdownOpen = false;
  bool isContriesDropdownOpen = false;

  String? selectedStateValue;
  String? selectedStateKey;

  String? selectedCountryValue;
  String? selectedCountryKey;

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
    _companyAddressController.addListener(() {
      setState(() {
        _validateCompanyAddress = "";
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
    GetStates();
    GetCoutries();
  }
  List<States> states=[];
  List<States> filteredstates=[];
  Future<void> GetStates() async {
    var res = await Userapi.getstates();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          states=res.data??[];
          filteredstates=res.data??[];
        } else {}
      }
    });
  }

  List<Countries> countries=[];
  List<Countries> filteredcountries=[];
  Future<void> GetCoutries() async {
    var res = await Userapi.getcountries();
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          countries=res.data??[];
          filteredcountries=res.data??[];
        } else {}
      }
    });
  }

  @override
  void dispose() {
    // Dispose of controllers
    _companyController.dispose();
    _companySizeController.dispose();
    _companyAddressController.dispose();
    _enterCityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _validateCompanyName =
          _companyController.text.isEmpty ? "Please enter company name" : "";
      _validateCompanySize = _companySizeController.text.isEmpty
          ? "Please enter company size"
          : "";
      _validateCompanyAddress =
      _companyAddressController.text.isEmpty ? "Please enter company address" : "";
      _validateCity =
          _enterCityController.text.isEmpty ? "Please enter city" : "";
      _validateState =
          selectedStateKey==null ? "Please select state" : "";
      _validateCountry =
          selectedCountryKey==null ? "Please select country" : "";

      // Check if all validations are passed
      _isLoading = _validateCompanyName.isEmpty &&
          _validateCompanySize.isEmpty &&
          _validateCompanyAddress.isEmpty &&
          _validateCity.isEmpty &&
          _validateState.isEmpty &&
          _validateCountry.isEmpty;
      if (_isLoading) {
        CreateComapnyApi();
      }
    });
  }

  Future<void>CreateComapnyApi() async {
    var res = await Userapi.createCompany(_companyController.text,_companyAddressController.text , _companySizeController.text, selectedStateKey!, selectedCountryKey!, _enterCityController.text);
    setState(() {
      if (res != null) {
        if (res.settings?.success == 1) {
          _isLoading = false;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInScreen(),));
        } else {
          _isLoading = false;
          CustomSnackBar.show(context, "${res.settings?.message}");
        }
      }
    });
  }
  void filterStates(String query) {
    setState(() {
      filteredstates = states.where((provider) {
        return provider.name != null &&
            provider.name!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }
  void filterCountries(String query) {
    setState(() {
      filteredcountries = countries.where((provider) {
        return provider.name != null &&
            provider.name!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }
  void closeDropdown() {
    setState(() {
      isStatesDropdownOpen = false;
      isContriesDropdownOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: closeDropdown,
        child: Stack(
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
                      // const SizedBox(height: 18),
                      // SingleChildScrollView(
                      //   child: SizedBox(
                      //     width: 221,
                      //     child: Text(
                      //       'Sign up to your Account',
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         fontFamily: 'Inter',
                      //         fontSize: 25,
                      //         color: Color(0xffEEEEEE),
                      //         fontWeight: FontWeight.w700,
                      //         height: 38.4 / 32,
                      //         letterSpacing: -0.02,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                      Text(
                        'Company Information',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 25,
                          color: Color(0xffEEEEEE),
                          fontWeight: FontWeight.w700,
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
              top: h * 0.30,
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
                      _buildTextFormField(
                          controller: _companySizeController,
                          focusNode: _focusNodeCompanySize,
                          hintText: "Enter company size",
                          validationMessage: _validateCompanySize,
                          prefixicon: Image.asset(
                            "assets/csize.png",
                            width: 21,
                            height: 21,
                            fit: BoxFit.contain,
                            color: Color(0xffAFAFAF),
                          )),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isStatesDropdownOpen =
                            !isStatesDropdownOpen;
                            filteredstates = [];
                            filteredstates = states;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border:
                              Border.all(color: Color(0xffCDE2FB)),
                              color: Color(0xffffffff)),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/state.png",
                                width: 21,
                                height: 21,
                                fit: BoxFit.contain,
                                color: Color(0xffAFAFAF),
                              ),
                              SizedBox(width: 15,),
                              Text(selectedStateValue ??
                                  "Select a State",
                                style: TextStyle(
                                    color:selectedStateValue!=null? Color(0xff000000):Color(0xffAFAFAF)
                                ),
                              ),
                              Spacer(),
                              Icon(isStatesDropdownOpen
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                                color: Color(0xffAFAFAF),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isStatesDropdownOpen) ...[
                        SizedBox(height: 5),
                        Card(
                          elevation:
                          4, // Optional elevation for shadow effect
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Optional rounded corners
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0,left: 8,right: 8), // Padding inside the card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align items to the start
                              children: [
                                Container(
                                  height: 40,
                                  child: TextField(
                                    onChanged: (query) => filterStates(query),
                                    decoration: InputDecoration(
                                      hintText: "Search state",
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Inter"),
                                      filled: true,
                                      fillColor: Color(0xffffffff),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xff000000)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xff000000)),
                                      ),
                                      contentPadding: EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ), // Space between TextField and ListView
                                Container(
                                    height:
                                    180, // Set a fixed height for the dropdown list
                                    child:filteredstates.length>0?
                                    ListView.builder(
                                      padding: EdgeInsets.only(top: 10),
                                      itemCount: filteredstates.length,
                                      itemBuilder: (context, index) {
                                        var data = filteredstates[index];
                                        return InkResponse(
                                          onTap: (){
                                            setState(() {
                                              isStatesDropdownOpen =
                                              false;
                                              selectedStateValue = data.name;
                                              selectedStateKey = data.id;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 15),
                                            child: Row(
                                              children: [
                                                Text(
                                                  data.name ?? "",
                                                  style: TextStyle(
                                                      fontFamily: "Inter",
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ):Center(child: Text("No Data found!"))
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (_validateState.isNotEmpty) ...[
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(bottom: 5),
                          child: ShakeWidget(
                            key: Key("value"),
                            duration: Duration(milliseconds: 700),
                            child: Text(
                              _validateState,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isContriesDropdownOpen =
                            !isContriesDropdownOpen;
                            filteredcountries = [];
                            filteredcountries = countries;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border:
                              Border.all(color: Color(0xffCDE2FB)),
                              color: Color(0xffffffff)),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/country.png",
                                width: 21,
                                height: 21,
                                fit: BoxFit.contain,
                                color: Color(0xffAFAFAF),
                              ),
                              SizedBox(width: 15,),
                              Text(selectedCountryValue ??
                                  "Select a Country",
                                style: TextStyle(
                                  color:selectedCountryValue!=null? Color(0xff000000):Color(0xffAFAFAF)
                                ),
                              ),
                              Spacer(),
                              Icon(isContriesDropdownOpen
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                                color: Color(0xffAFAFAF),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isContriesDropdownOpen) ...[
                        SizedBox(height: 5),
                        Card(
                          elevation:
                          4, // Optional elevation for shadow effect
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Optional rounded corners
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0,left: 8,right: 8), // Padding inside the card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align items to the start
                              children: [
                                Container(
                                  height: 40,
                                  child: TextField(
                                    onChanged: (query) => filterCountries(query),
                                    decoration: InputDecoration(
                                      hintText: "Search Country",
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Inter"),
                                      filled: true,
                                      fillColor: Color(0xffffffff),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xff000000)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xff000000)),
                                      ),
                                      contentPadding: EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ), // Space between TextField and ListView
                                Container(
                                    height:
                                    180, // Set a fixed height for the dropdown list
                                    child:filteredcountries.length>0?
                                    ListView.builder(
                                      padding: EdgeInsets.only(top: 10),
                                      itemCount: filteredcountries.length,
                                      itemBuilder: (context, index) {
                                        var data = filteredcountries[index];
                                        return InkResponse(
                                          onTap: (){
                                            setState(() {
                                              isContriesDropdownOpen =
                                              false;
                                              selectedCountryValue = data.name;
                                              selectedCountryKey = data.id;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 15),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    data.name ?? "",
                                                    style: TextStyle(
                                                        fontFamily: "Inter",
                                                        fontSize: 15,
                                                        overflow: TextOverflow.ellipsis,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ):Center(child: Text("No Data found!"))
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (_validateCountry.isNotEmpty) ...[
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(bottom: 5),
                          child: ShakeWidget(
                            key: Key("value"),
                            duration: Duration(milliseconds: 700),
                            child: Text(
                              _validateCountry,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                      _buildTextFormField(
                          controller: _companyAddressController,
                          focusNode: _focusNodeCompanyAddress,
                          hintText: "Enter address",
                          validationMessage: _validateCompanyAddress,
                          prefixicon: Image.asset(
                            "assets/categoryselect.png",
                            width: 21,
                            height: 21,
                            fit: BoxFit.contain,
                            color: Color(0xffAFAFAF),
                          )),
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
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          if(_isLoading){

                          }else{
                            _validateFields();
                          }
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
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LogInScreen()));
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.045,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onTap: closeDropdown,
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
                borderSide:
                    const BorderSide(width: 1, color: Color(0xffCDE2FB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide:
                    const BorderSide(width: 1, color: Color(0xffCDE2FB)),
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
            margin: EdgeInsets.only(top: 5,bottom: 5),
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
        ]else...[
          SizedBox(height: 15),
        ]
      ],
    );
  }
}
