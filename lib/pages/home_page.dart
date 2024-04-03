import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_notification/services/notifications/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool value = false;

  showNotification() {
    setState(() {
      value = !value;

      if (value) {
        Provider.of<NotificationService>(context, listen: false)
            .showNotification(
          CustomNotification(
            id: 1,
            title: 'teste',
            body: 'Acesse o app!',
            payload: '/notificacao',
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 254, 174),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              child: ListTile(
                title: const Text("Lembrar-me mais tarde"),
                trailing: value
                    ? Icon(
                        Icons.check_box,
                        color: Colors.amber.shade600,
                      )
                    : const Icon(Icons.check_box_outline_blank),
                onTap: showNotification,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
