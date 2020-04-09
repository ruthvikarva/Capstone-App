// calendarpage.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    CalendarController _controller;

    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Calendar'),
      ),
      body: Center(
        child: RaisedButton(
            child: Text('Back To HomeScreen'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () => Navigator.pop(context)
        ),
      ),
    );
  }
}