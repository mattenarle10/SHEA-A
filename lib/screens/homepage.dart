import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sea_a/main.dart';
import 'package:sea_a/widgets/bottom_navbar.dart';
import 'package:sea_a/widgets/map_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sea_a/widgets/floating_banner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String firstName = '';
  String _userRole = '';
  late final StreamSubscription<QuerySnapshot> _alertSubscription;
  late final StreamSubscription<QuerySnapshot> _nurseAlertSubscription;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _initializeRoleAndAlertsListener();
  }

  Future<void> _initializeRoleAndAlertsListener() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (mounted) {
          setState(() {
            _userRole = userDoc.data()?['role'] ?? 'Unknown'; // Get the user's role
          });
        }

        // Setup listeners for different roles
        _setupAlertsListener();
        if (_userRole == 'Nurse') {
          _setupNurseAlertsListener(); // Initialize nurse-specific alerts
        }
      }
    } catch (e) {
      debugPrint('Error initializing alerts listener: $e');
    }
  }

  void _setupAlertsListener() {
    final alertsStream = FirebaseFirestore.instance
        .collection('alerts')
        .where('status', isEqualTo: 'Pending') // Only pending alerts
        .snapshots();

    _alertSubscription = alertsStream.listen(
      (snapshot) {
        for (final doc in snapshot.docs) {
          final alert = doc.data();

          // Allow the banner to show only alerts relevant to the role
          if ((_userRole == 'Red Cross Youth' && alert['role'] == 'Red Cross Youth') ||
              (_userRole == 'Red Cross Youth' && alert['role'] == 'Student')) {
            final message = '''
            ${alert['user_name']} reported:
            ${alert['patient_status']} at ${alert['building_room']}
            ''';

            if (mounted) {
              FloatingBanner.show(
                context,
                message: message,
                soundAsset: 'sounds/notification.wav', // Updated path
                notificationTitle: 'Emergency Alert', // Notification title
              );
            }
          }
        }
      },
      onError: (error) {
        debugPrint('Error receiving alert updates: $error');
      },
    );
  }

void _setupNurseAlertsListener() {
  final nurseAlertsStream = FirebaseFirestore.instance
      .collection('alerts')
      .where('status', isEqualTo: 'Forwarded to Nurse') // Only alerts forwarded to nurse
      .snapshots();

  _nurseAlertSubscription = nurseAlertsStream.listen(
    (snapshot) async {
      for (final doc in snapshot.docs) {
        final alert = doc.data();

        // Prepare the message for the notification
        final message = '''
        ${alert['user_name']} reported:
        ${alert['patient_status']} at ${alert['building_room']}
        ''';

        if (_userRole == 'Nurse') {
          // Show banner when the app is open
          FloatingBanner.show(
            context,
            message: message,
            soundAsset: 'sounds/notification.wav', // Updated path
            notificationTitle: 'Nurse Alert', // Notification title
          );

          // Trigger local notification
          await _showLocalNotification(message);
        }
      }
    },
    onError: (error) {
      debugPrint('Error receiving nurse alert updates: $error');
    },
  );
}


// Function to trigger the local notification
Future<void> _showLocalNotification(String message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'nurse_alert_channel', // Channel ID
    'Nurse Alerts', // Channel name
    channelDescription: 'Channel for nurse-specific alerts',
    importance: Importance.high,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('notification'),
    playSound: true,
    ticker: 'ticker',
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID (can be used to cancel the notification later)
    'Nurse Alert', // Notification title
    message, // Notification message
    platformChannelSpecifics,
  );
}

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists && mounted) {
          setState(() {
            firstName = userDoc['first_name'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _onNavBarTap(int index) {
    if (_selectedIndex == index) return; // Prevent redundant navigation to the same screen

    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the selected screen
    switch (index) {
      case 0:
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        break;
      case 1:
        Navigator.of(context).pushNamedAndRemoveUntil('/first-aid', (route) => false);
        break;
      case 2:
        Navigator.of(context).pushNamedAndRemoveUntil('/profile', (route) => false);
        break;
    }
  }

  void _handleCurrentLocation(LatLng? location) {
    setState(() {});
  }

  @override
  void dispose() {
    _alertSubscription.cancel(); // Cancel Firestore listener to avoid memory leaks
    _nurseAlertSubscription.cancel(); // Cancel nurse-specific listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'lib/img/logo_clear.png',
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.history,
                      color: Color.fromARGB(255, 168, 60, 60),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/history');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  firstName.isNotEmpty ? 'Welcome Back, $firstName!' : 'Welcome Back, User!',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MapWidget(
                  onCurrentLocation: _handleCurrentLocation,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Press the button in case of Emergency',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 86, 86, 86),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/emergency'); // Navigate to the emergency page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD10A0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              child: const Icon(
                Icons.warning,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16), // Avoid bottom overflow
          ],
        ),
      ),
    );
  }
}
