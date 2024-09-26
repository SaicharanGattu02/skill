import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'; // Import the dotted border package

class AlertDialogScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Full screen white background
      body: Center(
        child: Builder(
          builder: (context) {
            // Showing the dialog when the screen builds
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Custom radius for dialog
                    ),
                    contentPadding: EdgeInsets.all(20), // Padding of 30px
                    content: Container(
                      width: 398,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Min height for alert dialog
                          children: [
                            // Header Section with Back Arrow, Title, and Close Icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close dialog
                                      },
                                    ),
                                    Text(
                                      "Add Project",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.close_rounded),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close dialog
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 40), // Gap of 40px

                            // Text "Create Channel" and Text Fields
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Title",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10), // Small gap between text and text field
                                TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter Topic',
                                  ),style: TextStyle(color: Color(0xf371F41)),
                                ),
                              ],
                            ),
                            SizedBox(height: 40), // Gap of 40px between text field and buttons

                            // Dotted Border with File Buttons
                            DottedBorder(
                              color: Colors.grey, // Color of the dotted border
                              strokeWidth: 1,
                              dashPattern: [6, 3], // Dotted pattern
                              borderType: BorderType.RRect, // Rounded rectangle
                              radius: Radius.circular(8),
                              padding: EdgeInsets.all(10.0), // Padding around the Row
                              child: Row(
                                children: [
                                  // Choose File Button
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Action to pick file
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1), // Light blue background
                                          border: Border.all(
                                            color: Color(0xff8856F4),
                                            style: BorderStyle.solid,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Choose File',
                                            style: TextStyle(
                                              color: Color(0xff8856F4),
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16), // Spacing between buttons

                                  // No File Chosen Button
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Action if needed
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          // color: Colors.grey.withOpacity(0.1), // Light grey background
                                          // border: Border.all(
                                          //   color: Colors.grey,
                                          //   style: BorderStyle.solid,
                                          //   width: 1.0,
                                          // ),
                                          // borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'No File',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 30), // Gap of 40px between dotted border and buttons

                            // Buttons Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Close Button with border
                                SizedBox(
                                  width: 110, // Custom width
                                  height: 42, // Custom height
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close dialog
                                    },
                                    child: Text("Close"),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7), // Custom radius
                                      ),
                                      side: BorderSide(
                                        color: Color(0xff8856F4), // Custom border color
                                        width: 1, // Custom border width
                                      ),
                                    ),
                                  ),
                                ),
                                // Save Button with solid color
                                SizedBox(
                                  width: 110, // Custom width
                                  height: 42, // Custom height
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Handle save action
                                    },
                                    child: Text("Save", style: TextStyle(color: Color(0xffffffff))),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7), // Custom radius
                                      ),
                                      backgroundColor: Color(0xff8856F4), // Background color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            });

            return Container(); // Return an empty container since the dialog is the main content
          },
        ),
      ),
    );
  }
}
