import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:skill/screens/LogInScreen.dart';
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
    fetchDetails();
    super.initState();
  }

  fetchDetails() async {
    final Token = await PreferenceService().getString("token") ?? "";
    print("Token>>>${Token}");
    setState(() {
      token = Token;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 2000,
        splash: SizedBox(
          height: h,
          width: w,
          child: Container(
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
              ),
            ),
          ),
        ),
        nextScreen: (token == "") ? LogInScreen() : Dashboard(),
        backgroundColor: Color(0xff8856F4),
        splashTransition: SplashTransition.scaleTransition,
      ),
    );
  }
}
