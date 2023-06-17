import 'package:chat_app/sql_helper.dart';
import 'package:path_provider/path_provider.dart';

class Reminder {
  Future<int> createItem(
      String s, String d, int r, int so, String da, String h) async {
    print("fecha: $d");
    return (await SQLHelper.createReminder(s, d, r, so, da, h));
    //return ("Created succesfully");
  }

  void updateReminder(
      int id, String s, String d, int r, int so, String da, String h) async {
    await SQLHelper.updateReminder(id, s, d, r, so, da, h);
  }

  dynamic getItems() async {
    final data = await SQLHelper.getReminders();

    //print("get items: $data");
    return (data);
  }

  Future<List<Map<String, dynamic>>> getReminder(id) async {
    var ret = await SQLHelper.getReminder(id);
    return ret;
  }

  Future<List<Map<String, dynamic>>> getItemsByDay(String d) async {
    print("ENTRA EN GET BY DAY EN REMINDER");
    List<Map<String, dynamic>> ret = [];
    ret = await SQLHelper.getRemindersByDay(d);

    return ret;
  }

  Future<List<List<Map<String, dynamic>>>> getItemsByMonth(m) async {
    //print("get items by data");

    List<List<Map<String, dynamic>>> ret = [];
//2023-09-27

    for (int i = 1; i < 32; i++) {
      String d;
      if (i < 10) {
        d = "0$i";
      } else {
        d = i.toString();
      }

      String date = "2023-$m-$d";
      List<Map<String, dynamic>> recordatorio =
          await SQLHelper.getRemindersByDay(date);

      ret.add(recordatorio);
    }
    //List<Map<String, dynamic>> recordatorio =
    //  await SQLHelper.getRemindersByDate(m);

    //ret.add(recordatorio);

    return ret;
  }

  void delete() async {
    // ignore: unused_local_variable
    final appDir = await getApplicationDocumentsDirectory();

    //print("delte");

    SQLHelper.deleteDatabase("${appDir.path}/databases/dbchat.db");
  }
}
