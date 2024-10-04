import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ProjectModule/UserDetailsModel.dart';
import '../Services/UserApi.dart';

class GeneralInfo extends StatefulWidget {
  const GeneralInfo({super.key});

  @override
  State<GeneralInfo> createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  // Form key to validate the form fields
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController linkedInController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  FocusNode _focusFirstName = FocusNode();
  FocusNode _focusLastName = FocusNode();
  FocusNode _focusStartDate = FocusNode();
  FocusNode _focusPhone = FocusNode();
  FocusNode _focusLinkedIn = FocusNode();
  FocusNode _focusAddress = FocusNode();

  // Default gender selection
  String gender = 'Male';

  @override
  void initState() {
    super.initState();
    GetUserDeatails();
  }

  UserData? userdata;
  Future<void> GetUserDeatails() async {
    var Res = await Userapi.GetUserdetails();
    setState(() {
      if (Res != null) {
        if(Res.settings?.success == 1) {
          userdata = Res.data;
          firstNameController.text = userdata?.fullName ?? "";
          phoneController.text = userdata?.mobile ?? "";
        }
      }
    });
  }

  // Validator functions
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a start date';
    } else if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
      return 'Please enter a valid date (DD/MM/YYYY)';
    }
    return null;
  }

  String? _validateLinkedIn(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your LinkedIn profile URL';
    } else if (!Uri.parse(value).isAbsolute || !value.contains('linkedin.com')) {
      return 'Please enter a valid LinkedIn URL';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // First Card for the Form
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey, // Add form key
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label(text: 'First Name'),
                          const SizedBox(height: 8),
                          _buildTextFormField(
                            controller: firstNameController,
                            focusNode: _focusFirstName,
                            hintText: 'Enter your first name',
                            validator: _validateName, // Validation
                          ),
                          const SizedBox(height: 16),

                          _label(text: 'Last Name'),
                          const SizedBox(height: 8),
                          _buildTextFormField(
                            controller: lastNameController,
                            focusNode: _focusLastName,
                            hintText: 'Enter your last name',
                            validator: _validateName, // Validation
                          ),
                          const SizedBox(height: 16),

                          _label(text: 'Start Date'),
                          const SizedBox(height: 8),
                          _buildTextFormField(
                            controller: startDateController,
                            focusNode: _focusStartDate,
                            hintText: 'Enter start date (DD/MM/YYYY)',
                            validator: _validateStartDate, // Validation
                          ),
                          const SizedBox(height: 16),

                          _label(text: 'Gender'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Male',
                                groupValue: gender,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                              const Text('Male'),

                              Radio<String>(
                                value: 'Female',
                                groupValue: gender,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                              const Text('Female'),
                              Radio<String>(
                                value: 'Other',
                                groupValue: gender,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                              const Text('Other'),
                            ],
                          ),
                          const SizedBox(height: 16),

                          _label(text: 'Phone'),
                          const SizedBox(height: 8),
                          _buildTextFormField(
                            controller: phoneController,
                            focusNode: _focusPhone,
                            hintText: 'Enter your phone number',
                            keyboardType: TextInputType.phone,
                            validator: _validatePhone, // Validation
                          ),
                          const SizedBox(height: 16),

                          _label(text: 'LinkedIn URL'),
                          const SizedBox(height: 8),
                          _buildTextFormField(
                            controller: linkedInController,
                            focusNode: _focusLinkedIn,
                            hintText: 'Enter your LinkedIn profile URL',
                            validator: _validateLinkedIn, // Validation
                          ),
                          const SizedBox(height: 16),

                          _label(text: 'Address'),
                          const SizedBox(height: 8),
                          _buildTextFormField(
                            controller: addressController,
                            focusNode: _focusAddress,
                            hintText: 'Enter your address',
                            validator: _validateAddress, // Validation
                          ),
                          const SizedBox(height: 20), // Additional space at the end
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20), // Space between form card and button card

            // Second Card for the Buttons
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Button (Outlined with Icon)
                    OutlinedButton.icon(
                      onPressed: () {
                        // Add your cancel logic here
                      },
                      icon: const Icon(Icons.cancel, color: Colors.grey),
                      label: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // Save Button (Filled with Icon)
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Save logic here when form is valid
                        }
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _label({required String text}) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xff141516),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required FocusNode focusNode,
    bool obscureText = false,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator, // Validator passed here
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            obscureText: obscureText,
            cursorColor: const Color(0xff8856F4),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xffAFAFAF),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: const Color(0xffFCFAFF),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(width: 1, color: Color(0xffd0cbdb)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(width: 1, color: Color(0xffd0cbdb)),
              ),
            ),
            validator: validator, // Add validator to the TextFormField
          ),
        ),
      ],
    );
  }
}
