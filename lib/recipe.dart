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


  final db = Firestore.instance;
  String userID;
  bool alreadyExists;



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
              //var name= snapshot.data.documents[i]["Name"];
              print(snapshot.data.documents[i]["Name"].runtimeType);
              inventoryList.add(snapshot.data.documents[i]["Name"]);
              //inventoryList.add((name.toLowerCase()).split(" "));
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
                  var recipesfrmDB=snapshot2.data.documents;
                  return StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance.collection("users").document(userID).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot3){
                      if(snapshot3.hasError){
                        return Text("There has been an error. Try again");
                      }
                      if(snapshot3.connectionState==ConnectionState.waiting){
                        return Text("Awaiting connection");
                      }
                      if(snapshot3.data["allergies"].length==0){
                        List<RecipeOverview> recipeList= new List<RecipeOverview>();
                        var userAllergies=snapshot3.data["allergies"];
                        for (int x=0; x<recipesfrmDB.length; x++){
                          recipeList.add(
                              RecipeOverview(
                                recipesfrmDB[x]["name"],
                                recipesfrmDB[x]["image_url"],
                                recipesfrmDB[x]["totaltime"],
                                recipesfrmDB[x]["calories"],
                                recipesfrmDB[x]["ingredientName"],
                              )
                          );
                        }
                        return ListView.builder(
                          itemCount: recipeList.length,
                          itemBuilder: (BuildContext context, int index){
                            return Card(
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:NetworkImage(recipeList[index].image) ,
                                    ),

                                    title: Text(recipeList[index].name),

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
                      else{
                        List<RecipeOverview> recipeList= new List<RecipeOverview>();
                        var userAllergies=snapshot3.data["allergies"];
                        for (int x=0; x<recipesfrmDB.length; x++){
                          if(recipesfrmDB[x]["allergies"].isEmpty){
                            recipeList.add(
                                RecipeOverview(
                                  recipesfrmDB[x]["name"],
                                  recipesfrmDB[x]["image_url"],
                                  recipesfrmDB[x]["totaltime"],
                                  recipesfrmDB[x]["calories"],
                                  recipesfrmDB[x]["ingredientName"],
                                )
                            );
                          }
                          else{
                            Map recAllergies=recipesfrmDB[x]["allergies"];
                            bool allergyFound=false;
                            //print("-------------");
                            print(recAllergies);
                            for(int j=0; j<userAllergies.length; j++){
                                print(userAllergies[j]);
                                if(recAllergies.containsValue(userAllergies[j].toLowerCase())){
                                  allergyFound=true;
                                }
                            }
                            if(allergyFound==false){
                              recipeList.add(
                                  RecipeOverview(
                                    recipesfrmDB[x]["name"],
                                    recipesfrmDB[x]["image_url"],
                                    recipesfrmDB[x]["totaltime"],
                                    recipesfrmDB[x]["calories"],
                                    recipesfrmDB[x]["ingredientName"],
                                  )
                              );
                            }
                          }
                        }

                        /*
                          else{
                            Map recAllergies=recipesfrmDB[x]["allergies"];
                            print(recAllergies);
                            //bool allergyFound=false;

                          }

                        } //end of allergy for loop


                        for(int y=0; y<recipeList.length; y++){
                          int counter=0;
                          double similarity=0;
                          for(int z=0; z<inventoryList.length; z++){
                            if(recipeList[z].ingredName.containsValue(inventoryList[z])){
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
                        */
                        return ListView.builder(
                          itemCount: recipeList.length,
                          itemBuilder: (BuildContext context, int index){
                            return Card(
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:NetworkImage(recipeList[index].image) ,
                                    ),

                                    title: Text(recipeList[index].name),

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


                  /*
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
                  */
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
  Map ingredName;

  RecipeOverview(this.name, this.image, this.time, this.calories, this.ingredName);
}
