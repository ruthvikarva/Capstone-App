import 'package:capstoneapp/auth.dart';
import 'package:capstoneapp/letsSee.dart';
import 'package:capstoneapp/profile.dart';
import 'package:capstoneapp/recipe.dart';
import 'package:capstoneapp/testingDB.dart';
import 'package:flutter/material.dart';
import 'calendarpage.dart';
import 'pantry.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

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

        return BottomNavBar();
    /*
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
                    MaterialPageRoute(builder: (context) => PantryPage()),
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

    */
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedPage=0;
  final _pageOptions=[
    ProfilePage(),
    AddIng(),
    AddIng(),
    CalendarPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ) ,
    );
  }
}