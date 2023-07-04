import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PopMenu extends StatelessWidget {
  Function calendar;
  Function add;
  Function help;
  PopMenu(this.calendar, this.add, this.help, {super.key});

  @override
  Widget build(BuildContext context) {
    return (PopupMenuButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        color: Theme.of(context).colorScheme.secondary,
        icon: const Icon(Icons.more_vert),
        iconSize: 32,
        // add icon, by default "3 dot" icon
        // icon: Icon(Icons.book)
        itemBuilder: (context) {
          return [
            const PopupMenuItem<int>(
              value: 0,
              child: Icon(Icons.calendar_month),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: Icon(Icons.add),
            ),
            const PopupMenuItem<int>(
              value: 2,
              child: Icon(Icons.help),
            ),
          ];
        },
        onSelected: (value) {
          if (value == 0) {
            calendar();
          } else if (value == 1) {
            add();
          } else if (value == 2) {
            help();
          }
        }));
  }
}
