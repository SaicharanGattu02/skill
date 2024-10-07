import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // TextEditingController to manage the date input
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the current date when the screen is initialized
    _setCurrentDate();
  }

  void _setCurrentDate() {
    // Get the current date and format it
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _dateController.text = formattedDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now(); // Current date
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate, // Set the initial date to today
      firstDate: currentDate, // Prevent past dates
      lastDate: DateTime(2100), // You can set an upper limit for the future date
    );

    if (picked != null && picked != currentDate) {
      setState(() {
        // Format the selected date and update the controller
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
        actions: [
          // ElevatedButton(
          //   onPressed: () {
          //     // Add task logic
          //   },
          //   child: Text('Add Task'),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Name Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Description Field
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Date Field with Current Date
              TextField(
                controller: _dateController, // Controller to handle current date
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Make the field read-only
                onTap: () {
                  // Open the date picker when the field is tapped
                  _selectDate(context);
                },
              ),
              SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: ['High', 'Medium', 'Low'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {},
              ),
              SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Label',
                  border: OutlineInputBorder(),
                ),
                items: ['Work', 'Personal', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {},
              ),
              SizedBox(height: 16),

              // Status Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Open', 'In Progress', 'Done'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {},
              ),
              SizedBox(height: 16),

              // Buttons for Save and Cancel
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Dismiss the screen
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Save task logic here
                    },
                    child: Text('Add Task'),
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


