import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/services/notifications/notification_service.dart';

class FirebaseMessagingService {
  final NotificationService _notificationService;

  FirebaseMessagingService(this._notificationService);

  Future<void> initialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: false,
      alert: true,
    );

    checkPermissions();
    getDeviceFirebaseToken();
    _onMessage();
  }

  Future<void> checkPermissions() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.getNotificationSettings();

    debugPrint("settings: ${settings.authorizationStatus}");

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      requestPermissions();
    }
  }

  Future<void> requestPermissions() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    debugPrint("requestPermissions: ${settings.authorizationStatus}");
  }

  getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();

    debugPrint("============================");
    debugPrint("Token: $token");
    debugPrint("============================");
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen(
      (event) {
        RemoteNotification? notification = event.notification;
        AndroidNotification? android = event.notification?.android;

        if (notification != null && android != null) {
          _notificationService.showNotification(
            CustomNotification(
                id: android.hashCode,
                title: notification.title!,
                body: notification.body,
                payload: event.data["route"] ?? ''),
          );
          // flutterLocalNotificationsPlugin.show(
          //   notification.hashCode,
          //   notification.title,
          //   notification.body,
          //   NotificationDetails(
          //     android: AndroidNotificationDetails(
          //       channel.id,
          //       channel.name,
          //       channelDescription: channel.description,
          //       icon: 'launch_background',
          //     ),
          //   ),
          // );
        }
      },
    );
  }

  // _onMessageOpenedApp() {
  //   FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
  // }

  // _goToPageAfterMessage(message) {
  //   final String route = message.data['route'] ?? '';
  //   if (route.isNotEmpty) {
  //     Routes.navigatorKey?.currentState?.pushNamed(route);
  //   }
  // }
}
