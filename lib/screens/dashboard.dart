import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, String>> items1 = [
    {'image': 'assets/ray.png', 'text': 'Raay App', 'value': '0.35'},
    {'image': 'assets/payjet.png', 'text': 'Payjet App', 'value': '0.85'},
    {'image': 'assets/ray.png', 'text': 'Raay App', 'value': '0.35'},
    {'image': 'assets/payjet.png', 'text': 'Payjet App', 'value': '0.85'},
    {'image': 'assets/ray.png', 'text': 'Raay App', 'value': '0.35'},
    {'image': 'assets/payjet.png', 'text': 'Payjet App', 'value': '0.85'},
    {'image': 'assets/ray.png', 'text': 'Raay App', 'value': '0.35'},
    {'image': 'assets/payjet.png', 'text': 'Payjet App', 'value': '0.85'},
  ];

  final List<Map<String, String>> items = [
    {'image': 'assets/pixl.png', 'text': '# Pixl Team'},
    {'image': 'assets/hrteam.png', 'text': '# Designers'},
    {'image': 'assets/pixl.png', 'text': '# UIUX'},
    {'image': 'assets/designers.png', 'text': '# Hr Team'},
    {'image': 'assets/pixl.png', 'text': '# BDE Team'},
    {'image': 'assets/developer.png', 'text': '# Developers'},
    {'image': 'assets/pixl.png', 'text': '# Pixl Team'},
    {'image': 'assets/hrteam.png', 'text': '# Designers'},
    {'image': 'assets/pixl.png', 'text': '# UIUX'},
    {'image': 'assets/designers.png', 'text': '# Hr Team'},
    {'image': 'assets/pixl.png', 'text': '# BDE Team'},

  ];

  final List<Map<String, String>> users = [
    {
      "name": "Prashanth Chary",
      "imagePath": "assets/prashanth.png",
      'isActive': 'true'
    },
    {
      "name": "Prashanth Chary",
      "imagePath": "assets/prashanth.png",
      'isActive': 'false'
    },
    {
      "name": "Prashanth Chary",
      "imagePath": "assets/prashanth.png",
      'isActive': 'true'
    }
  ];

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xffF3ECFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null, // Hides the leading icon (for drawer)
        actions: <Widget>[
          Container()
        ], // this will hide endDrawer hamburger icon
        toolbarHeight: 48,
        backgroundColor: const Color(0xff8856F4),
        title: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Image.asset(
                  "assets/menu.png",
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              Image.asset(
                "assets/skillLogo.png",
                width: 80,
                height: 40,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              Row(
                children: [
                  Image.asset(
                    "assets/notify.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    child: Image.asset(
                      "assets/dashboard.png",
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
          child: Column(
            children: [
              // Search Container
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/search.png",
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Search",
                      style: TextStyle(
                          color: Color(0xff9E7BCA),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              // User Info Container
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xff8856F4),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Center(
                            child: Image.asset(
                              "assets/pic.jpeg",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // User Info and Performance
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Prashanth Chary",
                                      style: const TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: "Inter"),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Image.asset(
                                    "assets/edit.png",
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 15),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff2FB035),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Text(
                                      "Active",
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: "Nunito"),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // UX/UI and Performance in a Row
                              Row(
                                children: [
                                  // UX/UI and Contact Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "UX/UI Designer",
                                          style: TextStyle(
                                              color: const Color(0xffFFFFFF)
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: "Inter"),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "prashanth@pixl.in",
                                          style: TextStyle(
                                              color: const Color(0xffFFFFFF)
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: "Inter"),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "96541 25641",
                                          style: TextStyle(
                                              color: const Color(0xffFFFFFF)
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: "Inter"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  // Performance Container
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "79.65%",
                                          style: TextStyle(
                                              color: Color(0xff2FB035),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: "Nunito"),
                                        ),
                                        Text(
                                          "Performance",
                                          style: TextStyle(
                                              color: Color(0xff8856F4),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: "Nunito"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    "Ongoing Projects",
                    style: TextStyle(
                        color: Color(0xff16192C),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        fontFamily: "Inter"),
                  ),
                  const Spacer(),
                  const Text(
                    "See all",
                    style: TextStyle(
                        color: Color(0xff8856F4),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xff8856F4),
                        fontFamily: "Inter"),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 160, // Adjust height to fit your design
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items1.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Two items per row
                    childAspectRatio: 0.9, // Adjust this ratio to fit your design
                    mainAxisSpacing: 12, // Space between items horizontally
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xffF7F4FC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Center Image
                            Image.asset(
                              items1[index]['image']!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 8),
                            // Bottom Text
                            Text(
                              items1[index]['text']!,
                              style: const TextStyle(
                                  color: Color(0xff4F3A84),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: "Nunito"),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Progress",
                                  style: TextStyle(
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontFamily: "Inter"),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: double.parse(items1[index]['value']!),
                                  backgroundColor: const Color(0xffE0E0E0),
                                  color: const Color(0xff2FB035),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    "Channels",
                    style: TextStyle(
                        color: Color(0xff16192C),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        fontFamily: "Inter"),
                  ),
                  const Spacer(),
                  const Text(
                    "See all",
                    style: TextStyle(
                        color: Color(0xff8856F4),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xff8856F4),
                        fontFamily: "Inter"),
                  ),
                ],
              ),

              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 140, // Adjust the height to fit your design
                child: GridView.builder(
                  scrollDirection:
                      Axis.horizontal, // Changed to vertical to display in rows
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio:
                        0.362, // Adjust this ratio to fit your design
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xffF7F4FC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            // Center Image
                            Image.asset(
                              items[index]['image']!,
                              width: 32,
                              height: 32,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 8),
                            // Bottom Text
                            Text(
                              items[index]['text']!,
                              style: const TextStyle(
                                color: Color(0xff27272E),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: "Inter",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 2, bottom: 3),
                              decoration: BoxDecoration(
                                  color: Color(0x1A8856F4),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  "23",
                                  style: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Sarabun"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Projects",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter"),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 2, bottom: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xffF1FFF3),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  "06",
                                  style: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Sarabun"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "To Do",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter"),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 2, bottom: 5),
                              decoration: BoxDecoration(
                                  color: Color(0x1AFBBC04),

                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  "04",
                                  style: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Sarabun"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Tasks",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter"),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 2, bottom: 5),
                              decoration: BoxDecoration(
                                  color: Color(0x1A08BED0),

                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  "01",
                                  style: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Sarabun"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "meetings",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      width: w,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff8856F4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Punch In",
                            style: TextStyle(
                                color: Color(0xffffffff),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter"),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Image.asset(
                            "assets/fingerPrint.png",
                            fit: BoxFit.contain,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xff8856F4),
        width: w * 0.6,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 40),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Spacer(),
                            Image.asset(
                              "assets/skillLogo.png",
                              fit: BoxFit.contain,
                              width: 60,
                              height: 30,
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                "assets/cross.png",
                                fit: BoxFit.contain,
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Color(0xffFFC746), width: 1),
                                  ),
                                  child: Image.asset(
                                    "assets/prashanth.png",
                                    fit: BoxFit.contain,
                                    width: 43,
                                    height: 43,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: 60,
                                  child: Text(
                                    "Prashanth",
                                    style: const TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Inter",
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: w * 0.020),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Color(0xffFFC746), width: 1),
                                  ),
                                  child: Image.asset(
                                    "assets/prashanth.png",
                                    fit: BoxFit.contain,
                                    width: 43,
                                    height: 43,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: 60,
                                  child: Text(
                                    "Prashanth",
                                    style: const TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Inter",
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: w * 0.020),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Color(0xffFFC746), width: 1),
                                  ),
                                  child: Image.asset(
                                    "assets/prashanth.png",
                                    fit: BoxFit.contain,
                                    width: 43,
                                    height: 43,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: 60,
                                  child: Text(
                                    "Prashanth",
                                    style: const TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Inter",
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 32,
                    margin: EdgeInsets.only(left: 16, right: 16, top: 12),
                    padding: EdgeInsets.only(left: 10, top: 6, bottom: 6),
                    decoration: BoxDecoration(
                      color: Color(0xffEAE0FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Color(0xff9E7BCA)),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Color(0xff9E7BCA),
                        ),
                      ),
                      style: TextStyle(
                          color: Color(0xff9E7BCA),
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xffffffff),
                              size: 25,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Direct messages",
                              style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  "assets/prashanth.png",
                                  fit: BoxFit.contain,
                                  width: 43,
                                  height: 43,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                "Prashanth Chary",
                                style: const TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: "Inter"),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "you",
                              style: TextStyle(
                                  color: Color(0xffFFFFFF).withOpacity(0.7),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: "Inter"),
                            ),
                          ],
                        ),
                        ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          itemCount: users.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final bool isActive = user['isActive'] == 'true';
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Image.asset(
                                        user['imagePath'] ?? '',
                                        fit: BoxFit.contain,
                                        width: 43,
                                        height: 43,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? Colors.green
                                                : Color(0xff8856F4),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      user['name'] ?? '',
                                      style: const TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Image.asset(
                                    "assets/notify.png",
                                    fit: BoxFit.contain,
                                    width: 24,
                                    height: 24,
                                    color: Color(0xffFFFFFF).withOpacity(0.7),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 30),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xffFFFFFF1A).withOpacity(0.10)),
                    child: Center(
                        child: Image.asset(
                      "assets/add.png",
                      fit: BoxFit.contain,
                      height: 9,
                      width: 9,
                    )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Add channels",
                    style: const TextStyle(
                      color: Color(0xffFFFFFF),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: "Inter",
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        width: w * 0.3,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 40),
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Color(0xfff8856F4),
                      borderRadius: BorderRadius.circular(4)),
                  child: Image.asset("assets/dashboard.png"),
                ),
                SizedBox(height: 4,),
                Text("Dashboard",
                  style:  TextStyle(
                    color: Color(0xff8856F4),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Inter",
                  ),),

                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(4)),
                  child: Image.asset("assets/msg.png"),
                ),
                SizedBox(height: 4,),
                Text("Messages",
                  style:  TextStyle(
                    color: Color(0xff6C848F),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Inter",
                  ),),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(4)),
                  child: Image.asset("assets/folder-plus.png"),
                ),
                SizedBox(height: 4,),
                Text("To Do List",
                  style:  TextStyle(
                    color: Color(0xff6C848F),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Inter",
                  ),),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(4)),
                  child: Image.asset("assets/Frame.png"),
                ),
                SizedBox(height: 4,),
                Text("Projects",
                  style:  TextStyle(
                    color: Color(0xff6C848F),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Inter",
                  ),),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(4)),
                  child: Image.asset("assets/Channel.png"),
                ),
                SizedBox(height: 4,),
                Text("Channels",
                  style:  TextStyle(
                    color: Color(0xff6C848F),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Inter",
                  ),),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(4)),
                  child: Image.asset("assets/calendar.png"),
                ),
                SizedBox(height: 4,),
                Text("Leaves",
                  style:  TextStyle(
                    color: Color(0xff6C848F),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Inter",
                  ),),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(4)),
                  child: Image.asset("assets/video.png"),
                ),
                SizedBox(height: 4,),
                Text("Meetings",
                  style:  TextStyle(
                    color: Color(0xff6C848F),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Inter",
                  ),),

                Spacer(),

                Container(
                  padding: EdgeInsets.all(4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(4)),
                  child: Image.asset("assets/Settings.png"),
                ),
                SizedBox(height: 4,),
                Text("Settings",
                  style:  TextStyle(
                    color: Color(0xff6C848F),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Inter",
                  ),),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(4)),
                  child: Image.asset("assets/logout.png"),
                ),
                SizedBox(height: 4,),
                Text("Logout",
                  style:  TextStyle(
                    color: Color(0xffDE350B),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Inter",
                  ),),
                SizedBox(height: 22,),






              ],
            ),
          ),
        ),
      ),
    );
  }
}
