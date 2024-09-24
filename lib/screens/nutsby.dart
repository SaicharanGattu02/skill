import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Logins extends StatefulWidget {
  // final String ref_type;

  const Logins({super.key });

  @override
  State<Logins> createState() => _LoginsState();
}

class _LoginsState extends State<Logins> {
  FocusNode focusNode = FocusNode();
  TextEditingController phonenumber = TextEditingController();
  final FocusNode _focusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: [SystemUiOverlay.top]);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        // Exit the app
        // SystemNavigator.pop();
        // Return false to prevent default back navigation behavior
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffF3ECFB),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/skillLogo.png',
                            fit: BoxFit.fill,
                            width: screenWidth*0.6,
                          ),
                        ],
                      )),

                  // Positioned(
                  //   top: screenWidth * 0.09,
                  //   left: screenWidth * 0.23, // Add left padding
                  //   right: screenWidth * 0.03,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                        // Spacer(),
                        // Image.asset(
                        //   'assets/skillLogo.png',
                        //   fit: BoxFit.fill,
                        //   alignment: Alignment.topCenter,
                        //   width: 154,
                        //   height: 73,
                        // ),

                  //     ],
                  //   ),
                  // ),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    // Add left padding
                    right: 20,
                    // Add right padding
                    // child: Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20), // Adjust horizontal padding as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Mobile No.',
                          style: TextStyle(
                            fontFamily: "Inter",

                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: screenWidth),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(39)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              const SizedBox(
                                width: 13,
                              ),
                              SizedBox(
                                width: 40,
                                child: Container(
                                  child: Text(
                                    '+91',
                                    style: TextStyle(
                                      fontSize:14,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 45,
                                width: 1,
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                199, 199, 199, 100)))),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 0),
                                  child: TextFormField(
                                    keyboardType:
                                    const TextInputType.numberWithOptions(),
                                    textInputAction: TextInputAction.done,
                                    focusNode: focusNode,
                                    onTapOutside: (event) {
                                      focusNode.unfocus();
                                    },
                                    onTap: () {
                                      setState(() {

                                      });
                                    },
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500),
                                    onChanged: (value) {
                                      // setState(() {
                                      //   if (value.length == 10) {
                                      //     valid_mobilenum = true;
                                      //     focusNode.unfocus();
                                      //   } else {

                                      //     valid_mobilenum = false;
                                      //   }
                                      // });
                                    },
                                    controller: phonenumber,
                                    // inputFormatters: [
                                    //   MaskedInputFormatter('##########'),
                                    //   FilteringTextInputFormatter.digitsOnly,
                                    // ],
                                    cursorColor: Colors.grey,
                                    cursorWidth: 0.3,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter your mobile number",
                                      hintStyle: TextStyle(
                                          fontFamily: "Inter",
                                          color: Color(0xFFAFAFAF),
                                          // fontSize: FontConstant.Size14,
                                          height: 1.2),
                                    ),
                                  ),
                                ),
                              ),
                              if (phonenumber.value.text.length > 3) ...[
                                Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFFE8ECFF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(Icons.clear,
                                        size: 15,
                                        color: Color(0xff6977C2))),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            ],
                          ),
                        ),
                        // if (_validate != null && _validate.isNotEmpty) ...[
                        //   Center(
                        //     child: ShakeWidget(
                        //       key: Key("value"),
                        //       duration: Duration(milliseconds: 700),
                        //       child: Text(
                        //         _validate,
                        //         style: TextStyle(
                        //           fontFamily: "Inter",
                        //           fontSize: FontConstant.Size13,
                        //           color: Color(0xffFFB703),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ],
                        SizedBox(
                          height: 12,
                        ),
                        // Center(
                        //   child: SizedBox(
                        //     height: 45,
                        //     width: screenWidth,
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color: (valid_mobilenum
                        //             ? Color(0xffFFB703)
                        //             : Color(0xffE7A500)),
                        //         borderRadius: BorderRadius.circular(39),
                        //       ),
                        //       child: Center(
                        //         child: (isLoading)
                        //             ? ((Platform.isAndroid)
                        //             ? Container(
                        //           width: 15,
                        //           height: 15,
                        //           child: CircularProgressIndicator(
                        //             color: Color(0xff023047),
                        //             strokeWidth: 2,
                        //           ),
                        //         )
                        //             : CupertinoActivityIndicator())
                        //             : Text(
                        //           'Get OTP',
                        //           style: TextStyle(
                        //             fontFamily: "Inter",
                        //
                        //             color: Colors.black,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 18,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 279, // Adjust padding as needed
                            child: Text(
                              "You'll now receive SMS updates from Nutsby. Stay tuned!",
                              textAlign: TextAlign.center, // Center align text
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 13,
                                color: Color(0xff219EBC),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    //),
                  ),
                  // Positioned(
                  //   bottom: 270,
                  //   left: 30,
                  //   right: 30,
                  //   child: Container(
                  //     child: Center(
                  //       child: Text(
                  //         'BUILDING A \nHEALTHY YOU',
                  //         textAlign: TextAlign.center,
                  //         maxLines: 2,
                  //         // Center align text
                  //         style: TextStyle(
                  //           height: 0.9,
                  //           fontFamily: "Bebas",
                  //           fontSize: 41,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
