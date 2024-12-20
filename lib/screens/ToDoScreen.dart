import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skill/Model/ProjectLabelColorModel.dart';
import 'package:skill/Providers/ThemeProvider.dart';
import 'package:skill/screens/AddToDo.dart';
import 'package:skill/utils/CustomSnackBar.dart';
import '../Model/ProjectLabelModel.dart';
import '../Model/ToDoListModel.dart';
import '../Model/UserDetailsModel.dart';
import '../Providers/ConnectivityProviders.dart';
import '../Providers/TODOProvider.dart';
import '../Services/UserApi.dart';
import '../Services/otherservices.dart';
import '../utils/CustomAppBar.dart';
import '../utils/Mywidgets.dart';
import '../utils/ShakeWidget.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  TextEditingController _labelnameController = TextEditingController();
  TextEditingController _labelcolorController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  FocusNode _focusNodeLabelName = FocusNode();
  ScrollController _scrollController = ScrollController();
  String _validateLabelName = "";
  String _validateLabelColor = "";
  String labelid = "";
  String labelColorid = "";
  bool isChecked = false;

  bool _isLoading = true;
  final spinkit = Spinkits();
  String formattedDate = "";

  bool _loading = false;
  final spinkits = Spinkits();

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProviders>(context, listen: false).initConnectivity();
    formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    _generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
    GetTODOList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Provider.of<ConnectivityProviders>(context,listen: false).dispose();
    super.dispose();
  }

  Future<void> GetTODOList() async {
    final todoProvider = Provider.of<TODOProvider>(context, listen: false);
    todoProvider.fetchTODOList(formattedDate);
    todoProvider.GetLabel();
    todoProvider.GetLabelColor();
  }

  String? selectedValue;
  final List<String> items = [
    'Priority 1',
    'Priority 2',
    'Priority 3',
    'Priority 4',
  ];

  bool isLabelDropdownOpen = false;
  String? selectedLabelvalue;
  String? selectedLabelID;
  TextEditingController _searchController = TextEditingController();

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text =
            DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
        formattedDate =
            DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
      });
    }
  }

  Future<void> reorderTodos(Map<String, int> todosOrder) async {
    var res = await Userapi.ReorderTodos(todosOrder);
    setState(() {
      if (res != null) {
      } else {}
    });
  }



  Color hexToColor(String? hexColor) {
    // Return a default grey color if hexColor is null or empty
    if (hexColor == null || hexColor.isEmpty) {
      return Color(0xFF808080); // Hex for grey with full opacity
    }

    // Ensure the color starts with '#' for correct format
    if (!hexColor.startsWith('#')) {
      hexColor = '#$hexColor'; // Add '#' if it's missing
    }

    if (hexColor.length == 7 || hexColor.length == 9) {
      final buffer = StringBuffer();
      buffer.write('FF'); // Add alpha if it's missing (default to full opacity)
      buffer.write(hexColor.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } else {
      // Return default grey if the format is invalid
      return Color(0xFF808080); // Hex for grey with full opacity
    }
  }

  final List<String> daysOfWeek = ['Mo', 'Tu', 'Wed', 'Th', 'Fr', 'Sa', 'Su'];

  List<DateTime> dates = [];
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();

  void _scrollToSelectedDate() {
    final index = dates.indexWhere((date) =>
        date.day == selectedDate.day &&
        date.month == selectedDate.month &&
        date.year == selectedDate.year);

    if (index != -1) {
      final double offset =
          index * 55.0; // Adjust the 55.0 based on the item width
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _generateDates() {
    final startOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final endOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    setState(() {
      dates = List.generate(
        endOfMonth.day,
        (index) => DateTime(currentMonth.year, currentMonth.month, index + 1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final todoProvider = Provider.of<TODOProvider>(context);
    var connectiVityStatus =Provider.of<ConnectivityProviders>(context);
    return
      (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
          connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
          ? WillPopScope(
      onWillPop: () async {
        // Perform any logic before popping the screen
        Navigator.pop(
            context, true); // This will pop the screen and pass 'true' back.
        return Future.value(
            false); // Returning false prevents the default back navigation behavior
      },
      child: Scaffold(
        backgroundColor: themeProvider.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'Todo',
          actions: [
            // Container()
            SizedBox(
              height: w * 0.09,
              child: InkWell(
                onTap: () {
                  todoProvider.GetLabelColor();
                  _showAddLabel(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffffffff), width: 1),
                        // color: Color(0xff8856F4),
                        borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/circleadd.png",
                          fit: BoxFit.contain,
                          width: w * 0.045,
                          height: w * 0.05,
                          color: Color(0xffffffff),
                        ),
                        SizedBox(width: w * 0.01),
                        Text(
                          "Add Label",
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            fontFamily: "Inter",
                            height: 16.94 / 12,
                            letterSpacing: 0.59,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: w * 0.5,
                      height: h * 0.043,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/search.png",
                              width: 20,
                              height: 17,
                              fit: BoxFit.contain,
                              color: themeProvider.primaryColor,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  todoProvider
                                      .filterTasks(_searchController.text);
                                },
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  hintText: 'Search',
                                  hintStyle:  TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: themeProvider.primaryColor
                                        ,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    fontFamily: "Nunito",
                                  ),
                                ),
                                style: TextStyle(
                                  color: themeProvider.primaryColor
                                      ,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  fontFamily: "Nunito",
                                ),
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      height: w * 0.09,
                      child: InkWell(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddToDo()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: themeProvider.primaryColor,
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/circleadd.png",
                                fit: BoxFit.contain,
                                width: w * 0.045,
                                height: w * 0.05,
                                color: Color(0xffffffff),
                              ),
                              SizedBox(width: w * 0.01),
                              Text(
                                "Add To Do",
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  fontFamily: "Inter",
                                  height: 16.94 / 12,
                                  letterSpacing: 0.59,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        _bottomSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Image.asset(
                          "assets/filter.png",
                          width: 22,
                          height: 22,
                          color: themeProvider.primaryColor,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: w,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: themeProvider.containerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Consumer<TODOProvider>(
                    builder: (context, todoProvider, child) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Today",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: themeProvider.primaryColor,
                                        height: 19.36 / 16,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MMMM d, y')
                                          .format(currentMonth),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: themeProvider.textColor,
                                        fontFamily: "Inter",
                                        height: 19.36 / 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(dates.length, (index) {
                                final isSelected = dates[index].day ==
                                        selectedDate.day &&
                                    dates[index].month == selectedDate.month &&
                                    dates[index].year == selectedDate.year;
                                return Consumer<TODOProvider>(
                                  builder: (context, todoProvider, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedDate = dates[index];
                                          formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(selectedDate);
                                          print("selectedDate: $formattedDate");
                                          todoProvider
                                              .fetchTODOList(formattedDate);
                                        });
                                        _scrollToSelectedDate();
                                      },
                                      child: ClipRect(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          width: 55,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? themeProvider.primaryColor
                                                .withOpacity(
                                                0.08)
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                dates[index].day.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: isSelected
                                                      ? themeProvider.primaryColor
                                                      : themeProvider.textColor,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                daysOfWeek[
                                                    dates[index].weekday - 1],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff94A3B8),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ),
                          todoProvider.isLoading
                              ? _buildShimmerList()
                              : (todoProvider.filteredData.length > 0)
                                  ? SizedBox(
                                      height: h * 0.65,
                                      child: ReorderableListView(
                                        onReorder: (oldIndex, newIndex) async {
                                          // Adjust the newIndex if it's greater than the oldIndex to ensure correct reordering
                                          if (newIndex > oldIndex) {
                                            newIndex -= 1;
                                          }
                                          // Move the item in the list to its new position
                                          final tododata = todoProvider
                                              .filteredData
                                              .removeAt(oldIndex);
                                          todoProvider.filteredData
                                              .insert(newIndex, tododata);

                                          Map<String, int> todosOrder = {};
                                          for (int i = 0;
                                              i <
                                                  todoProvider
                                                      .filteredData.length;
                                              i++) {
                                            todosOrder[todoProvider
                                                    .filteredData[i].id ??
                                                ""] = i + 1;
                                          }
                                          // Now, send the update to the API
                                          await reorderTodos(todosOrder);

                                          setState(() {
                                            // The list is now reordered and the state is updated
                                          });
                                        },
                                        children: List.generate(
                                            todoProvider.filteredData.length,
                                            (index) {
                                          var tododata =
                                              todoProvider.filteredData[index];
                                          return Column(
                                            key: ValueKey(tododata.id ??
                                                index), // Ensure each item has a unique key for efficient reordering
                                            children: [
                                              ReorderableDragStartListener(
                                                index: index,
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 18.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.asset(
                                                        "assets/More-vertical.png",
                                                        fit: BoxFit.contain,
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          var res = await todoProvider
                                                              .deleteToDoList(
                                                                  tododata.id
                                                                      .toString());
                                                          if (res == 1) {
                                                            CustomSnackBar.show(
                                                                context,
                                                                "TODO Done successfully!");
                                                          } else {
                                                            CustomSnackBar.show(
                                                                context,
                                                                "TODO Done Failed!");
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              left: 8,
                                                              right:
                                                                  8), // Increase padding for larger tap area
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color: tododata
                                                                            .labelColor !=
                                                                        null
                                                                    ? hexToColor(
                                                                        tododata.labelColor ??
                                                                            "")
                                                                    : Colors
                                                                        .grey, // Border color
                                                                width: 3,
                                                              ),
                                                            ),
                                                            child: isChecked
                                                                ? Icon(
                                                                    Icons.check,
                                                                    size: 10,
                                                                    color: Colors
                                                                        .white, // Color of the check icon
                                                                  )
                                                                : null, // Use null instead of SizedBox.shrink() when unchecked
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              tododata.taskName ??
                                                                  "",
                                                              style:
                                                                   TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15,
                                                                color: themeProvider.themeData == lightTheme
                                                                    ?  Color(
                                                                    0xff141516)
                                                                    :themeProvider.textColor ,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            if (tododata
                                                                    .description !=
                                                                "")...[
                                                              Text(
                                                                tododata.description ??
                                                                    "",
                                                                style:
                                                                const TextStyle(
                                                                  fontFamily:
                                                                  'Inter',
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  fontSize: 15,
                                                                  color: Color(
                                                                      0xff4a4a4a),
                                                                  height:
                                                                  12.89 /
                                                                      11,
                                                                ),
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                              ),

                                                              const SizedBox(
                                                                  height: 5),
                                                            ],

                                                            if (tododata
                                                                    .labelName !=
                                                                null) ...[
                                                              Row(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/label.png",
                                                                    width: 18,
                                                                    height: 18,
                                                                    color: hexToColor(
                                                                        tododata.labelColor ??
                                                                            ""),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 8),
                                                                  Text(
                                                                    tododata.labelName ??
                                                                        "",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      height:
                                                                          13.31 /
                                                                              11,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                            const SizedBox(
                                                                height: 8),
                                                            Row(
                                                              children: [
                                                                Image.asset(
                                                                    "assets/calendar.png",
                                                                    width: 18,
                                                                    height: 18),
                                                                SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  tododata.dateTime ??
                                                                      "",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        0xff2FB035),
                                                                    height:
                                                                        13.31 /
                                                                            11,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              if (index <
                                                  todoProvider
                                                          .filteredData.length -
                                                      1)
                                                Divider(
                                                  thickness: 1,
                                                  color: Color(0xffE1E1E1),
                                                  height: 1,
                                                ),
                                            ],
                                          );
                                        }),
                                      ),
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 100,
                                          ),
                                          Image.asset(
                                            'assets/nodata1.png', // Path to your no data image
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            "No Data Found",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: "Inter",
                                            ),
                                          ),
                                          SizedBox(
                                            height: h * 0.3,
                                          )
                                        ],
                                      ),
                                    )
                        ],
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    ) :NoInternetWidget();
  }

  Widget _label({
    required String text,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Text(text,
            style: TextStyle(
                color: themeProvider.textColor,
                fontFamily: 'Inter',
                fontSize: 14,
                height: 16.36 / 14,
                fontWeight: FontWeight.w400));
      },
    );
  }

  void _showAddLabel(BuildContext context) {
    final todoProvider = Provider.of<TODOProvider>(context);
    double h = MediaQuery.of(context).size.height * 0.45;
    double w = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    height: h,
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      color: themeProvider.containerColor,
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
                              "Add Label",
                              style: TextStyle(
                                color: themeProvider.textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                height: 18 / 16,
                              ),
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
                                    color: themeProvider.primaryColor,
                                  ),
                                ),
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
                                _label(text: 'Label Name'),
                                SizedBox(height: 6),
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.050,
                                  child: TextFormField(
                                    controller: _labelnameController,
                                    focusNode: _focusNodeLabelName,
                                    keyboardType: TextInputType.text,
                                    cursorColor: themeProvider.primaryColor,
                                    decoration: InputDecoration(
                                      hintText: "Enter Label Name",
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        height: 19.36 / 14,
                                        color: Color(0xffAFAFAF),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      filled: true,
                                      fillColor: themeProvider.fillColor,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: const BorderSide(
                                            width: 1, color: Color(0xffd0cbdb)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: const BorderSide(
                                            width: 1, color: Color(0xffd0cbdb)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: const BorderSide(
                                            width: 1, color: Color(0xffd0cbdb)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: const BorderSide(
                                            width: 1, color: Color(0xffd0cbdb)),
                                      ),
                                    ),
                                  ),
                                ),
                                if (_validateLabelName.isNotEmpty) ...[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(
                                        left: 8, bottom: 10, top: 5),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: ShakeWidget(
                                      key: Key("value"),
                                      duration: Duration(milliseconds: 700),
                                      child: Text(
                                        'Please enter label name',
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  SizedBox(height: 15),
                                ],
                                _label(text: 'Color'),
                                SizedBox(height: 4),
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.050,
                                  child: TypeAheadField<LabelColor>(
                                    builder: (context, controller, focusNode) {
                                      return TextField(
                                        focusNode: focusNode,
                                        controller: _labelcolorController,
                                        onTap: () {
                                          setState(() {
                                            _validateLabelColor = "";
                                          });
                                        },
                                        onChanged: (v) {
                                          setState(() {
                                            _validateLabelColor = "";
                                          });
                                        },
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          height: 1.2,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Select Label",
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 0,
                                            height: 1.2,
                                            color: Color(0xffAFAFAF),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          filled: true,
                                          fillColor: themeProvider.fillColor,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Color(0xffD0CBDB)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Color(0xffD0CBDB)),
                                          ),
                                        ),
                                      );
                                    },
                                    suggestionsCallback: (pattern) {
                                      return todoProvider.labelcolor
                                          .where((item) => item.colorName!
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()))
                                          .toList();
                                    },
                                    decorationBuilder: (context, child) =>
                                        Material(
                                      type: MaterialType.card,
                                      elevation: 4,
                                      color: themeProvider.containerColor,
                                      child: child,
                                    ),
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  int.parse(suggestion
                                                      .colorCode!
                                                      .replaceFirst(
                                                          '#', '0xFF')),
                                                  // This replaces '#' with '0xFF' to make it a valid color value
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              (suggestion.colorName!),
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onSelected: (suggestion) {
                                      setState(() {
                                        _labelcolorController.text =
                                            suggestion.colorName!;
                                        labelColorid = suggestion.colorCode!;
                                        print("labelColorid:${labelColorid}");
                                        _validateLabelColor = "";
                                      });
                                    },
                                  ),
                                ),
                                if (_validateLabelColor.isNotEmpty) ...[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: ShakeWidget(
                                      key: Key("value"),
                                      duration: Duration(milliseconds: 700),
                                      child: Text(
                                        _validateLabelColor,
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                width: w * 0.43,
                                decoration: BoxDecoration(
                                  color: themeProvider.containerColor,
                                  border: Border.all(
                                    color: themeProvider.primaryColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: Text(
                                    'Close',
                                    style: TextStyle(
                                      color: themeProvider.primaryColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            InkResponse(
                              onTap: () {
                                setState(() {
                                  _validateLabelName =
                                      _labelnameController.text.isEmpty
                                          ? "Please enter Label Name"
                                          : "";
                                  _validateLabelColor =
                                      _labelcolorController.text.isEmpty
                                          ? "Please Select a Label Color"
                                          : "";

                                  _isLoading = _validateLabelName.isEmpty &&
                                      _validateLabelColor.isEmpty;

                                  if (_isLoading) {
                                    // PostToDoAddLabel();
                                  }
                                });
                              },
                              child: Container(
                                height: 40,
                                width: w * 0.43,
                                decoration: BoxDecoration(
                                  color: themeProvider.primaryColor,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? spinkit.getFadingCircleSpinner()
                                      : Text(
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          );
        }).whenComplete(() {
      _labelnameController.text = "";
      _labelcolorController.text = "";

      _validateLabelColor = "";
      _validateLabelName = "";
    });
  }

  void _bottomSheet(
    BuildContext context,
  ) {
    double h = MediaQuery.of(context).size.height * 0.6;
    double w = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Consumer<TODOProvider>(
            builder: (context, todoProvider, child) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                      return Container(
                          height: h,
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 20),
                          decoration: BoxDecoration(
                            color: themeProvider.containerColor,
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
                                    'Filters',
                                    style: TextStyle(
                                      color: themeProvider.textColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      height: 18 / 16,
                                    ),
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/crossblue.png",
                                          fit: BoxFit.contain,
                                          width: w * 0.023,
                                          height: w * 0.023,
                                          color: themeProvider.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _label(text: 'Priority'),
                                      SizedBox(height: 4),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: const Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Select Priority',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Inter",
                                                    color: Color(0xffAFAFAF),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: items.map((String item) {
                                            // Define a map of priority to color for the flag icon
                                            final Map<String, Color>
                                                priorityColors = {
                                              'Priority 1': Colors
                                                  .red, // Red for Priority 1
                                              'Priority 2': Colors
                                                  .orange, // Orange for Priority 2
                                              'Priority 3': Colors
                                                  .green, // Green for Priority 3
                                              'Priority 4': Colors
                                                  .blue, // Blue for Priority 4
                                            };

                                            // Get the color for the current item
                                            Color iconColor = priorityColors[
                                                    item] ??
                                                Colors
                                                    .black; // Default to black if not found

                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.flag_outlined,
                                                    color:
                                                        iconColor, // Set the color of the flag icon based on the priority
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    item,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: themeProvider
                                                          .textColor,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          value: selectedValue,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedValue = value;
                                              print(selectedValue);
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 45,
                                            width: double.infinity,
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              border: Border.all(
                                                color: Color(0xffD0CBDB),
                                              ),
                                              color:
                                                  themeProvider.containerColor,
                                            ),
                                          ),
                                          iconStyleData: IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              size: 25,
                                              color: themeProvider.textColor,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.black,
                                            iconDisabledColor: Colors.black,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color:
                                                  themeProvider.containerColor,
                                            ),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness:
                                                  MaterialStateProperty.all(6),
                                              thumbVisibility:
                                                  MaterialStateProperty.all(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      _label(text: 'Label'),
                                      SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isLabelDropdownOpen =
                                                !isLabelDropdownOpen;
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              border: Border.all(
                                                  color: Color(0xffD0CBDB)),
                                              color:
                                                  themeProvider.containerColor),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(selectedLabelvalue ??
                                                  "Select Label"),
                                              Icon(isLabelDropdownOpen
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (isLabelDropdownOpen) ...[
                                        SizedBox(height: 5),
                                        Card(
                                          color: themeProvider.containerColor,
                                          elevation:
                                              2, // Optional elevation for shadow effect
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8), // Optional rounded corners
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                8.0), // Padding inside the card
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start, // Align items to the start
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: themeProvider
                                                          .containerColor),
                                                  height: 40,
                                                  child: TextFormField(
                                                    onChanged: (query) =>
                                                        todoProvider
                                                            .filterLabels(
                                                                query),
                                                    decoration: InputDecoration(
                                                      hintText: "Search Label",
                                                      hintStyle: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: "Inter"),
                                                      filled: true,
                                                      fillColor: themeProvider
                                                          .fillColor,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: themeProvider
                                                                      .themeData ==
                                                                  lightTheme
                                                              ? Color(
                                                                  0xffD0CBDB)
                                                              : Color(
                                                                  0xffffffff),
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.0),
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: themeProvider
                                                                      .themeData ==
                                                                  lightTheme
                                                              ? Color(
                                                                  0xffD0CBDB)
                                                              : Color(
                                                                  0xffffffff),
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.all(8.0),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        10), // Space between TextField and ListView
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: themeProvider
                                                            .containerColor),
                                                    height:
                                                        140, // Set a fixed height for the dropdown list
                                                    child: todoProvider
                                                                .filteredLabels
                                                                .length >
                                                            0
                                                        ? ListView.builder(
                                                            itemCount: todoProvider
                                                                .filteredLabels
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              var data =
                                                                  todoProvider
                                                                          .filteredLabels[
                                                                      index];
                                                              return ListTile(
                                                                minTileHeight:
                                                                    30,
                                                                title: Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/label.png",
                                                                      width: 18,
                                                                      height:
                                                                          18,
                                                                      color: hexToColor(
                                                                          data.color ??
                                                                              ""),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Text(
                                                                      data.name ??
                                                                          "",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Inter",
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    isLabelDropdownOpen =
                                                                        false;
                                                                    selectedLabelvalue =
                                                                        data.name;
                                                                    selectedLabelID =
                                                                        data.id;
                                                                  });
                                                                },
                                                              );
                                                            },
                                                          )
                                                        : Center(
                                                            child: Text(
                                                            "No Data found!",
                                                            style: TextStyle(
                                                                color: themeProvider
                                                                    .textColor),
                                                          ))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 6),
                                      _label(text: 'Date'),
                                      SizedBox(height: 4),
                                      _buildDateField(context, _dateController),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: themeProvider.containerColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkResponse(
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          selectedLabelvalue = "";
                                          selectedLabelID = "";
                                          _dateController.text = "";
                                          todoProvider.filteredData ?? [];
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: w * 0.35,
                                        decoration: BoxDecoration(
                                          color: themeProvider.containerColor,
                                          border: Border.all(
                                            color: themeProvider.primaryColor,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                              color: themeProvider.primaryColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    InkResponse(
                                      onTap: () {
                                        setState(() {
                                          todoProvider.filteredData ?? [];
                                        });
                                        Navigator.pop(context);
                                        todoProvider
                                            .fetchTODOList(formattedDate);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: w * 0.35,
                                        decoration: BoxDecoration(
                                          color: themeProvider.primaryColor,
                                          border: Border.all(
                                            color:themeProvider.primaryColor,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        child: Center(
                                          child: _loading
                                              ? spinkits
                                                  .getFadingCircleSpinner()
                                              : Text(
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    }));
              });
            },
          );
        });
  }

  Widget _buildDateField(
      BuildContext context, TextEditingController controller) {
    return Consumer<ThemeProvider>(builder: (
      context,
      themeProvider,
      child,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child: TextField(
              controller: controller,
              readOnly: true,
              onTap: () {
                _selectDate(context, controller);
              },
              decoration: InputDecoration(
                hintText: "Select Date",
                suffixIcon: Container(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: Image.asset(
                      "assets/calendar.png",
                      color: themeProvider.textColor,
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
                fillColor: themeProvider.containerColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(width: 1, color: Color(0xffD0CBDB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.0),
                  borderSide: BorderSide(width: 1, color: Color(0xffD0CBDB)),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

Widget _buildShimmerList() {
  return ListView.builder(
    itemCount: 10, // Adjust the number of shimmer items as needed
    shrinkWrap: true,
    physics: const AlwaysScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerRectangle(20, context), // Shimmer for the icon
            const SizedBox(width: 8),
            shimmerCircle(20, context),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerText(150, 13, context), // Shimmer for task name
                  const SizedBox(height: 5),
                  shimmerText(200, 11, context), // Shimmer for description
                  const SizedBox(height: 5),
                  shimmerText(120, 11, context), // Shimmer for date/time
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
