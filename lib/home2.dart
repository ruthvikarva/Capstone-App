import 'package:capstoneapp/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;


  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Recipe'),
        actions: <Widget>[
          new FlatButton(
              onPressed: _signOut,
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17, color: Colors.white))
          )
        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}