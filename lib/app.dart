import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_notification/routes/routes.dart';
import 'package:push_notification/services/firebase_messaging_service.dart';
import 'package:push_notification/services/notifications/notification_service.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    initilizeFirebaseMessaging();
    checkNotifications();
  }

  initilizeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false)
        .initialize();
  }

  checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false)
        .checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'push Notification Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      routes: Routes.list,
      initialRoute: Routes.initial,
      navigatorKey: Routes.navigatorKey,
    );
  }
}
