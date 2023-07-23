import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenImage(context, page, img.Image i) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
