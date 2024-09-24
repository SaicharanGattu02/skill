import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skill/screens/dashboard.dart';
import 'package:skill/utils/CustomSnackBar.dart';

import '../Services/UserApi.dart';
import '../utils/Preferances.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LogInState();
}

class _LogInState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _isPasswordVisible = false;
  // String token="";

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();

    super.dispose();
  }

  Future<void> LoginApi() async {
    setState(() {
      _loading=false;
    });
    var data = await Userapi.PostLogin(
        _emailController.text, _passwordController.text);
    if (data != null) {
      if (data.settings?.success == 1) {
        PreferenceService().saveString("token",data.data?.access??"");
        CustomSnackBar.show(context, "${data.settings?.message}");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
      } else {
        print("Login failure");
      }
    } else {
      print("Login >>>${data?.settings?.message}");
      CustomSnackBar.show(context, "${data?.settings?.message}");
    }
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.23,
              width: width,
              child: Center(
                child: Image.asset(
                  "assets/logo.png",
                  height: 100,
                  width: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's Register to Your Account",
                      style: TextStyle(
                        color: Color(0xFF32657B),
                        fontFamily: "Inter",
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Email",
                      style: TextStyle(
                        color: Color(0xFF32657B),
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.black,
                      focusNode: _focusNodeEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter Your Email",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0,
                          height: 1.2,
                          color: Color(0xffAFAFAF),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: Color(0xffffffff),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffCDE2FB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffCDE2FB)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(width: 1, color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(width: 1, color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }

                        // return null;
                      },
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Password",
                      style: TextStyle(
                        color: Color(0xFF32657B),
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      cursorColor: Colors.black,
                      focusNode: _focusNodePassword,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: "Enter Your Password",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0,
                          height: 1.2,
                          color: Color(0xffAFAFAF),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: Color(0xffffffff),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffCDE2FB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffCDE2FB)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(width: 1, color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(width: 1, color: Colors.red),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xffAFAFAF),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Mobile Number",
                      style: TextStyle(
                        color: Color(0xFF32657B),
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: height * 0.1),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          LoginApi();
                        }
                      },
                      child: Container(
                        width: width,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: _loading
                              ? CircularProgressIndicator(
                                  color: Color(0xFFFFFFFF),
                                )
                              : Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => LogIn()),
                            // );
                          },
                          child: Text(
                            ' Login',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
