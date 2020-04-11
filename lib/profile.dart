import 'package:flutter/material.dart';
import 'about_me.dart';
import 'edit_info.dart';

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
      body: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.red,
                        Colors.deepOrange,
                        Colors.orange,
                      ]
                  )
              ),
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
                gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.deepOrange,
                      Colors.orange,
                    ]
                ),
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
                      height: 500,
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
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.edit),
        label: Text("Edit"),
        backgroundColor: Colors.redAccent ,
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context)=>EditInfo()
              )
          );
        },
      ),
    );
  }
}
