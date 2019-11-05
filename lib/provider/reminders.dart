import 'package:flutter/material.dart';
import 'package:reminder_app/provider/reminder.dart';
import '../database/database_creator.dart';

class Reminders with ChangeNotifier {
  List<Reminder> _reminders = [];

  List<Reminder> get reminders {
    return [..._reminders];
  }

  void getReminders() async {
    _reminders = await DBProvider.db.getAllReminders();
    notifyListeners();
  }

   addReminder(String name, DateTime dateTime, {int id}) async {
    if(id != null) {
      _reminders.removeAt(_reminders.indexWhere((r) => r.id == id));
      _reminders.insert(0, Reminder(id: id, name: name, dateTime: dateTime));
      int result = await DBProvider.db.updateReminder(reminders[0]);
//      print("rows updated" + result.toString());
      notifyListeners();
      return result;
    }
    _reminders.insert(
        0, Reminder(id: DateTime.now().millisecondsSinceEpoch, name: name, dateTime: dateTime));
    int result = await DBProvider.db.newReminder(reminders[0]);
//    print("reminder added id:" + result.toString());
    return result;
    notifyListeners();
  }

  void removeReminder(int removeId) async {
    _reminders.removeWhere((reminder) => reminder.id == removeId);
    int result = await DBProvider.db.deleteReminder(removeId);
//    print("rows deleted: " + result.toString());
    notifyListeners();
  }
}
