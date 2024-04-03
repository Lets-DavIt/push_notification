import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:push_notification/routes/routes.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // Fazer configuração para IOS e etc.

    await localNotificationsPlugin.initialize(
      const InitializationSettings(android: android),
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null &&
        notificationResponse.payload!.isNotEmpty) {
      await Navigator.of(Routes.navigatorKey!.currentContext!)
          .pushReplacementNamed(notificationResponse.payload!);
    }
  }

  showNotification(CustomNotification notification) async {
    androidDetails = const AndroidNotificationDetails(
      'lembretes_notifications_x',
      'lembretes',
      channelDescription: 'Este canal é para lembretes!',
      importance: Importance.max,
      priority: Priority.max,
    );

    await localNotificationsPlugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      NotificationDetails(
        android: androidDetails,
      ),
      payload: notification.payload,
      // androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  checkForNotifications() async {
    final NotificationAppLaunchDetails? details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null &&
        details.didNotificationLaunchApp &&
        details.notificationResponse != null) {
      onDidReceiveNotificationResponse(details.notificationResponse!);
    }
  }
}
