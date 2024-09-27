import 'package:flutter/material.dart';
import 'package:skill/utils/CustomAppBar.dart'; // Assuming your CustomAppBar is in utils

class TaskBan extends StatefulWidget {
  const TaskBan({super.key});

  @override
  State<TaskBan> createState() => _TaskBanState();
}

class _TaskBanState extends State<TaskBan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'TaskBan',
        actions: [],
      ),
      body: Center(

      ),
    );
  }
}
