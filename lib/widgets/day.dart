import 'package:flutter/cupertino.dart';

import '../controllers/reminder.dart';
import '../controllers/saved_message.dart';

// ignore: must_be_immutable
class DayWidget extends StatelessWidget {
  String message;
  int id;
  int cantidad = 0;
  List<Map<String, dynamic>> recordatorios = [];
  DayWidget(this.message, this.id, {super.key});

  late List<String> variables = message.split("/");

  Future<String> getReminders() async {
    //print(variables.toString());

    if (variables[0] == "DELETE1") {
      String date = variables[1];

      if (date != "NULL") {
        Reminder r = Reminder();
        recordatorios = await r.getItemsByDay(date);

        cantidad = recordatorios.length;

        if (cantidad == 1) {
          print("Hay un recordatorio");
          message =
              "DELETING/${recordatorios[0]["id"]}/${recordatorios[0]["date"]}/${recordatorios[0]["time"]}/${recordatorios[0]["sound"]}/${recordatorios[0]["repeat"]}/${recordatorios[0]["description"]}";
          SavedMessage s = SavedMessage();
          await s.updateMessage(message, id, "i");
          variables = message.split("/");
        } else if (cantidad == 0) {
          print("No hay recordatorios");
        } else {
          print("Hay más de un recordatorio");
        }
      }
    }

    return "finish";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Prueba de día"),
    );
  }
}
