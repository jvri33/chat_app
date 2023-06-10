import 'package:chat_app/controllers/saved_message.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DateWidget extends StatefulWidget {
  String date;
  int id;
  String message;
  DateWidget(
      {required this.date, required this.id, required this.message, super.key});

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Día: ${widget.date}",
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
      IconButton(
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.only(left: 10),
          onPressed: () async {
            DateTime? picketDate = await showDatePicker(
                context: context,
                initialDate: DateTime.parse(widget.date),
                firstDate: DateTime.now(),
                lastDate: DateTime(2024));

            if (picketDate != null) {
              setState(() {
                picketDate.toString().split(" ")[0];
                List<String> mess = widget.message.split("/");

                mess[1] = picketDate.toString().split(" ")[0];

                String messSt = mess.join("/");

                SavedMessage s = SavedMessage();
                s.updateMessageDate(messSt, widget.id);
              });
            }
          },
          icon: const Icon(
            Icons.edit_outlined,
            color: Colors.white,
          ))
    ]);
  }
}
