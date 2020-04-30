import 'package:capstoneapp/auth.dart';
import 'package:capstoneapp/letsSee.dart';
import 'package:capstoneapp/profile.dart';
import 'package:capstoneapp/recipe.dart';
import 'package:capstoneapp/testingDB.dart';
import 'package:flutter/material.dart';
import 'calendarpage.dart';
import 'pantry.dart';

class HomePage2 extends StatefulWidget {
  HomePage2({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState(auth, onSignedOut);
}

class _HomePageState extends State<HomePage2> {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  _HomePageState(this.auth, this.onSignedOut);

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    }
    catch(e) {
      print(e);
    }
  }

  int _selectedPage = 0;

  final _pageOptions = [
    ProfilePage(),
    Recipe(),
    AddIng(),
    CalendarPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: AppBar(
        title: Text((){
          if(_selectedPage == 0)
            return "Profile";
          else if(_selectedPage == 1)
            return "Recipe";
          else if(_selectedPage == 2)
            return "Pantry";
          else if(_selectedPage == 3)
            return "Calendar";
          return "Hello";
        }()),
        actions: <Widget>[
          new FlatButton(
              onPressed: _signOut,
              //child: new Text('Logout', style: new TextStyle(fontSize: 17, color: Colors.white))
              child: new Icon(Icons.power)
          )
        ],
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedPage,
        onTap: (int index){
          setState(() {
            _selectedPage=index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon:  Icon(Icons.person),
              title: Text("Profile")
          ),
          BottomNavigationBarItem(
              icon:  Icon(Icons.event_note),
              title: Text("Recipes")

          ),
          BottomNavigationBarItem(
              icon:  Icon(Icons.shopping_basket),
              title: Text("Pantry")
          ),
          BottomNavigationBarItem(
              icon:  Icon(Icons.calendar_today),
              title: Text("Calendar")
          ),
        ],
      ),
    );
  }
}