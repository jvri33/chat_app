import 'package:chat_app/sql_helper.dart';
import 'package:path_provider/path_provider.dart';

class Reminder {
  Future<int> createItem(
      String s, String d, int r, int so, String da, String h) async {
    return (await SQLHelper.createReminder(s, d, r, so, da, h));
    //return ("Created succesfully");
  }

  Future<int> updateReminder(
      int id, String s, String d, int r, int so, String da, String h) async {
    return await SQLHelper.updateReminder(id, s, d, r, so, da, h);
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
    List<Map<String, dynamic>> ret = [];
    ret = await SQLHelper.getRemindersByDay(d);

    return ret;
  }

  Future<List<List<Map<String, dynamic>>>> getItemsByMonth(m) async {
    List<List<Map<String, dynamic>>> ret = [];

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

    return ret;
  }

  Future<void> delete(int id) async {
    await SQLHelper.deleteReminder(id);
  }

  void deleteall() async {
    final appDir = await getApplicationDocumentsDirectory();

    SQLHelper.deleteDatabase("${appDir.path}/databases/dbchat.db");
  }
}
