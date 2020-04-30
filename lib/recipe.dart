import 'package:capstoneapp/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'calendarpage.dart';
import 'letsSee.dart';

class Recipe extends StatefulWidget {
  Recipe({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;


  @override
  RecipePageState createState() => RecipePageState(auth, onSignedOut);
}

class RecipePageState extends State<Recipe> {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  RecipePageState(this.auth, this.onSignedOut);

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    }
    catch (e) {
      print(e);
    }
  }

  final db = Firestore.instance;
  String currentUser;
  bool alreadyExists;

  int _selectedPage = 0;
  final _pageOptions = [
    ProfilePage(),
    Recipe(),
    AddIng(),
    CalendarPage(),
  ];

  final List<String> items = [ "new", "york", "city"];

  void _page() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddIng()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new GestureDetector(
                onTap: (){ print("Card Clicked");},
                child: new Card(
                child: new Container(
                  padding: new EdgeInsets.all(52.0),
                  child: new Column(
                    children: <Widget>[
                      new Text('Hello World'),
                      new Text('How are you?')
                    ],
                  ),
                ),
               ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

