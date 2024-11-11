import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/UserDetailsModel.dart';
import '../Services/UserApi.dart';
import '../utils/CustomSnackBar.dart';
import '../utils/ShakeWidget.dart';
import '../Providers/ProfileProvider.dart';

class GeneralInfo extends StatefulWidget {
  const GeneralInfo({super.key});

  @override
  State<GeneralInfo> createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _linkdnController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Focus nodes
  final FocusNode _focusNodeFirstName = FocusNode();
  final FocusNode _focusNodeLastName = FocusNode();
  final FocusNode _focusNodeLinkdn = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();
  final FocusNode _focusNodeAddress = FocusNode();

  String _validateFirstName = "";
  String _validateLastName = "";
  String _validateLinkdn = "";
  String _validatePhone = "";
  String _validateAddress = "";
  String _validateGender = "";
  String _gender = "";

  bool _isLoading = false;
  String? selectedValue = 'Public';
  final List<String> items = [
    'Public',
    'Private',
  ];
  final spinkit = Spinkits();

  @override
  void initState() {
    super.initState();
    GetUserDeatails();
  }

  Future<void> GetUserDeatails() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    setState(() {
      _isLoading = false; // Stop the loading indicator
      final userProfile = profileProvider.userProfile; // Get the user profile data
      // Assuming the data is not null, fill the fields accordingly
      if (userProfile != null) {
        final fullName = userProfile.fullName ?? "";
        final nameParts = fullName.split(' ');

        // Set first name and last name accordingly
        if (nameParts.length > 0) {
          _firstNameController.text = nameParts[0]; // Set first name
        }
        if (nameParts.length > 1) {
          _lastNameController.text = nameParts.sublist(1).join(' '); // Set last name
        } else {
          _lastNameController.text = ""; // Clear last name if no last part
        }

        _phoneController.text = userProfile.mobile ?? "";
        _linkdnController.text = userProfile.linkedin ?? "";
        _addressController.text = userProfile.address ?? "";

        // Handle privacy setting (Public/Private)
        if (userProfile.is_mobile_private == true) {
          selectedValue = "Public";
        } else {
          selectedValue = "Private";
        }

        // Handle gender setting
        if (userProfile.gender == "Male") {
          _gender = "male";
        } else if (userProfile.gender == "Female") {
          _gender = "female";
        } else {
          _gender = "other";
        }
      }
    });
  }

  Future<void> UpdateProfile() async {
    int? status;
    setState(() {
      _isLoading=true;
      if (selectedValue == "Public") {
        status = 0;
      } else {
        status = 1;
      }
    });

    // Access the ProfileProvider and call the updateUserProfile method
    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    try {
      // Call the updateUserProfile method from ProfileProvider
      var res = await profileProvider.updateUserProfile(
        "${_firstNameController.text} ${_lastNameController.text}",
        _phoneController
            .text,
        _gender,
        _linkdnController.text,
        status!,
        _addressController.text,
        null, // If you have an image, pass it here
      );
      setState(() {
        if(res==true){
          _isLoading=false;
          CustomSnackBar.show(context, "Profile Updated Successfully!");
        }else{
          _isLoading=false;
          CustomSnackBar.show(context, "Profile Update Failed!");
        }
      });
    } catch (e) {
      CustomSnackBar.show(context, "Failed to update profile: $e");

    }
  }

  // void _validateFields() {
  //   setState(() {
  //     _validateFirstName =
  //         _firstNameController.text.isEmpty ? "Please enter a firstName" : "";
  //     _validateLastName =
  //         _lastNameController.text.isEmpty ? "Please enter a lastName" : "";
  //     _validateLinkdn = _linkdnController.text.isEmpty
  //         ? "Please enter a valid linkdn url"
  //         : "";
  //     _validatePhone =
  //         _phoneController.text.isEmpty ? "Please enter a phonenumber" : "";
  //     _validateAddress =
  //         _addressController.text.isEmpty ? "Please enter a address" : "";
  //   });
  //
  //   if (_validateFirstName.isEmpty &&
  //       _validateLastName.isEmpty &&
  //       _validateLinkdn.isEmpty &&
  //       _validatePhone.isEmpty) {
  //     // UpdateProfile();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffF3ECFB),
      resizeToAvoidBottomInset: true,
      body: Container(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(0xffFFFFFF), borderRadius: BorderRadius.circular(7)),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label(text: 'First Name'),
                SizedBox(height: 6),
                Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  child: TextFormField(
                    controller: _firstNameController,
                    focusNode: _focusNodeFirstName,
                    keyboardType: TextInputType.text,
                    cursorColor: Color(0xff8856F4),
                    onTap: () {
                      setState(() {
                        _validateFirstName = "";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validateFirstName = "";
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: "Enter First Name",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 19.36 / 14,
                        color: Color(0xffAFAFAF),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      // prefixIcon:
                      // Container(
                      //   width: 18,
                      //   height: 18,
                      //   padding: EdgeInsets.only(top: 14, bottom: 14, left: 6),
                      //   child: Image.asset(
                      //     "assets/profilep.png",
                      //     width: 18,
                      //     height: 18,
                      //     fit: BoxFit.contain,
                      //     color: Color(0xffAFAFAF),
                      //   ),
                      // ),
                      filled: true,
                      fillColor: const Color(0xffFCFAFF),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14, // Ensure font size fits within height
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis for long text
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                if (_validateFirstName.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateFirstName,
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
                  SizedBox(height: 8),
                ],
                _label(text: 'Last Name'),
                SizedBox(height: 6),
                Container(
                  height: MediaQuery.of(context).size.height * 0.050,
                  child: TextFormField(
                    controller: _lastNameController,
                    focusNode: _focusNodeLastName,
                    keyboardType: TextInputType.text,
                    cursorColor: Color(0xff8856F4),
                    onTap: () {
                      setState(() {
                        _validateLastName = "";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validateLastName = "";
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: "Enter Last Name",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 19.36 / 14,
                        color: Color(0xffAFAFAF),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      // prefixIcon: Container(
                      //   width: 21,
                      //   height: 21,
                      //   padding: EdgeInsets.only(top: 12, bottom: 12, left: 6),
                      //   child: Image.asset(
                      //     "assets/profilep.png",
                      //     width: 21,
                      //     height: 21,
                      //     fit: BoxFit.contain,
                      //     color: Color(0xffAFAFAF),
                      //   ),
                      // ),
                      filled: true,
                      fillColor: const Color(0xffFCFAFF),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14, // Ensure font size fits within height
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis for long text
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                if (_validateLastName.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateLastName,
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
                  SizedBox(height: 8),
                ],
                _label(text: 'Gender'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.9,
                          child: Radio<String>(
                            value: 'male',
                            groupValue: _gender,
                            activeColor:
                                Color(0xff8856F4), // Change the active color
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ), // Decrease the space between the Radio and the Text
                        Text('Male',
                            style: TextStyle(
                                color: Color(0xff4A4A4A),
                                fontFamily: 'Inter',
                                fontSize: 14,
                                height: 16.36 / 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.9, // Adjust the scale to decrease the size
                          child: Radio<String>(
                            value: 'female',
                            groupValue: _gender,
                            activeColor:
                                Color(0xff8856F4), // Change the active color
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ),
                        // Decrease the space between the Radio and the Text
                        const Text('FeMale',
                            style: TextStyle(
                                color: Color(0xff4A4A4A),
                                fontFamily: 'Inter',
                                fontSize: 14,
                                height: 16.36 / 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.9, // Adjust the scale to decrease the size
                          child: Radio<String>(
                            value: 'other',
                            groupValue: _gender,
                            activeColor:
                                Color(0xff8856F4), // Change the active color
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ),
                        // Decrease the space between the Radio and the Text
                        const Text('Other',
                            style: TextStyle(
                                color: Color(0xff4A4A4A),
                                fontFamily: 'Inter',
                                fontSize: 14,
                                height: 16.36 / 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ],
                ),
                if (_validateGender.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateGender,
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
                  SizedBox(height: 8),
                ],
                _label(text: 'Phone Number'),
                SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      height: h * 0.05,
                      width: w * 0.45,
                      child: TextFormField(
                        controller: _phoneController,
                        focusNode: _focusNodePhone,
                        keyboardType: TextInputType.phone,
                        cursorColor: Color(0xff8856F4),
                        onTap: () {
                          setState(() {
                            _validatePhone = "";
                          });
                        },
                        onChanged: (v) {
                          setState(() {
                            _validatePhone = "";
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          hintText: "Phone Number",
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            letterSpacing: 0,
                            height: 19.36 / 14,
                            color: Color(0xffAFAFAF),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          // prefixIcon: Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                          //   child: Image.asset(
                          //     "assets/call.png",
                          //     width: 21,
                          //     height: 21,
                          //     fit: BoxFit.contain,
                          //     color: Color(0xffAFAFAF),
                          //   ),
                          // ),
                          filled: true,
                          fillColor: const Color(0xffFCFAFF),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xffd0cbdb)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xffd0cbdb)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xffd0cbdb)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xffd0cbdb)),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    Container(
                      width: w * 0.3,
                      height: h * 0.05,
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: Color(0xffD0CBDB),
                        ),
                        color: Color(0xffFCFAFF),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          customButton: Row(
                            children: [
                              Image.asset(
                                'assets/globe.png',
                                fit: BoxFit.contain,
                                height: h * 0.02, // Match height of the container
                                width: w * 0.04,
                              ),
                              SizedBox(
                                  width: 8), // Space between image and text
                              Text(
                                selectedValue ?? 'Select an option',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                          isExpanded: true,
                          items: items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            width: w * 0.35,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: Color(0xffD0CBDB),
                              ),
                              color: Color(0xffDDDDDD),
                            ),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              size: 25,
                            ),
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_validatePhone.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validatePhone,
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
                  SizedBox(height: 8),
                ],
                _label(text: 'Linkedin'),
                SizedBox(height: 6),
                Container(
                  height: MediaQuery.of(context).size.height * 0.050,
                  child: TextFormField(
                    controller: _linkdnController,
                    focusNode: _focusNodeLinkdn,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Color(0xff8856F4),
                    maxLines: 1,
                    onTap: () {
                      setState(() {
                        _validateLinkdn = "";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validateLinkdn = "";
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: "LinkedIn Url",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 19.36 / 14,
                        color: Color(0xffAFAFAF),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      // prefixIcon: Container(
                      //   width: 21,
                      //   height: 21,
                      //   padding: EdgeInsets.only(top: 10, bottom: 10, left: 6),
                      //   child: Image.asset(
                      //     "assets/gmail.png",
                      //     width: 21,
                      //     height: 21,
                      //     fit: BoxFit.contain,
                      //     color: Color(0xffAFAFAF),
                      //   ),
                      // ),
                      filled: true,
                      fillColor: const Color(0xffFCFAFF),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14, // Ensure font size fits within height
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis for long text
                    ),
                    textAlignVertical:
                        TextAlignVertical.center, // Vertically center the text
                  ),
                ),
                if (_validateLinkdn.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateLinkdn,
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
                  SizedBox(height: 8),
                ],
                _label(text: 'Address'),
                SizedBox(height: 6),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: TextFormField(
                    controller: _addressController,
                    focusNode: _focusNodeAddress,
                    keyboardType: TextInputType.text,
                    cursorColor: Color(0xff8856F4),
                    maxLines: 1,
                    onTap: () {
                      setState(() {
                        _validateAddress = "";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validateAddress = "";
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: "Enter Address",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 19.36 / 14,
                        color: Color(0xffAFAFAF),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),

                      // prefixIcon: Container(
                      //   width: 21,
                      //   height: 21,
                      //   padding: EdgeInsets.only(top: 14, bottom: 14, left: 6),
                      //   child: Image.asset(
                      //     "assets/gmail.png",
                      //     width: 21,
                      //     height: 21,
                      //     fit: BoxFit.contain,
                      //     color: Color(0xffAFAFAF),
                      //   ),
                      // ),
                      filled: true,
                      fillColor: const Color(0xffFCFAFF),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffd0cbdb)),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14, // Ensure font size fits within height
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis for long text
                    ),
                    textAlignVertical:
                        TextAlignVertical.center, // Vertically center the text
                  ),
                ),
                SizedBox(height: 8),
                if (_validateAddress.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateAddress,
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
                  SizedBox(height: 8),
                ],
              ],
            ),
          )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            InkResponse(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: w * 0.43,
                decoration: BoxDecoration(
                  color: Color(0xffF8FCFF),
                  border: Border.all(
                    color: Color(0xff8856F4),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Color(0xff8856F4),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            InkResponse(
              onTap: () {
                UpdateProfile();
              },
              child: Container(
                height: 40,
                width: w * 0.43,
                decoration: BoxDecoration(
                  color: Color(0xff8856F4),
                  border: Border.all(
                    color: Color(0xff8856F4),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: _isLoading
                      ? spinkit.getFadingCircleSpinner()
                      : Text(
                          'Save',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label({
    required String text,
  }) {
    return Text(text,
        style: TextStyle(
            color: Color(0xff141516),
            fontFamily: 'Inter',
            fontSize: 14,
            height: 16.36 / 14,
            fontWeight: FontWeight.w400));
  }
}
