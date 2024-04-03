import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:push_notification/app.dart';
import 'package:push_notification/services/firebase_messaging_service.dart';
import 'package:push_notification/services/notifications/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationService>(
          create: (context) => NotificationService(),
        ),
        Provider<FirebaseMessagingService>(
          create: (context) =>
              FirebaseMessagingService(context.read<NotificationService>()),
        ),
      ],
      child: const App(),
    ),
  );
}
