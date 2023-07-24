import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as img;

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenImage(context, page, img.Image i) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
