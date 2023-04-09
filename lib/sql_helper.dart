import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class SQLHelper {
  static Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE reminders(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      description TEXT,
      date DATETIME,
      repeat BIT,
      sound BIT,
      days JSON,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<Database> db() async {
    return openDatabase('dbchat.db', version: 1,
        onCreate: (Database database, int version) async {
      await createTable(database);
    });
  }
}
