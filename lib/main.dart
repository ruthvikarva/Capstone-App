import 'package:capstoneapp/auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Meal App Login',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light
      ),
      home: new RootPage(auth: new Auth())
    );
  }
}

