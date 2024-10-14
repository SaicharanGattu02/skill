import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill/ProjectModule/TabBar.dart';
import 'package:skill/utils/CustomAppBar.dart';
import '../Model/ProjectsModel.dart';
import '../Services/UserApi.dart';
import '../utils/Mywidgets.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {

  List<Data> projectsData = [];
  List<Data> filteredRooms = [];
  bool isLoading = true;
  bool _loading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredRooms = projectsData.where((room) {
        String otherUser = room.name?.toLowerCase() ?? '';
        return otherUser.contains(query);
      }).toList();
      print('Filtered rooms: ${filteredRooms.length}'); // Debug log
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    GetProjectsData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mileStoneController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();
  final TextEditingController _colloratorsController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final FocusNode _focusNodetitle = FocusNode();
  final FocusNode _focusNodedescription = FocusNode();
  final FocusNode _focusNodemileStone = FocusNode();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodeassignedTo = FocusNode();
  final FocusNode _focusNodecollorators = FocusNode();
  final FocusNode _focusNodestatus = FocusNode();
  final FocusNode _focusNodepriority = FocusNode();
  final FocusNode _focusNodestartDate = FocusNode();
  final FocusNode _focusNodedeadline = FocusNode();
  // final spinkit=Spinkits();


  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime(2101), // Maximum date
    );
    if (pickedDate != null) {
      controller.text =
          DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
    }
  }


  bool isSelected = false;

  Future<void> GetProjectsData() async {
    var Res = await Userapi.GetProjectsList();
    setState(() {
      if (Res != null && Res.data != null) {
        _loading = false;
        if (Res.settings?.success == 1) {
          isLoading = false;
          projectsData = Res.data ?? [];
          filteredRooms = projectsData; // Initialize filteredRooms with all projects
        } else {
          isLoading = false;
        }
      } else {
        isLoading = false; // Handle empty or null response
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      appBar: CustomAppBar(
        title: 'All Projects',
        actions: [Container()],
        onPlusTap: () {
          // Show the bottom sheet on plus icon tap
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return _bottomSheet(context);
            },
          );
        },
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: Color(0xff8856F4)))
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            SizedBox(
              width: w,
              // height: h * 0.043,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                Row(
                  children: [
                    Image.asset(
                      "assets/search.png",
                      width: 20,
                      height: 17,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Color(0xff9E7BCA),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontFamily: "Nunito",
                          ),
                        ),
                        style: TextStyle(
                          color: Color(0xff9E7BCA),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          decorationColor: Color(0xff9E7BCA),
                          fontFamily: "Nunito",
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredRooms.isEmpty
                  ? _buildEmptyPlaceholder()
                  : _buildProjectGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.75;
    double w = MediaQuery.of(context).size.width;

    return Container(
      height: h, // Set the height to 70% of the screen
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: w * 0.1,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                "Add Project",
                style: TextStyle(
                    color: Color(0xff1C1D22),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    height: 18 / 16),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pop(); // Close the BottomSheet when tapped
                },
                child: Container(
                  width: w * 0.05,
                  height: w * 0.05,
                  decoration: BoxDecoration(
                    color: Color(0xffE5E5E5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                      child: Image.asset(
                    "assets/crossblue.png",
                    fit: BoxFit.contain,
                    width: w * 0.023,
                    height: w * 0.023,
                    color: Color(0xff8856F4),
                  )),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label(text: 'Title'),
                  SizedBox(height: 6),
                  _buildTextFormField(
                    controller: _titleController,
                    focusNode: _focusNodetitle,
                    hintText: 'Enter Project Name',
                    validationMessage: 'please enter project name',
                  ),
                  SizedBox(height: 10),
                  DottedBorder(
                    color: Color(0xffD0CBDB),
                    strokeWidth: 1,
                    dashPattern: [2, 2],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(8),
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 35,
                            width: w * 0.35,
                            decoration: BoxDecoration(
                              color: Color(0xffF8FCFF),
                              border: Border.all(
                                color: Color(0xff8856F4),
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
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Center(
                          child: Text(
                            'No File Chosen',
                            style: TextStyle(
                              color: Color(0xff3C3C3C),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  _label(text: 'Description'),
                  SizedBox(height: 4),
                  _buildTextFormField(
                    controller: _descriptionController,
                    focusNode: _focusNodedescription,
                    hintText: 'Type Description',
                    validationMessage: 'please type description',
                  ),
                  SizedBox(height: 10),
                  _label(text: 'Milestone'),
                  SizedBox(height: 4),
                  _buildTextFormField(
                    controller: _mileStoneController,
                    focusNode: _focusNodemileStone,
                    hintText: 'Type Milestone',
                    validationMessage: 'please type milestone',
                    suffixicon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Color(0xff000000),
                    ),
                  ),
                  SizedBox(height: 10),
                  _label(text: 'Assign to'),
                  SizedBox(height: 4),
                  _buildTextFormField(
                    controller: _assignedToController,
                    focusNode: _focusNodeassignedTo,
                    hintText: 'Assign to',
                    validationMessage: 'please assign someone',
                    suffixicon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Color(0xff000000),
                    ),
                  ),
                  SizedBox(height: 10),
                  _label(text: 'Collaborators'),
                  SizedBox(height: 4),
                  _buildTextFormField(
                    controller: _colloratorsController,
                    focusNode: _focusNodecollorators,
                    hintText: 'Collaborators',
                    validationMessage: 'please add collaborators',
                    suffixicon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Color(0xff000000),
                    ),
                  ),
                  SizedBox(height: 10),
                  _label(text: 'Status'),
                  SizedBox(height: 4),
                  _buildTextFormField(
                    controller: _statusController,
                    focusNode: _focusNodestatus,
                    hintText: 'Status',
                    validationMessage: 'please add a status',
                    suffixicon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Color(0xff000000),
                    ),
                  ),
                  SizedBox(height: 10),
                  _label(text: 'Priority'),
                  SizedBox(height: 4),
                  _buildTextFormField(
                    controller: _priorityController,
                    focusNode: _focusNodepriority,
                    hintText: 'Priority',
                    validationMessage: 'please add a priority',
                    suffixicon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Color(0xff000000),
                    ),
                  ),
                  SizedBox(height: 10),
                  _label(text: 'Start Date'),
                  SizedBox(height: 4),
                  _buildDateField(
                    _startDateController,
                  ),
                  SizedBox(height: 10),
                  _label(text: 'Deadline'),
                  SizedBox(height: 4),
                  _buildDateField(
                    _deadlineController,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
                height: 40,
                width: w * 0.43,
                decoration: BoxDecoration(
                  color: Color(0xffF8FCFF),
                  border: Border.all(
                    color: Color(0xff8856F4),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Color(0xff8856F4),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                height: 40,
                width: w * 0.43,
                decoration: BoxDecoration(
                  color: Color(0xff8856F4),
                  border: Border.all(
                    color: Color(0xff8856F4),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid(double width) {
    return GridView.builder(
      itemCount: 8, // Number of shimmer placeholders
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              shimmerCircle(48), // Shimmer for the circular image
              const SizedBox(height: 8),
              shimmerText(100, 16), // Shimmer for title text
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  shimmerText(50, 12), // Shimmer for progress label
                  shimmerText(30, 12), // Shimmer for percentage text
                ],
              ),
              const SizedBox(height: 4),
              shimmerLinearProgress(7), // Shimmer for progress indicator
            ],
          ),
        );
      },
    );
  }
  Widget _buildProjectGrid() {
    // Check if filteredRooms is empty to determine if we need to show a message
    if (filteredRooms.isEmpty) {
      return Center(
        child: Text(
          'No results found.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }





    return GridView.builder(
      itemCount: filteredRooms.length, // Use filteredRooms here
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final data = filteredRooms[index]; // Use filteredRooms here

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyTabBar(
                  titile: '${data.name ?? ""}',
                  id: '${data.id}',
                ),
              ),
            );
            print('idd>>${data.id}');
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffF7F4FC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.network(
                    data.icon ?? "",
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.name ?? "",
                  style: const TextStyle(
                    color: Color(0xff4F3A84),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 19.36 / 16,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Nunito",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Progress",
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        fontFamily: "Inter",
                      ),
                    ),
                    Text(
                      "${data.totalPercent ?? ""}%",
                      style: const TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: (data.totalPercent?.toDouble() ?? 0) / 100.0,
                  minHeight: 7,
                  backgroundColor: const Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xff2FB035),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _buildProjectGrid() {
  //   return GridView.builder(
  //     itemCount: projectsData.length,
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       childAspectRatio: 1,
  //       mainAxisSpacing: 10,
  //       crossAxisSpacing: 10,
  //     ),
  //     itemBuilder: (context, index) {
  //       final data = projectsData[index];
  //
  //       return
  //         InkWell(onTap: (){
  //           Navigator.push(context, MaterialPageRoute(builder: (context)=>MyTabBar(titile: '${data.name ?? ""}',id:'${data.id}',)));
  //           print('idd>>${data.id}');
  //         },
  //           child: Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: const Color(0xffF7F4FC),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               ClipOval(
  //                 child: Image.network(
  //                   data.icon ?? "",
  //                   width: 48,
  //                   height: 48,
  //                   fit: BoxFit.contain,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 data.name ?? "",
  //                 style: const TextStyle(
  //                   color: Color(0xff4F3A84),
  //                   fontWeight: FontWeight.w500,
  //                   fontSize: 16,
  //                   height: 19.36 / 16,
  //                   overflow: TextOverflow.ellipsis,
  //                   fontFamily: "Nunito",
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   const Text(
  //                     "Progress",
  //                     style: TextStyle(
  //                       color: Color(0xff000000),
  //                       fontWeight: FontWeight.w400,
  //                       fontSize: 12,
  //                       fontFamily: "Inter",
  //                     ),
  //                   ),
  //                   Text(
  //                     "${data.totalPercent ?? ""}%",
  //                     style: const TextStyle(
  //                       color: Color(0xff000000),
  //                       fontWeight: FontWeight.w400,
  //                       fontSize: 12,
  //                       fontFamily: "Inter",
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 4),
  //               LinearProgressIndicator(
  //                 value: (data.totalPercent?.toDouble() ?? 0) / 100.0,
  //                 minHeight: 7,
  //                 backgroundColor: const Color(0xffE0E0E0),
  //                 borderRadius: BorderRadius.circular(20),
  //                 color: const Color(0xff2FB035),
  //               ),
  //             ],
  //           ),
  //                   ),
  //         );
  //     },
  //   );
  // }

  Widget _label({
    required String text,
  }) {
    return Text(text,
        style: TextStyle(
            color: Color(0xff141516),
            fontFamily: 'Inter',
            fontSize: 14,
            height: 16.36 / 14,
            fontWeight: FontWeight.w400));
  }

  Widget _buildTextFormField(
      {required TextEditingController controller,
      required FocusNode focusNode,
      bool obscureText = false,
      required String hintText,
      required String validationMessage,
      TextInputType keyboardType = TextInputType.text,
      Widget? prefixicon,
      Widget? suffixicon}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.050,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        cursorColor: Color(0xff8856F4),
        decoration: InputDecoration(
          hintText: hintText,
          // prefixIcon: Container(
          //     width: 21,
          //     height: 21,
          //     padding: EdgeInsets.only(top: 10, bottom: 10, left: 6),
          //     child: prefixicon),
          suffixIcon: suffixicon,
          hintStyle: const TextStyle(
            fontSize: 14,
            letterSpacing: 0,
            height: 19.36 / 14,
            color: Color(0xffAFAFAF),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: const Color(0xffFCFAFF),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            _selectDate(context, controller);
            setState(() {
              // _validateDob="";
            });
          },
          child: AbsorbPointer(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Select date from date picker",
                  suffixIcon: Container(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Image.asset(
                        "assets/calendar.png",
                        color: Color(0xff000000),
                        width: 16,
                        height: 16,
                        fit: BoxFit.contain,
                      )),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    letterSpacing: 0,
                    height: 1.2,
                    color: Color(0xffAFAFAF),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: Color(0xffFCFAFF),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/nodata2.png',
            height: 150,
            width: 150,
          ), // Add your placeholder image
          SizedBox(height: 16),
          Text(
            'No projects found.',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xff9E7BCA),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

