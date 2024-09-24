import 'package:flutter/material.dart';

class Groupmembers extends StatefulWidget {
  const Groupmembers({super.key});

  @override
  State<Groupmembers> createState() => _GroupmembersState();
}

final List<Map<String, String>> items = [

  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},
  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},
  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},
  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},
  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},
  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},
  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},
  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},
  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},
  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},
  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},
  {'image': 'assets/prashanth.png', 'text': 'Prashanth'},
  {'image': 'assets/hrteam.png', 'text': 'Varun'},
  {'image': 'assets/pixl.png', 'text': 'Varun'},

];

class _GroupmembersState extends State<Groupmembers> {
  @override
  Widget build(BuildContext context) {
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
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                "assets/pixl.png",
                fit: BoxFit.contain,
                width: 45,
                height: 45,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Pixal Team",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    height: 19.36 / 16,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text("2354 Members",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    height: 14.52 / 12,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Image.asset(
                "assets/meet.png",
                width: 24,
                height: 24,
                color: Color(0xffffffff),
              ),
              const SizedBox(width: 18),
              const Icon(Icons.call, size: 24, color: Color(0xffffffff)),
              const SizedBox(width: 18),
              const Icon(Icons.more_vert_rounded, size: 24, color: Color(0xffffffff)),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 items per row
            crossAxisSpacing: 8.0, // spacing between columns
            mainAxisSpacing: 8.0, // spacing between rows
            childAspectRatio: 0.8, // Adjusts height relative to width
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    items[index]['image']!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  items[index]['text']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
