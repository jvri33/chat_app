import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TimeWidget extends StatefulWidget {
  final String time;
  const TimeWidget({required this.time, super.key});

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Día: ${widget.time}",
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
