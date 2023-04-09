import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import 'settingsPage.dart';
import 'chat_reminders.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: Text("ChatHub"),
      ),
      body: ElevatedButton(
        onPressed: () {
          nextScreen(context, const Chat());
        },
        child: Text("Botón"),
      ),
    );
  }
}
