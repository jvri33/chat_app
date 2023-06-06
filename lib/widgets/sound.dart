import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class SoundWidget extends StatefulWidget {
  final int sound;
  const SoundWidget({required this.sound, super.key});

  @override
  State<SoundWidget> createState() => _SoundWidgetState();
}

class _SoundWidgetState extends State<SoundWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Sonido: ",
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
