import 'package:capstoneapp/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'calendarpage.dart';
import 'letsSee.dart';
import 'dart:async';

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
  String userID;
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

  void getUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userID=user.uid;
    setState(() {
      userID=user.uid;
    });
  }

  void initState() {
    super.initState();
    getUser();
  }

  final double threshold=.70;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection("inventory").where("UserId", isEqualTo: userID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasError){
            return Text("There has been an error. Try again");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Text("Awaiting connection");
          }
          if(snapshot.data==null || snapshot.data.documents.length==0){
            return Card( child: Text("No recipes found"));
          }
          else{
            List<String> inventoryList=new List<String>();
            for(int i=0; i<snapshot.data.documents.length; i++){
              inventoryList.add(snapshot.data.documents[i]["Name"]);
            }
            return StreamBuilder(
              stream: Firestore.instance.collection("recipe").snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot2){
                if(snapshot2.hasError){
                  return Text("There has been an error. Try again");
                }
                if(snapshot2.connectionState==ConnectionState.waiting){
                  return Text("Awaiting connection");
                }
                if(snapshot2.data==null || snapshot.data.documents.length==0){
                  return Card( child: Text("No recipes found"));
                }
                else{
                  List<RecipeOverview> recipeList= new List<RecipeOverview>();
                  var len=snapshot2.data.documents.length;
                  var recipesfrmDB=snapshot2.data.documents;
                  for(int x=0; x<len; x++){
                    recipeList.add(
                        RecipeOverview(
                          recipesfrmDB[x]["name"],
                          recipesfrmDB[x]["image_url"],
                          recipesfrmDB[x]["totaltime"],
                          recipesfrmDB[x]["calories"],
                        )
                    );
                  }
                  for(int y=0; y<len; y++){
                    int counter=0;
                    double similarity=0;
                    for(int z=0; z<inventoryList.length; z++){
                      if(recipesfrmDB[y]["ingredientName"].containsValue(inventoryList[z].toLowerCase())){
                        print("Matches");
                        counter=counter+1;
                      }
                      similarity= counter/recipesfrmDB[y]["ingredientName"].length;
                      print(similarity);
                      if(similarity>=threshold){
                        print(recipesfrmDB[y]["name"]);
                      }
                    }

                  }
                  return ListView.builder(
                    itemCount: len,
                    itemBuilder: (BuildContext context, int index){
                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage:NetworkImage(snapshot2.data.documents[index]["image_url"]) ,
                              ),

                              title: Text(snapshot2.data.documents[index]["name"]),

                              onTap: (){
                                Navigator.push(context,
                                  new MaterialPageRoute(builder: (context)=>RecipeDetails(recipeList[index])),
                                );
                              },

                            )
                          ],
                        ),
                      );


                    },
                  );
                }
              },
            );
          }
        },
      ),
      /*
      body: StreamBuilder(
        stream: Firestore.instance.collection("recipe").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasError){
            return Text("There has been an error. Try again");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Text("Awaiting connection");
          }
          if(snapshot.data==null || snapshot.data.documents.length==0){
            return Card( child: Text("No recipes found"));
          }
          else{
            List<RecipeOverview> recipeList= new List<RecipeOverview>();
            var len=snapshot.data.documents.length;
            for(int x=0; x<len; x++){
              recipeList.add(
                  RecipeOverview(
                    snapshot.data.documents[x]["name"],
                    snapshot.data.documents[x]["image_url"],
                    snapshot.data.documents[x]["totaltime"],
                    snapshot.data.documents[x]["calories"],
                  )
              );
            }

            return ListView.builder(
              itemCount: len,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:NetworkImage(snapshot.data.documents[index]["image_url"]) ,
                        ),
                        title: Text(snapshot.data.documents[index]["name"]),

                        onTap: (){
                          Navigator.push(context, 
                            new MaterialPageRoute(builder: (context)=>RecipeDetails(recipeList[index])),
                          );
                        },

                      )
                    ],
                  ),
                );


              },
            );
          }
        },
      )
          */
    );
  }
}

class RecipeDetails extends StatelessWidget {
  final RecipeOverview rec;
  RecipeDetails(this.rec);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rec.name),
      ),
    );
  }
}


class RecipeOverview{
  String name;
  String image;
  String time;
  int calories;

  RecipeOverview(this.name, this.image, this.time, this.calories);
}
