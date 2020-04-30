import 'package:capstoneapp/profile_aboutme.dart';
import 'package:capstoneapp/profile_goals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_aboutme.dart';

class ProfilePage extends StatefulWidget{
  ProfilePage({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  var userID;
  Future<String> getUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userID = user.uid;
    return userID;
  }
  @override
  void initState(){
    setState() {
      userID = getUser();
    }
    print(userID);
  }


  Widget build(BuildContext context) {
    return Scaffold(

      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Container(
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

                        Text("Red Tomato", style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                        ),

                        Text("Member since 2020", style: TextStyle(
                          fontSize: 14,
                        ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(

                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text("About Me", textAlign: TextAlign.center),
                            Icon(Icons.person),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text("My Goals", textAlign: TextAlign.center,),
                            Icon(Icons.assignment_turned_in),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },


          body: TabBarView(
            children: <Widget>[
              Container(
                height: 350,
                child: ProfileAboutMe(),
              ),
              /*
              Column(
                children: <Widget>[
                  Flexible(
                    child: ProfileAboutMe(),
                  )
                ],
              ),
              */
              Column(
                children: <Widget>[
                  Expanded(
                    child: ProfileGoals(),
                  )
                ],
              )
            ],
          ),


        ),
      ),


      /*
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
                    Text("Red Tomato", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    ),
                    Text("Member since 2020", style: TextStyle(
                      fontSize: 14,
                    ),
                    ),
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
                      height: 500,
                      color: Colors.white,
                      child: TabBarView(
                        children: <Widget>[
                          Container(
                              child: ProfileAboutMe()
                          ),
                          Container(
                            //child: ProfileGoals(),
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
      */
    );
  }

}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._bar);

  final TabBar _bar;


  @override
  double get minExtent => _bar.preferredSize.height;
  @override
  double get maxExtent => _bar.preferredSize.height;


  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _bar,
      color: Colors.blueGrey,
      height: 100,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate delegate) {
    return false;
  }

}

//https://medium.com/@diegoveloper/flutter-collapsing-toolbar-sliver-app-bar-14b858e87abe

