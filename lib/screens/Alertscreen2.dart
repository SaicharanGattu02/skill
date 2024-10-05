import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class FullScreenLeaveForm extends StatelessWidget {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width; // Get the screen width

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Apply Leave",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close_rounded, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Add padding around the content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5), // Gap of 20px

              // "From Date" Field with Calendar Icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "From Date",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: fromDateController,
                    readOnly: true, // Prevent manual input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7), // Radius 7px
                        borderSide: BorderSide(
                          color: Color(0xffD0CBDB), // Border color #D0CBDB
                          width: 1, // Border width 1px
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10, // Padding top and bottom
                        horizontal: 14, // Padding left and right
                      ),
                      hintText: 'Select From Date',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            fromDateController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate); // Set date in controller
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // "To Date" Field with Calendar Icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "To Date",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: toDateController,
                    readOnly: true, // Prevent manual input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7), // Radius 7px
                        borderSide: BorderSide(
                          color: Color(0xffD0CBDB), // Border color #D0CBDB
                          width: 1, // Border width 1px
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10, // Padding top and bottom
                        horizontal: 14, // Padding left and right
                      ),
                      hintText: 'Select To Date',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            toDateController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate); // Set date in controller
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // "Leave Type" Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Leave Type",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7), // Radius 7px
                        borderSide: BorderSide(
                          color: Color(0xffD0CBDB), // Border color #D0CBDB
                          width: 1, // Border width 1px
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10, // Padding top and bottom
                        horizontal: 14, // Padding left and right
                      ),
                    ),
                    hint: Text("Select Leave Type"),
                    items: [
                      DropdownMenuItem(
                        value: 'Sick Leave',
                        child: Text('Sick Leave'),
                      ),
                      DropdownMenuItem(
                        value: 'Casual Leave',
                        child: Text('Casual Leave'),
                      ),
                      DropdownMenuItem(
                        value: 'Annual Leave',
                        child: Text('Annual Leave'),
                      ),
                    ],
                    onChanged: (value) {
                      // Handle dropdown value change
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // "Reason" Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reason",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7), // Radius 7px
                        borderSide: BorderSide(
                          color: Color(0xffD0CBDB), // Border color #D0CBDB
                          width: 1, // Border width 1px
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10, // Padding top and bottom
                        horizontal: 14, // Padding left and right
                      ),
                      hintText: 'Enter Reason',
                    ),
                    maxLines: 3, // Reason field with more lines for text input
                  ),
                ],
              ),
              SizedBox(height: 30), // Gap between fields and buttons

              // Buttons Section
              Row(
                children: [
                  // Close Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(); // Handle close action
                      },
                      icon: Icon(Icons.close, color: Color(0xff8856F4)), // Close icon
                      label: Text(
                        'Close',
                        style: TextStyle(
                          color: Color(0xff8856F4),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffF8FCFF), // Background color
                        side: BorderSide(
                          color: Color(0xff8856F4),
                          width: 1.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Gap between buttons

                  // Save Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle save action
                      },
                      icon: Image.asset("assets/container_correct.png" ,color: Colors.white), // Save icon
                      label: Text(
                        'Apply Leave',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff8856F4), // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
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
  }
}

