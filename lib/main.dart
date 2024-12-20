import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:skill/Providers/ConnectivityProviders.dart';
import 'package:skill/Providers/KanbanProvider.dart';
import 'package:skill/Providers/MileStoneProvider.dart';
import 'package:skill/Providers/MeetingProvider.dart';
import 'package:skill/Providers/ProjectCommentProviders.dart';
import 'package:skill/Providers/ProjectNotesProviders.dart';
import 'package:skill/Providers/TODOProvider.dart';
import 'package:skill/Providers/TaskListProvider.dart';
import 'package:skill/Providers/TaskProvider.dart';
import 'package:skill/Providers/TimeSheetProvider.dart';
import 'package:skill/screens/OneToOneChatPage.dart';
import 'package:skill/screens/Splash.dart';
import 'package:skill/utils/Preferances.dart';
import 'Helpers/DatabaseHelper.dart';
import 'Model/NotificationModel.dart';
import 'Providers/ProfileProvider.dart';
import 'Providers/ThemeProvider.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final AudioPlayer audioPlayer = AudioPlayer();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: "AIzaSyDHliXTMOa5PqZUEGiywjRCjABk8EL9yMI",
            appId: "1:710798644357:android:9c8595bf181be70423c5ec",
            messagingSenderId: "710798644357",
            projectId: "skil-f765f",
          ),
        )
      : await Firebase.initializeApp();

  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (Platform.isAndroid) {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      print("Androidfbstoken:{$token} ");
      PreferenceService().saveString("fbstoken", token!);
      // toast(BuildContext , token);
    });
  } else {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      print("IOSfbstoken:{$token}");
      PreferenceService().saveString("fbstoken", token!);
      // toast(BuildContext , token);
    });
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: false,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: false,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings());

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      _handleNotificationTap(notificationResponse.payload);
    },
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      print('A new message received title: ${notification.title}');
      print('A new message received body: ${notification.body}');
      print('RemoteMessage data: ${message.data.toString()}');

      // Save notification to SQLite database
      _saveNotificationToDatabase(notification, message.data);

      // Show a local notification (optional)
      showNotification(notification, android, message.data);
    }
  });

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    _handleNotificationTap(jsonEncode(message.data));
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // debugInvertOversizedImages = true;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  FlutterError.onError = (FlutterErrorDetails details) {
    // Log the error details to a logging service or print them
    print("Errrrrrrrrrr:${details.exceptionAsString()}");
    // Optionally report the error to a remote server
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(AppThemeMode.system)),
        ChangeNotifierProvider(create: (context) => ConnectivityProviders()),
        ChangeNotifierProvider(create: (context) => KanbanProvider()),
        ChangeNotifierProvider(create: (context) =>ProfileProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => TODOProvider()),
        ChangeNotifierProvider(create: (context) => MileStoneProvider()),
        ChangeNotifierProvider(create: (context) => MeetingProvider()),
        ChangeNotifierProvider(create: (context) => ProjectNoteProviders()),
        ChangeNotifierProvider(create: (context) => TasklistProvider()),
        ChangeNotifierProvider(create: (context) => TimesheetProvider()),
        ChangeNotifierProvider(create: (context) => ProjectCommentProviders()),

      ],
      child: MyApp(),
    ),
  );
}

Future<void> _handleNotificationTap(String? payload) async {
  final myEmployeeID = await PreferenceService().getString("my_employeeID");

  if (payload != null) {
    Map<String, dynamic> data = jsonDecode(payload);
    String? roomId = data['room_id'];
    print("roomId:${roomId}");
    if (roomId != null) {
      navigatorKey.currentState?.pushNamed(
        '/chat_screen',
        arguments: {
          'roomId': roomId,
          'employeeId': myEmployeeID,
        },
      );
    } else {
      print("No room_id found in the payload");
    }
  }
}

void _saveNotificationToDatabase(
    RemoteNotification notification, Map<String, dynamic> data) async {
  print("Sent Notification for saving:${notification}");
  // Create a Notification object to be saved in SQLite
  NotificationModel newNotification = NotificationModel(
    title: notification.title,
    body: notification.body,
  );

  // Save the notification to SQLite
  await DatabaseHelper.instance.insertNotification(newNotification);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    print('A new message received title: ${notification.title}');
    print('A new message received body: ${notification.body}');
    print('RemoteMessage data: ${message.data.toString()}');

    // Save notification to SQLite database
    _saveNotificationToDatabase(notification, message.data);
    _handleNotificationTap(jsonEncode(message.data));
  }
}

// Function to display local notifications
void showNotification(RemoteNotification notification,
    AndroidNotification android, Map<String, dynamic> data) async {
  await audioPlayer
      .play(AssetSource('sounds/bell_sound.mp3')); // Corrected line
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'skil_channel_id',
    'skil_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    playSound: false,
    icon: '@mipmap/skillicon',
  );
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformChannelSpecifics,
    payload: jsonEncode(data), // Convert payload data to String
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Skil',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: Splash(),
          navigatorKey: navigatorKey,
          onGenerateRoute: (settings) {
            if (settings.name == '/chat_screen') {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => ChatPage(
                    ID: args['employeeId'] ?? "", roomId: args['roomId'] ?? ""),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
