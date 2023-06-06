import 'package:chat_app/sql_helper.dart';
import 'package:path_provider/path_provider.dart';

class Reminder {
  Future<int> createItem(
      String s, DateTime d, int r, int so, String da, String h) async {
    return (await SQLHelper.createReminder(
        s, (d.toString().split(" "))[0], r, so, da, h));
    //return ("Created succesfully");
  }

  dynamic getItems() async {
    final data = await SQLHelper.getReminders();
    return (data);
  }

  Future<List<Map<String, dynamic>>> getReminder(id) async {
    var ret = await SQLHelper.getReminder(id);
    return ret;
  }

  void delete() async {
    // ignore: unused_local_variable
    final appDir = await getApplicationDocumentsDirectory();

    print("delte");

    SQLHelper.deleteDatabase("${appDir.path}/databases/dbchat.db");
  }
}
