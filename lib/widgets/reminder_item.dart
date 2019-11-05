import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/provider/reminders.dart';
import 'package:reminder_app/screens/add_reminder_screen.dart';

class ReminderItem extends StatelessWidget {
  final int id;
  final String name;
  final DateTime dateTime;

  ReminderItem({this.id, this.name, this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Delete'),
            Icon(Icons.delete)
          ],
          ),
        ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Reminders>(context, listen: false).removeReminder(id);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder Dismissed!'),
            ),
          );
      },

      child: ListTile(
        title: Text(name),
        subtitle:
        Text(dateTime.toIso8601String()),
        onTap: () async {
          print('tapped');
          Map<String, dynamic> newMap = {'id' : id, 'name': name};
          print(newMap);
          var result = await Navigator.pushNamed(context, AddReminderScreen.routeName, arguments: newMap);
          print(result);
        },
        ),
      );
  }
}
