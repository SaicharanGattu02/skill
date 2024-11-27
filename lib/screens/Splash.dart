  import 'package:flutter/material.dart';
import 'package:skill/Authentication/CompanyInformation.dart';
import 'package:skill/Authentication/PersnalInformation.dart';
import 'package:skill/Authentication/LogInScreen.dart';
import 'package:skill/screens/dashboard.dart';
import 'package:skill/utils/Preferances.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}


class _SplashState extends State<Splash> {
  String token = "";

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  fetchDetails() async {
    final Token = await PreferenceService().getString("token") ?? "";
    print("Token>>>${Token}");
    setState(() {
      token = Token;
    });

    // Wait for 2 seconds before navigating
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => (token.isEmpty) ? LogInScreen() : Dashboard(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff8856F4),
      body:
      Center(
        child:
        Container(
          height:376,
          width: w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Image.asset(
              "assets/skillLogo.png",
              fit: BoxFit.contain,
              height: h * 0.20,
              width: w*0.35,
            ),
          ),
        ),
      ),
    );
  }
}
