import 'package:flutter/material.dart';
import 'about_me.dart';

class ProfilePage extends StatefulWidget{
  ProfilePage({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ListView(
          children: <Widget>[

            Container(
              child:Padding(
                padding: EdgeInsets.all(20.0) ,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          minRadius: 60,
                          backgroundImage: AssetImage('images/circle-cropped (11).png'),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),

                    SizedBox(height: 8,),
                    //*******************
                    Text("Red Tomato", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    ),
                    //******************
                    Text("Member since 2020", style: TextStyle(
                      fontSize: 14,
                    ),
                    ),
                    //*****************
                  ],
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
              ),
              child:DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  children: <Widget>[
                    TabBar(
                      tabs:[
                        Tab(text:"ABOUT ME"),
                        Tab(text:"GOALS")
                      ],
                    ),
                    Container(
                      height: 350,
                      color: Colors.white,
                      child: TabBarView(
                        children: <Widget>[
                          Container(
                              child: AboutMe()
                          ),
                          Container(
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
      ),

    );
  }
}


