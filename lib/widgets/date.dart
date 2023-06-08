import 'package:chat_app/controllers/saved_message.dart';
import 'package:chat_app/widgets/reminder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
      IconButton(
          constraints: BoxConstraints(),
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

                print(widget.id);
                print(messSt);
                print(widget.message);

                SavedMessage s = SavedMessage();
                s.updateMessage(messSt, widget.id);
              });
            }
          },
          icon: Icon(
            Icons.edit_outlined,
            color: Colors.white,
          ))
    ]);
  }
}
