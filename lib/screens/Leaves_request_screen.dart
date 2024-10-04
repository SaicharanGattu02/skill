import 'package:flutter/material.dart';

class Leave extends StatefulWidget {
  const Leave({super.key});

  @override
  State<Leave> createState() => _LeaveState();
}
  bool _loading =false;
class _LeaveState extends State<Leave> {
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
          "Apply Leave",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500,
            height: 29.05 / 24.0,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Image.asset(
              "assets/Plus square.png",
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
      body:

      _loading?Center(child: CircularProgressIndicator(color: Color(0xff8856F4),)):

      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      width: 20,
                      height: 20,
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
              SizedBox(
                height: 16,
              ),

              Row(
                children: [
                  Container(
                    width: w * 0.42,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff2FB0351A).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff).withOpacity(0.50),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                              child: Text(
                            "16",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              color: Color(0xff2FB035),
                              fontWeight: FontWeight.w700,
                              height: 38.4 / 24,
                              letterSpacing: 0.14,
                            ),
                          )),
                        ),
                        SizedBox(height: 6,),
                        SizedBox(width: w*0.3,
                          child: Text(
                            "Available Leaves",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xff290358),
                              fontWeight: FontWeight.w600,
                              height: 19.36 / 16,
                              letterSpacing: 0.14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: w * 0.030),
                  Container(
                    width: w * 0.42,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff2FB0351A).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff).withOpacity(0.50),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                              child: Text(
                            "16",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              color: Color(0xff8856F4),
                              fontWeight: FontWeight.w700,
                              height: 38.4 / 24,
                              letterSpacing: 0.14,
                            ),
                          )),
                        ),


                        SizedBox(height: 6,),
                        SizedBox(width: w*0.4,
                          child: Text(
                            "previous unused Leaves",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xff290358),
                              fontWeight: FontWeight.w600,
                              height: 19.36 / 16,
                              letterSpacing: 0.14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.0),
              Row(
                children: [
                  Container(
                    width: w * 0.42,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff2FB0351A).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff).withOpacity(0.50),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                              child: Text(
                            "16",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              color: Color(0xffEFA84E),
                              fontWeight: FontWeight.w700,
                              height: 38.4 / 24,
                              letterSpacing: 0.14,
                            ),
                          )),
                        ),



                        SizedBox(height: 6,),
                        SizedBox(width: w*0.4,
                          child: Text(

                            "Pending Leaves Requests",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xff290358),
                              fontWeight: FontWeight.w600,
                              height: 19.36 / 16,
                              letterSpacing: 0.14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: w * 0.030),
                  Container(
                    width: w * 0.42,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff2FB0351A).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                           
                            color: Color(0xffffffff).withOpacity(0.50),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                              child: Text(
                            "16",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              color: Color(0xffDD0000),
                              fontWeight: FontWeight.w700,
                              height: 38.4 / 24,
                              letterSpacing: 0.14,
                            ),
                          )),
                        ),
                        SizedBox(height: 6,),
                        SizedBox(width: w*0.3,
                          child: Text(
                            "Rejected Leaves",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xff290358),
                              fontWeight: FontWeight.w600,
                              height: 19.36 / 16,
                              letterSpacing: 0.14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Text('Leaves List',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Spacer(),
                  SizedBox(height: 66.0),

                  Center(

                    child: ElevatedButton(
                      onPressed: () {
                        // Handle "Apply Leaves" action
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xff8856F4), // Text color
                        padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12), // Add padding if needed
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                      ),

                      child: Text(
                        'Apply Leaves',
                        style: TextStyle(
                          color: Color(
                              0xffffffff), // You can also control text color here, though 'onPrimary' will work
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.0),

              // Wrapping ListView.builder in a SizedBox to manage height
              SizedBox(
                height:
                    300.0, // Set an appropriate height based on the list size
                child: ListView.builder(
                  itemCount: 4, // Replace with actual number of leave requests
                  itemBuilder: (context, index) {
                    return Container(decoration: BoxDecoration(color:Color(0xff) ),
                        child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Maternity Leave'), // Original text
                                SizedBox(
                                    height:
                                        4), // Add some spacing between the lines
                                Text(
                                  "Friend’s Birth Day Celebration", // New line of text
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors
                                          .grey), // Optional style for the new text
                                ),
                              ],
                            ),
                            subtitle: Text(
                                '19 July 2024 - 01:00 PM (4 Hours)'),
                            trailing: Container(decoration: BoxDecoration(color: Color(0xffFEF7EC),borderRadius: BorderRadius.circular(100)),
                              child: Text('Pending',
                                  style: TextStyle(
                                    color: Color(0xffEFA84E),
                                    backgroundColor: Colors.black12,)),
                            )));
                  },
                ),
              ),

              // Add space between list and the button
              SizedBox(height: 16.0),




            ],
          ),
        ),
      ),
    );
  }
}
