import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/ThemeProvider.dart';
import 'app_colors.dart';

const defaultPadding = 10.0;
const defaultMargin = 10.0;
const defaultHeight = 10.0;
const defaultWidth = 10.0;
const defaultButtonHeight = 50.0;
const defaultRadius = 10.0;
const connectionTimeOut = 60;
double LargeTextSize = 18;
double TextheaderSize = 16;
double TextlabelSize = 12;
double textSize = 12;
double subtextSize = 10;
double minisubtextSize = 8.0;
double XLargeTextSize = 24;

// // var PhonePeMerchantId="NUTSBYONLINE";//Production Key
var PhonePeMerchantId = ""; //PGTESTPAYUAT
// var PhonePeSaltKey="70508497-24ec-4372-bb9f-f7ea4b451f7d";//Production Key
var PhonePeSaltKey = ""; //099eb0cd-02cf-4e2a-8aca-3e6c6aff0399
var PhonePeSaltIndex = "1";
var AppId = "ddeca623b5d548a486c0fcd062479880";
//cce1254412334734990aa88f6a382b4a

// var PhonePeMerchantId="SVINDOONLINE";//production
// var PhonePeSaltKey="78a4f850-4cb2-467d-a5ca-fd8f04420518";//production
// var PhonePeSaltIndex="1";
// var AppId="in.webgrid.svindo";

double screenSpace = 10;

const fontFamilyName = "Ubuntu";
const dreamBikeFont = "nasalization";
const authorization = "Authorization";
const imageQuality = 50;
const dateFormat = "yy/MM/dd";
const timeFormat = "HH:mm:ss";
const sliderHeight = 180.0;
const rupeeSymbol = "₹";
const fav_icon = "assets/images/saveicon.svg";
const mapsApiKey = "AIzaSyCA06NWEP5D-z8WpebENgd4mSOqV-uXIUE";
const upiRegex = "[a-zA-Z0-9.-]{2,256}@[a-zA-Z][a-zA-Z]{2,64}";
const vehicleNumberRegex =
    "^[a-zA-Z]{2}[0-9]{1,2}(?:[a-zA-Z])?(?:[a-zA-Z]*)?[0-9]{4}";
const panNumberRegex = "[A-Z]{5}[0-9]{4}[A-Z]{1}";
const aadhaarRegex = "[0-9]{12}";
const staticImage = "https://picsum.photos/250?image=9";
String chat_socket_url = "wss://192.168.0.56:8000/ws/chat/";
String notify_socket_url = "wss://192.168.0.56:8000/ws/notify/";
const String host = "https://stage.skil.in";


String geminiApiKey = "AIzaSyCxSSwFx-2e7d8zrBOCdU23gs7pJv0poO4";


 const String NO_INTERNET = "No internet connection.";
 const String BAD_RESPONSE = "Received bad response from the server.";
 const String SOMETHING_WRONG = "Something went wrong. Please try again.";
 const String UNAUTHORIZED = "You are not authorized to access this resource.";

/////////Colors
var notification_val = 0;

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
  scaffoldBackgroundColor: Color(0xff17191C),
  dialogBackgroundColor: Colors.white,
  cardColor: Colors.white,
  searchBarTheme: const SearchBarThemeData(),
  tabBarTheme: const TabBarTheme(),
  dialogTheme: const DialogTheme(
    shadowColor: Colors.white,
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
          Radius.circular(5.0)), // Set the border radius of the dialog
    ),
  ),
  buttonTheme: const ButtonThemeData(),
  popupMenuTheme:
      const PopupMenuThemeData(color: Colors.white, shadowColor: Colors.white),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.white,
  ),
  cardTheme: const CardTheme(
    shadowColor: Colors.white,
    surfaceTintColor: Colors.white,
    color: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
      surfaceTintColor: Colors.white, backgroundColor: Colors.white),
  colorScheme: const ColorScheme.light(background: Colors.white)
      .copyWith(background: Colors.white),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
  scaffoldBackgroundColor: Color(0xff181818),
  dialogBackgroundColor: Colors.white,
  cardColor: Colors.white,
  searchBarTheme: const SearchBarThemeData(),
  tabBarTheme: const TabBarTheme(),
  dialogTheme: const DialogTheme(
    shadowColor: Colors.white,
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
          Radius.circular(5.0)), // Set the border radius of the dialog
    ),
  ),
  buttonTheme: const ButtonThemeData(),
  popupMenuTheme:
      const PopupMenuThemeData(color: Colors.white, shadowColor: Colors.white),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.white,
  ),
  cardTheme: const CardTheme(
    shadowColor: Colors.white,
    surfaceTintColor: Colors.white,
    color: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
      surfaceTintColor: Colors.white, backgroundColor: Colors.white),
);
