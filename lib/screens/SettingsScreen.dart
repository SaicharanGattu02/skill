import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/ThemeProvider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    List<Color> colorOptions = [
      Color(0xFF8856f4), // Example colors
      Color(0xFF03DAC6),
      Color(0xFFFF5722),
      Color(0xFF4CAF50),
      Color(0xFF2196F3),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
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
