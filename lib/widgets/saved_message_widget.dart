
import 'package:flutter/material.dart';

class SavedMessageWidget extends StatelessWidget {
  final int user;
  final String message;
  // ignore: use_key_in_widget_constructors
  const SavedMessageWidget(
    this.user,
    this.message,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(200))),
    
      alignment: user == 1 ? Alignment.topRight : Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 75.0, 
          maxWidth: 300.0,
        ),
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  bottomRight:
                      user == 0 ? const Radius.circular(16) : const Radius.circular(0),
                  topRight: const Radius.circular(16),
                  bottomLeft:
                      user == 1 ? const Radius.circular(16) : const Radius.circular(0)),
            ),
            color: user == 1
                ? const Color.fromARGB(255, 187, 247, 223)
                : Theme.of(context).primaryColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: Text(message,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: user == 1
                          ? Theme.of(context).primaryColor
                          : Colors.white)),
            )),
      ),
    );
  }
}
