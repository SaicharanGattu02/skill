import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/ThemeProvider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    List<Color> colorOptions = [
      Color(0xFF8856f4),
      Color(0xFF03DAC6),
      Color(0xFFFF5722),
      Color(0xFF4CAF50),
      Color(0xFF2196F3),
    ];
    return Scaffold(
      backgroundColor:themeProvider.scaffoldBackgroundColor,
      appBar: AppBar(
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
        title: Text("Settings",
          style:  TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
            height: 26.05 / 22.0,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: colorOptions.length,
        itemBuilder: (context, index) {
          final color = colorOptions[index];

          return GestureDetector(
            onTap: () {
              themeProvider.setCustomColors(color, themeProvider.secondaryColor);
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: themeProvider.primaryColor == color
                      ? Colors.black
                      : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
