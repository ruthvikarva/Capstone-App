import 'package:capstoneapp/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'calendarpage.dart';
import 'letsSee.dart';

/*class HomePage5 extends StatelessWidget {
  HomePage5({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal History',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage3(auth, onSignedOut),
    );
  }
}*/
class HomePage3 extends StatefulWidget {
  HomePage3({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage3> {
  _HomePageState({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;


  @override
  void initState() {
    super.initState();
  }

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    }
    catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Recipe'),
          actions: <Widget>[
            new FlatButton(
                onPressed: _signOut,
                child: new Text('Logout', style: new TextStyle(fontSize: 17, color: Colors.white))
            )
          ],
        ),
      body: new Container(
        child: new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Text('Welcome', style: new TextStyle(fontSize: 32.0),),
              //Calender Button
              RaisedButton(
                child: Text("Calender"),
                onPressed:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarPage()),
                  );
                },
                color: Colors.blue,
                textColor: Colors.black,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(
                child: Text("Profile"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                color: Colors.amber,
                textColor: Colors.black,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(
                child: Text("Pantry"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddIng()),
                  );
                },
                color: Colors.lightGreenAccent,
                textColor: Colors.black,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}