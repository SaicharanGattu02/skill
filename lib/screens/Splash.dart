import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:skill/screens/Login.dart';
import 'package:skill/screens/Register.dart';
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
    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 2000,
        splash: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/skillLogo.png"),
                width: 281,
                height: 60,
              ),
            ],
          ),
        ),

        // nextScreen: (token == "") ? Login() : Dashboard(),
        // ? (permissions_granted ? MyMainHome() : MyPermission())
        // : (permissions_granted ? MySignup() : MyPermission()),
        nextScreen:  Register(), // Change this to your desired next screen
        splashIconSize: double.infinity,
        backgroundColor: const Color(0xff8856F4),
        splashTransition: SplashTransition.scaleTransition,
      ),
    );
  }
}
