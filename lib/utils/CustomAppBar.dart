import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../Providers/ThemeProvider.dart';
import 'app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final VoidCallback? onPlusTap;  // Callback for handling the Plus square tap

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.actions,
    this.onPlusTap, // Optional callback for navigation or any other action
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      backgroundColor:themeProvider.appBarColor,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context,true);
        },
        child: const Icon(
          Icons.arrow_back,
          color: Color(0xffffffff),
        ),
      ),
      title: Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 22,
          color: Color(0xffffffff),
          fontWeight: FontWeight.w500,
          height: 26.05 / 22.0,
        ),
      ),
      actions: actions.isNotEmpty
          ? actions
          : [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: InkWell(
            onTap: onPlusTap ?? () {},
            child: Image.asset(
              "assets/Plus square.png",
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class Spinkits1 {
  Widget getSpinningLinespinkit() {
    return SizedBox(
      height: 20,
      width: 55,
      child: SpinKitSpinningLines(
        color: Color(0xffffffff),
      ),
    );
  }
}
