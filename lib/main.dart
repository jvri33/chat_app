import 'package:chat_app/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getBool('night') != null) {
    night = prefs.getBool('night')!;
  } else {
    night = false;
  }
  tz.initializeTimeZones();
  runApp(const MyApp());
}

bool night = false;

ThemeData _dark = ThemeData(
    primaryColor: const Color.fromARGB(255, 82, 220, 186),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color.fromARGB(255, 56, 75, 78),
      tertiary: const Color.fromARGB(255, 56, 75, 78), // Your accent color
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 56, 75, 78),
        foregroundColor: Color.fromARGB(255, 82, 220, 186)));

ThemeData _light = ThemeData(
    primaryColor: const Color.fromARGB(255, 0, 115, 99),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color.fromARGB(255, 187, 247, 223),
      tertiary: const Color.fromARGB(255, 255, 255, 255), // Your accent color
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 187, 247, 223),
        foregroundColor: Color.fromARGB(255, 0, 115, 99)));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  seteNight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (night == false) {
      night = true;
      prefs.setBool('night', true);
    } else {
      night = false;
      prefs.setBool('night', false);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      theme: night ? _dark : _light,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(seteNight, night),
    );
  }
}
