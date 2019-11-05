import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reminder_app/provider/reminder.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    await Sqflite.devSetDebugModeOn(true);
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "Reminders.db";
    print(path);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE reminder ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "datetime TEXT"
          ")");
    });
  }

  newReminder(Reminder newReminder) async {
    final db = await database;
    var result = await db.insert("reminder", newReminder.toJson());
    print('reminder added to database:' + result.toString());
    return result;
  }

  getReminder(int id) async {
    final db = await database;
    var result = await db.query("reminder", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Reminder.fromJson(result.first) : null;
  }

  getAllReminders() async {
    final db = await database;
    var result = await db.query("reminder");
    List<Reminder> list = result.isNotEmpty
        ? result.map((r) => Reminder.fromJson(r)).toList()
        : [];
    print('reminders fetched');
    return list;
  }

  updateReminder(Reminder updatedReminder) async {
    Map<String, dynamic> update = {'name' : updatedReminder.name, 'datetime' : updatedReminder.dateTime.toIso8601String()};
    final db = await database;
    var result = await db.update("reminder", update,
        where: "id = ?", whereArgs: [updatedReminder.id], conflictAlgorithm: ConflictAlgorithm.replace);
    print("rows updated" + result.toString());
    return result;
  }

  deleteReminder(int id) async {
    final db = await database;
    db.delete("reminder", where: "id = ?", whereArgs: [id]);
    print('reminder deleted');
  }

  deleteAllReminders() async {
    final db = await database;
    db.rawDelete("Delete * from reminder");
  }
}
