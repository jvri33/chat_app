import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import 'settings_page.dart';
import 'chat_reminders.dart';
import '../controllers/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    NotiticationService().initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SettingsPage());
              },
              icon: const Icon(Icons.settings))
        ],
        centerTitle: true,
        title: const Text("ChatHub"),
      ),
      body: ElevatedButton(
        onPressed: () {
          nextScreen(context, const Chat());

          /* NotiticationService().scheduleNotification(
              title: "Prueba de notificación",
              body: "Aquí iría el título",
              scheduledNotificationDateTime:
                  DateTime.now().add(const Duration(seconds: 40)));
*/
        },
        child: const Text("Botón"),
      ),
    );
  }
}
