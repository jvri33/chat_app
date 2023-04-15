import 'package:chat_app/sql_helper.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Reminder {
  Future<String> createItem(String s) async {
    print("Create: $s");
    await SQLHelper.createReminder(s, null, 0, 0, "");
    return ("Created succesfully");
  }

  dynamic getItems() async {
    final data = await SQLHelper.getReminders();
    return (data);
  }

  void delete() async {
    final appDir = await getApplicationDocumentsDirectory();

    final dirList =
        Directory("/data/user/0/com.example.chat_app/databases").listSync();
    for (var item in dirList) {
      print(item.path);
    }
    SQLHelper.deleteDatabase("${appDir.path}/databases/dbchat.db");
  }
}
