import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sea_a/main.dart';

class FloatingBanner {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 10),
    String soundAsset = 'sounds/notification.wav',
    String notificationTitle = "Notification",
  }) {
    final overlay = Overlay.of(context);

    // Play the sound
    _playSound(soundAsset);

    // Show device notification
    _showDeviceNotification(notificationTitle, message);

    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB71C1C), Color(0xFFEF5350)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notificationTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => overlayEntry.remove(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  static Future<void> _playSound(String soundAsset) async {
    try {
      await _audioPlayer.play(AssetSource(soundAsset));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  static Future<void> _showDeviceNotification(
      String title, String message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'floating_banner_channel',
      'Floating Banner Notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      notificationDetails,
    );
  }
}
