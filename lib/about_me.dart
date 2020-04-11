import 'package:flutter/material.dart';


class AboutMe extends StatefulWidget{
  AboutMe({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AboutMe();
  }
}

class _AboutMe extends State<AboutMe> {
  Map<String, bool> allergies={
    "Egg": false,
    "Milk": false,
    "Peanut": false,
    "Seafood" : false,
    "Sesame" : false,
    "Soy": false,
    "Wheat": false
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          /*
          Container(
            height: 500,
            child:ListView(
                children: allergies.keys.map((String key){
                  return new CheckboxListTile(
                      title: new Text(key),
                      value: allergies[key],
                      activeColor: Colors.redAccent,
                      onChanged: (bool value){
                        setState(() {
                          allergies[key]=value;
                        });
                      });
                }).toList()
            ),
          ),
          */
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




        ],
      ),
    );
  }
}

