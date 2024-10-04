import 'package:flutter/material.dart';

class AlertDialogScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xffFFFFFF),

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
                      borderRadius:
                          BorderRadius.circular(20), // Custom radius for dialog
                    ),
                    contentPadding: EdgeInsets.all(30), // Padding of 30px
                    content: Container(
                      width: 398, // Fixed width
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Add Channel",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: "Inter",
                                    color: Color(0xff1C1D22),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                Image.asset("assets/crossblue.png",height: 20,width: 20,)
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Create Channel",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        10), // Small gap between text and text field
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter channel name',
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        20), // Additional gap between fields

                                Text(
                                  "Channel Type",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter Channel Type',
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        20), // Additional gap between fields

                                Text(
                                  "Channel Members",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter Channel Members',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    40), // Gap of 40px between text field and buttons

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
                                      Navigator.of(context)
                                          .pop(); // Close dialog
                                    },
                                    child: Text("Close"),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            7), // Custom radius
                                      ),
                                      side: BorderSide(
                                        color: Color(
                                            0xff8856F4), // Custom border color
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
                                    child: Text("Save",
                                        style: TextStyle(
                                            color: Color(0xffffffff))),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            7), // Custom radius
                                      ),
                                      backgroundColor:
                                          Color(0xff8856F4), // Background color
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
