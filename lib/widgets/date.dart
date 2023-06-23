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
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
      IconButton(
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.only(left: 10),
          onPressed: () async {
            DateTime? picketDate = await showDatePicker(
                context: context,
                initialDate: DateTime.parse(date),
                firstDate: DateTime.now(),
                lastDate: DateTime(2024));

            if (picketDate != null) {
              picketDate.toString().split(" ")[0];
              print(message);

              List<String> mess = message.split("/");

              if (mess[0] != "EDITING" || mess[0] != "DELETING") {
                mess[1] = picketDate.toString().split(" ")[0];
              } else {
                mess[2] = picketDate.toString().split(" ")[0];
              }
              String messSt = mess.join("/");

              SavedMessage s = SavedMessage();

              print(picketDate.toString().split(" ")[0]);

              await s.updateMessageDate(messSt, id);

              onUpdateDate(picketDate.toString().split(" ")[0]);
            }
          },
          icon: const Icon(
            Icons.edit_outlined,
            color: Colors.white,
          ))
    ]);
  }
}
