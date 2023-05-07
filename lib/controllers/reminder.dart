import 'package:chat_app/sql_helper.dart';
import 'package:path_provider/path_provider.dart';

class Reminder {
  Future<int> createItem(String s, DateTime d) async {
    return (await SQLHelper.createReminder(s, d, 0, 0, ""));
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

    //SQLHelper.deleteDatabase("${appDir.path}/databases/dbchat.db");
  }
}
