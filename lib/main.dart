import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Import your screens
import 'screens/profile.dart';
import 'screens/landing.dart';
import 'screens/history.dart';
import 'screens/login.dart';
import 'screens/firstaid_landing.dart';
import 'screens/signup.dart';
import 'screens/signup_details.dart';
import 'screens/homepage.dart';
import 'screens/firstaid.dart';
import 'screens/firstaid_slug.dart';
import 'screens/emergency.dart';
import 'services/firebase_options.dart';

// Initialize notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'channel_id', // ID
  'channel_name', // Name
  description: 'channel_description', // Description
  importance: Importance.high,
);

// Firebase Messaging instance
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Background message received: ${message.notification?.title}");
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      debugPrint('Notification tapped: ${response.payload}');
    },
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> configureFirebaseMessaging() async {
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint("User granted notification permissions");
  } else {
    debugPrint("User denied or has not granted notification permissions");
  }

  String? token = await _firebaseMessaging.getToken();
  debugPrint("FCM Token: $token");

  await _firebaseMessaging.subscribeToTopic("red_cross_youth");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint("Foreground message received: ${message.notification?.title}");
    showNotification(
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("Notification opened: ${message.data}");
    if (message.data.containsKey('route')) {
      navigatorKey.currentState?.pushNamed(message.data['route']);
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await initializeNotifications();
    await configureFirebaseMessaging();
    await requestNotificationPermission();
  } catch (e) {
    debugPrint("Error initializing app: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Health Emergency Alert',
      navigatorKey: navigatorKey, // Set the global navigator key here

      initialRoute: '/',
      routes: {
        '/landing': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/signup-details': (context) => const SignupDetailsPage(),
        '/home': (context) => const HomePage(),
        '/first-aid': (context) => const FirstAidScreen(),
        '/first-aid-landing': (context) => const FirstAidLandingScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/emergency': (context) => const EmergencyPage(),
        '/history': (context) => HistoryPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/first_aid_detail') {
          final arguments = settings.arguments as Map<String, dynamic>?;

          if (arguments != null &&
              arguments.containsKey('title') &&
              arguments.containsKey('videoUrl') &&
              arguments.containsKey('steps')) {
            return MaterialPageRoute(
              builder: (context) => FirstAidDetailPage(
                title: arguments['title'] as String,
                videoUrl: arguments['videoUrl'] as String,
                steps: arguments['steps'] as String,
              ),
            );
          }
        }
        return null;
      },
      home: const AuthChecker(),
    );
  }
}
class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while waiting for Firebase to initialize
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the user is logged in, redirect to the homepage
        if (snapshot.hasData) {
          return const HomePage();
        }

        // Otherwise, show the landing page (login/signup)
        return const LandingPage();
      },
    );
  }
}


Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    channelDescription: 'channel_description',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
    payload: 'Notification Payload',
  );
}
