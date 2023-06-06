import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class RepeatWidget extends StatefulWidget {
  final int repeat;
  const RepeatWidget({required this.repeat, super.key});

  @override
  State<RepeatWidget> createState() => _RepeatWidgetState();
}

class _RepeatWidgetState extends State<RepeatWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Repetición: ",
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
      SizedBox(
        height: 24.0,
        width: 24.0,
        child: Checkbox(
          value: false,
          onChanged: null,
          side: MaterialStateBorderSide.resolveWith(
            (states) => BorderSide(width: 2, color: Colors.white),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
      )
    ]);
  }
}
