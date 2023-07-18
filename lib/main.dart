import 'package:chat_app/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart' show rootBundle;
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
import 'dart:convert';

dynamic js = {};

Future<dynamic> loadConfig() async {
  final contents = await rootBundle.loadString(
    'assets/config.json',
  );

// decode our json
  final json = jsonDecode(contents);
  return json;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  js = await loadConfig();

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
          primaryColor: js['night'] == false
              ? const Color.fromARGB(255, 0, 115, 99)
              : const Color.fromARGB(255, 82, 220, 186),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: js['night'] == false
                ? const Color.fromARGB(255, 187, 247, 223)
                : const Color.fromARGB(255, 56, 75, 78),
            tertiary: js['night'] == false
                ? const Color.fromARGB(255, 255, 255, 255)
                : const Color.fromARGB(255, 56, 75, 78), // Your accent color
          ),
          appBarTheme: AppBarTheme(
              backgroundColor: js['night'] == false
                  ? const Color.fromARGB(255, 187, 247, 223)
                  : const Color.fromARGB(255, 56, 75, 78),
              foregroundColor: js['night'] == false
                  ? const Color.fromARGB(255, 0, 115, 99)
                  : const Color.fromARGB(255, 82, 220, 186))),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(js['night']),
    );
  }
}
