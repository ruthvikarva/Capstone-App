import 'package:flutter/material.dart';
import 'edit_info.dart';

class AboutMe extends StatefulWidget{
  AboutMe({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AboutMe();
  }
}

class _AboutMe extends State<AboutMe> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text("Allergies"),
            children: <Widget>[

            ],
          ),
          ExpansionTile(
            title: Text("Diet"),
            children: <Widget>[
            ],
          ),
          ExpansionTile(
            title: Text("Personal Information"),
            children: <Widget>[
              Text("Name:")
            ],
          ),
          Center(
            child: RaisedButton(
              child: Text("Edit"),
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10),
              ),

              onPressed: (){
                Navigator.push((context),
                    MaterialPageRoute(
                        builder: (context)=>EditInfo()
                    )
                );
              },
            ),
          )




        ],
      ),
    );
  }
}

