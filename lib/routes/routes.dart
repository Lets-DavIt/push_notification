import 'package:flutter/material.dart';
import 'package:push_notification/pages/home_page.dart';
import 'package:push_notification/pages/notificacao_page.dart';

class Routes {
  final String home = '/home';

  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/home': (_) {
      return const HomePage();
    },
    '/notificacao': (_) {
      return const NotificacaoPage();
    }
  };

  static String initial = '/home';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
