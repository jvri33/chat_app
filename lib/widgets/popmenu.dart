import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class PopMenu extends StatelessWidget {
  const PopMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        // add icon, by default "3 dot" icon
        // icon: Icon(Icons.book)
        itemBuilder: (context) {
      return [
        PopupMenuItem<int>(
          value: 0,
          child: Icon(Icons.calendar_month),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Icon(Icons.add),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Icon(Icons.help),
        ),
      ];
    }, onSelected: (value) {
      if (value == 0) {
        print("My account menu is selected.");
      } else if (value == 1) {
        print("Settings menu is selected.");
      } else if (value == 2) {
        print("Logout menu is selected.");
      }
    });
  }
}
