import 'package:chat_app/pages/home.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 0, 115, 99),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary:
                const Color.fromARGB(255, 228, 253, 240), // Your accent color
          ),
          //colorScheme: ColorScheme(primary: Color.fromARGB(255, 0, 115, 99), background: Colors.white),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 228, 253, 240),
              foregroundColor: Color.fromARGB(255, 0, 115, 99))),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
