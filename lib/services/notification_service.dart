import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _plugin.initialize(initializationSettings);
    _initialized = true;
  }

  Future<void> requestPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  Future<void> showLowBatteryNotification(int level) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'battery_channel',
      'Battery Notifications',
      channelDescription: 'Notificaciones sobre estado de batería',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      '⚠️ Batería baja',
      'Tu batería está al $level%',
      notificationDetails,
      payload: 'battery_low',
    );
  }
}
