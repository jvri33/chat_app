import 'package:chat_app/controllers/reminder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/material.dart';

class Week extends StatelessWidget {
  List<List<Map<String, dynamic>>> recordatorios = [];
  String mes;
  Week(this.mes, {super.key});
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> getReminders() async {
    DateTime date;
    if (mes == "THISWEEK") {
      date = DateTime.now();
    } else {
      date = DateTime.now().add(Duration(days: 7));
    }

    Reminder r = Reminder();
    DateTime start = getDate(date.subtract(Duration(days: date.weekday - 1)));
    List<Map<String, dynamic>> recordatoriosh = [];
    for (int i = 0; i < 7; i++) {
      print("$i");
      DateTime d = start.add(Duration(days: i));
      print("dia: $d");
      recordatoriosh = await r.getItemsByDay(d.toString().split(" ")[0]);
      recordatorios.add(recordatoriosh);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getReminders(),
        builder: (context, snapshot) {
          return Container(
            child: Text(recordatorios.toString()),
          );
        });
  }
}
