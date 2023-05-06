import 'package:chat_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color.fromARGB(255, 0, 115, 99),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Color.fromARGB(255, 228, 253, 240), // Your accent color
          ),
          //colorScheme: ColorScheme(primary: Color.fromARGB(255, 0, 115, 99), background: Colors.white),
          appBarTheme: AppBarTheme(
              backgroundColor: Color.fromARGB(255, 228, 253, 240),
              foregroundColor: Color.fromARGB(255, 0, 115, 99))),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
