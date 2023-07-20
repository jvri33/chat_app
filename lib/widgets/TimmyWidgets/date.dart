import 'dart:ui';

import 'package:chat_app/controllers/saved_message.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DateWidget extends StatelessWidget {
  String date;
  int id;
  String message;
  DateWidget(
      {required this.date,
      required this.id,
      required this.message,
      required this.onUpdateDate,
      super.key});

  final Function(String) onUpdateDate;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Día: $date",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary)),
      IconButton(
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.only(left: 10),
          onPressed: () async {
            DateTime? picketDate = await showDatePicker(
                locale: const Locale("es", "ES"),
                context: context,
                initialDate: DateTime.parse(date),
                firstDate: DateTime.now(),
                lastDate: DateTime(2024),
                builder: ((context, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Theme(
                        data: Theme.of(context).copyWith(
                            dialogBackgroundColor:
                                Theme.of(context).colorScheme.tertiary,
                            colorScheme: ColorScheme.light(
                                primary: Theme.of(context).primaryColor,
                                onPrimary:
                                    Theme.of(context).colorScheme.tertiary,
                                onSurface: Theme.of(context).primaryColor)),
                        child: child!),
                  );
                }));

            if (picketDate != null) {
              picketDate.toString().split(" ")[0];

              List<String> mess = message.split("/");

              if (mess[0] != "EDITING" || mess[0] != "DELETING") {
                mess[1] = picketDate.toString().split(" ")[0];
              } else {
                mess[2] = picketDate.toString().split(" ")[0];
              }
              String messSt = mess.join("/");

              SavedMessage s = SavedMessage();

              await s.updateMessageDate(messSt, id);

              onUpdateDate(picketDate.toString().split(" ")[0]);
            }
            // ignore: use_build_context_synchronously
            FocusScope.of(context).unfocus();
          },
          icon: Icon(
            Icons.edit_outlined,
            color: Theme.of(context).colorScheme.tertiary,
          ))
    ]);
  }
}
