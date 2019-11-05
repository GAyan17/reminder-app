import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/provider/reminders.dart';
import 'package:reminder_app/screens/add_reminder_screen.dart';
import 'package:reminder_app/screens/new_home_screen.dart';

void main() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => Reminders(),
      child: MaterialApp(
        title: 'Reminder',
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.amberAccent,
        ),
        home: Home(),
        onGenerateRoute: (settings) {
          if (settings.name == AddReminderScreen.routeName) {
            Map<String, dynamic> newMap = settings.arguments;
            print(newMap);
            return MaterialPageRoute(builder: (context) {
              return (newMap != null)
                  ? AddReminderScreen(
                      reminderId: newMap['id'],
                      reminderName: newMap['name'],
                    )
                  : AddReminderScreen();
            });
          }
        },
      ),
    );
  }
}
