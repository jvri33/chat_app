import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DateWidget extends StatefulWidget {
  final String date;
  const DateWidget({required this.date, super.key});

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Día: ${widget.date}",
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
      IconButton(
          constraints: BoxConstraints(),
          padding: const EdgeInsets.only(left: 10),
          onPressed: null,
          icon: Icon(
            Icons.edit_outlined,
            color: Colors.white,
          ))
    ]);
  }
}
