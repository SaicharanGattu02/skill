import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skill/screens/Login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body:
      AnimatedSplashScreen(
        duration: 3000,
        splash:  const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/skillLogo.png"),
                width: 281,
                height: 60,
              )
            ],
          ),
        ),
        // nextScreen: (onboard_status == "")
        //     ? MySplashOnboard()
        //     : (token != "")
        //     ? (permissions_granted ? MyMainHome() : MyPermission())
        //     :(permissions_granted ? MySignup() : MyPermission()),
         nextScreen: LogIn(),
        splashIconSize: double
            .infinity,
        backgroundColor: Color(0xff8856F4),
        splashTransition: SplashTransition.scaleTransition,
      ),

    );
  }
}
