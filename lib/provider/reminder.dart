import 'dart:convert';

import 'package:flutter/material.dart';

Reminder reminderFromJson(String str) => Reminder.fromJson(json.decode(str));

String reminderToJson(Reminder data) => json.encode(data.toJson());

class Reminder {
  final int id;
  final String name;
  final DateTime dateTime;

  Reminder({@required this.id, @required this.name, @required this.dateTime});

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json["id"],
        name: json["name"],
        dateTime: DateTime.parse(json["datetime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "datetime": dateTime.toIso8601String(),
      };
}
