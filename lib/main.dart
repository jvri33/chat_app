import 'package:chat_app/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 0, 115, 99),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary:
                const Color.fromARGB(255, 187, 247, 223), // Your accent color
          ),
          //colorScheme: ColorScheme(primary: Color.fromARGB(255, 0, 115, 99), background: Colors.white),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 187, 247, 223),
              foregroundColor: Color.fromRGBO(0, 115, 99, 1))),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
