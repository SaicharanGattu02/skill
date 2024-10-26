import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:skill/Services/UserApi.dart';
import 'package:skill/screens/LogInScreen.dart';
import 'package:skill/Authentication/PersnalInformation.dart';




class CompanyInformation extends StatefulWidget {
  @override
  _CompanyInformationScreenState createState() => _CompanyInformationScreenState();
}

class _CompanyInformationScreenState extends State<CompanyInformation> {
  // Define controllers and state variables here
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _companySizeController = TextEditingController();
  final TextEditingController _selectCategoryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _companyController.dispose();
    _companySizeController.dispose();
    _selectCategoryController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _submitCompanyInfo() async {
    if (_companyController.text.isNotEmpty &&
        _companySizeController.text.isNotEmpty &&
        _selectCategoryController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _stateController.text.isNotEmpty &&
        _countryController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      final result = await Userapi.registerCompany(
        _companyController.text,
        _selectCategoryController.text,
        _companySizeController.text,
        _stateController.text,
        _countryController.text,
        _cityController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result != null) {
        // Handle success (e.g., navigate to next screen or show success message)
      } else {
        // Handle failure (e.g., show error message)
      }
    } else {
      // Set validation messages if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      body: Stack(
        children: [
          Positioned(
            top: w * 0.45,
            left: w * 0.08,
            right: w * 0.08,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                children: [
                  _buildTextFormField(
                    controller: _companyController,
                    hintText: "Company Name",
                  ),
                  _buildTextFormField(
                    controller: _companySizeController,
                    hintText: "Enter Company Size",
                  ),
                  _buildTextFormField(
                    controller: _selectCategoryController,
                    hintText: "Select Category",
                  ),
                  _buildTextFormField(
                    controller: _cityController,
                    hintText: "Enter City",
                  ),
                  _buildTextFormField(
                    controller: _stateController,
                    hintText: "State",
                  ),
                  _buildTextFormField(
                    controller: _countryController,
                    hintText: "Country",
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: _isLoading ? null : _submitCompanyInfo,
                    child: Container(
                      width: w,
                      height: w * 0.1,
                      decoration: BoxDecoration(
                        color: _isLoading ? Colors.grey : const Color(0xff8856F4),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Continue",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: const Color(0xffCDE2FB)),
          ),
        ),
      ),
    );
  }
}
