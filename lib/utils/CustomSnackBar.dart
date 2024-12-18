import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../Providers/ThemeProvider.dart';
import 'app_colors.dart';
import 'constants.dart';

class CustomSnackBar {
  static void show(BuildContext context, String message) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontFamily: "Inter"),
        ),
        duration: Duration(seconds: 1),
        backgroundColor:themeProvider.themeData ==
            lightTheme
            ? themeProvider.primaryColor
            : AppColors.darkmodeContainerColor,
      ),
    );
  }
}

class Spinkits {
  Widget getFadingCircleSpinner({Color color = Colors.white}) {
    return SizedBox(
      height: 15,
      width: 35,
      child: SpinKitThreeBounce(
        size: 20,
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color, // Use the passed color or default to white
            ),
          );
        },
      ),
    );
  }
}
