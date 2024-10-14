import 'package:flutter/material.dart';
import 'package:skill/utils/CustomAppBar.dart';

class ProfileDashboard extends StatefulWidget {

  const ProfileDashboard({super.key});

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  bool _loading =true;
  int _selectedTabIndex = 0;
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
          title: Text(
           'Edit Profile',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.0,
              color: Color(0xffffffff),
              fontWeight: FontWeight.w500,
              height: 26.05 / 20.0,
            ),
          ),
          actions: (_selectedTabIndex == 1 ||
              _selectedTabIndex == 2 ||
              _selectedTabIndex == 3)
              ? [
            Row(
              children: [
                Image.asset(
                  "assets/tasktime.png",
                  width: 19,
                  height: 19,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ProjectsScreen()));
                  },
                  child: Image.asset(
                    "assets/taskclockhistory.png",
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 10),
                if (_selectedTabIndex != 3)
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      "assets/filter.png",
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                SizedBox(width: 16),
              ],
            )
          ]
              : null),
      body:  _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):
      Container(),
    );
  }
}
