import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../controllers/reminder.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Calendario extends StatelessWidget {
  Calendario({super.key}) {
    getCalendar();
  }
  List<List<int>> month = [];
  late List<Map<String, dynamic>> savedReminders = [];

  Future<void> getCalendar() async {
    DateTime d = DateTime.now();

    int thisDays = DateUtils.getDaysInMonth(d.year, d.month);
    int previous_days = DateUtils.getDaysInMonth(d.year, d.month - 1);
    int future_days = DateUtils.getDaysInMonth(d.year, d.month + 1);
    DateTime firstday = DateTime(d.year, d.month, 1);
    //DateTime lastday = DateTime(d.year, d.month, this_days);

    //print(firstday.weekday);
    //print(lastday.weekday);

    List<int> line = [0, 0, 0, 0, 0, 0, 0];
    bool saved = false;
    line[firstday.weekday] = 1;
    int count = 0;
    int start = firstday.weekday - 1;
    for (int i = 1; i <= thisDays; i++) {
      saved = false;
      line[start + count] = i;
      count++;

      if (start + count == 7) {
        print(line);
        month.add(line);
        line = [0, 0, 0, 0, 0, 0, 0];
        start = 0;
        count = 0;
        saved = true;
      }
    }

    if (saved == false) {
      month.add(line);
    }
    print("mes: $line");
    print("object $month");
  }

  Future<void> getReminders() async {
    Reminder r = Reminder();
    var printing = await r.getItems();
    savedReminders = printing;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCalendar(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Text(month[0].toString()),
              Text(month[1].toString()),
              Text(month[2].toString()),
              Text(month[3].toString()),
              Text(month[4].toString())
            ],
          );
        });
  }
}
