import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: AppBar(
        backgroundColor: const Color(0xff8856F4),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
          ),
        ),
        title: const Text(
          "Todo",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
            height: 29.05 / 24.0,
          ),
        ),
      ),
      body: Container( width: w,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF), // Surrounding container color
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text("Good Morning,", style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      height: 26.0 / 16.0,
                      letterSpacing: 0.3,
                      color: Colors.black,
                    ),),
                    SizedBox(height: 5,),
                    Expanded(
                      child: Text("Prashanth,", style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        height: 26.0 / 24.0,
                        letterSpacing: 0.3,
                        overflow: TextOverflow.ellipsis,
                        color: Color(0xff1E293B),
                      ),),
                    ),
                  ],
                ),
                Image.asset("assets/sun.png")
              ],
            ),
          ],
        ),
      ),

    );
  }
}
