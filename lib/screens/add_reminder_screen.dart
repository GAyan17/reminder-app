import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/provider/reminders.dart';

class AddReminderScreen extends StatefulWidget {
  static const routeName = '/addreminders';

  final int reminderId;
  final String reminderName;

  AddReminderScreen({this.reminderId, this.reminderName});

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();

  final format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    if (widget.reminderId != null) {
      print(widget.reminderId.toString());
      print(widget.reminderName);
    }

    String name;
    DateTime dateTime;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: widget.reminderId == null ? Text('Add Reminders') : Text('Edit Reminder'),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: widget.reminderName,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          name = value;
//                        print(name);
                        });
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text('Basic date & time field (${format.pattern})'),
                    SizedBox(
                      height: 24,
                    ),
                    DateTimeField(
                      format: format,
                      decoration: InputDecoration(
                          labelText: '${format.pattern}',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            initialDate: currentValue ?? DateTime.now(),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          dateTime = value;
//                        print(dateTime);
                        });
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Consumer<Reminders>(
                      builder: (context, reminderData, _) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            hoverElevation: 8.0,
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.black87),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                setState(() {
                                  print(widget.reminderId);
                                  print(name);
                                  print(dateTime);
                                  reminderData.addReminder(name, dateTime,
                                      id: widget.reminderId);
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
