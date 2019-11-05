import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/provider/reminders.dart';
import 'package:reminder_app/screens/add_reminder_screen.dart';
import 'package:reminder_app/widgets/reminder_item.dart';

class Home extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 150,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Reminders'),
            ),
            floating: false,
            pinned: false,
            snap: false,
          ),
          Consumer<Reminders>(
            builder: (context, remindersData, _) {
              return SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (remindersData.reminders.length == 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.insert_emoticon),
                          Text(
                            'All Done!',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ReminderItem(
                          id: remindersData.reminders[index].id,
                          name: remindersData.reminders[index].name,
                          dateTime: remindersData.reminders[index].dateTime,
                        ),
                      );
                    }
                  },
                  childCount: (remindersData.reminders.length > 0)
                      ? remindersData.reminders.length
                      : 1,
                ),
                itemExtent: 100,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.of(context).pushNamed(AddReminderScreen.routeName, arguments: null);
          print(result);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
