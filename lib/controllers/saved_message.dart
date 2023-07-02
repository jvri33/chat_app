import 'package:chat_app/sql_helper.dart';

class SavedMessage {
  Future<String> createItem(String s, int n, String s2) async {
    await SQLHelper.createMessage(s, n, s2);
    return ("Created succesfully");
  }

  Future<dynamic> getItems() async {
    final data = await SQLHelper.getMessages();

    return (data);
  }

  Future<bool> updateMessageDate(String mes, int id) async {
    await SQLHelper.updateMessageDate(mes, id);
    return true;
  }

  Future<void> updateMessageTime(String time, int id) async {
    await SQLHelper.updateMessageTime(time, id);
  }

  void updateMessageSound(String s, int id) async {
    SQLHelper.updateMessageTime(s, id);
  }

  void updateMessageRepeat(String s, int id) async {
    SQLHelper.updateMessageRepeat(s, id);
  }

  Future<void> updateMessage(String mess, id, String type) async {
    await SQLHelper.updateMessageMess(mess, id, type);
  }
}
