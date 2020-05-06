import 'package:capstoneapp/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'auth.dart';
import 'letsSee.dart';
import 'dart:async';
import 'recipe_details.dart';

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


  void getUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userID=user.uid;
    setState(() {
      userID=user.uid;
    });
  }

  bool calorieFilter=false;
  bool allergyFilter=false;
  bool pantryFilter=false;

  void initState() {
    super.initState();
    getUser();
  }


  final double threshold=.70;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(
          children: <Widget>[
            Flexible(
              child: StreamBuilder(
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
                                  //Make the ingredient list
                                  List recipeIngred=new List();
                                  recipesfrmDB[x]["ingredientName"].forEach((key, value) {
                                    recipeIngred.add(value);
                                  });
                                  recipeList.add(
                                      RecipeOverview(
                                        recipesfrmDB[x].documentID,
                                        recipesfrmDB[x]["name"],
                                        recipesfrmDB[x]["image_url"],
                                        recipesfrmDB[x]["totalTime"],
                                        recipesfrmDB[x]["prepTime"],
                                        recipesfrmDB[x]["cookTime"],
                                        recipesfrmDB[x]["calories"],
                                        recipeIngred,
                                        recipesfrmDB[x]["ingredients"],
                                        recipesfrmDB[x]["instructions"],
                                        recipesfrmDB[x]["servingSize"],
                                        recipesfrmDB[x]["cholesterol"]["amount"],
                                        recipesfrmDB[x]["sodium"]["amount"],
                                        recipesfrmDB[x]["protein"]["amount"],
                                        recipesfrmDB[x]["fat"]["amount"],
                                        recipesfrmDB[x]["carbohydrates"]["amount"],
                                        recipesfrmDB[x]["saturated fat"]["amount"],
                                        recipesfrmDB[x]["sugar"]["amount"],
                                        recipesfrmDB[x]["ingredientQuantity"],
                                      )
                                  );
                                }
                                print("here");
                                List<RecipeOverview> filteredListPantry= new List<RecipeOverview>();
                                for (int i=0; i<recipeList.length; i++){
                                  int counter=0;
                                  double similarity=0;
                                  for(int j=0; j<inventoryList.length; j++) {
                                    for(int k=0; k<recipeList[i].ingredName.length; k++){
                                      var recipeWord=recipeList[i].ingredName[k];
                                      if((recipeWord).contains(inventoryList[j])){
                                        counter=counter+1;
                                        print("-----------${recipeList[i].name}------------\n");
                                        print("Match:${inventoryList[j]}");

                                      }
                                    }
                                  }
                                  similarity= counter/recipeList[i].ingredName.length;
                                  print(similarity);
                                  if(similarity>=threshold){
                                    print("------------**********-------------");
                                    print(recipeList[i].name);
                                    filteredListPantry.add(
                                        RecipeOverview(
                                          recipeList[i].id,
                                          recipeList[i].name,
                                          recipeList[i].image,
                                          recipeList[i].totaltime,
                                          recipeList[i].preptime,
                                          recipeList[i].cooktime,
                                          recipeList[i].calories,
                                          recipeList[i].ingredName,
                                          recipeList[i].ingredients,
                                          recipeList[i].instructions,
                                          recipeList[i].serving,
                                          recipeList[i].cholesterol,
                                          recipeList[i].sodium,
                                          recipeList[i].protein,
                                          recipeList[i].fat,
                                          recipeList[i].carbs,
                                          recipeList[i].saturatedFat,
                                          recipeList[i].sugar,
                                          recipeList[i].quantity,
                                        )
                                    );
                                  }
                                }
                                return ListView.builder(
                                  itemCount: filteredListPantry.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return Card(
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:NetworkImage(filteredListPantry[index].image) ,
                                            ),

                                            title: Text(filteredListPantry[index].name),

                                            onTap: (){
                                              Navigator.push(context,
                                                new MaterialPageRoute(builder: (context)=>RecipeDetails(filteredListPantry[index], inventoryList)),
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
                                  //Make the ingredient list
                                  List recipeIngred=new List();
                                  recipesfrmDB[x]["ingredientName"].forEach((key, value) {
                                    recipeIngred.add(value);
                                  });
                                  var id=recipesfrmDB[x].documentID;
                                  if(recipesfrmDB[x]["allergies"].isEmpty){
                                    recipeList.add(
                                        RecipeOverview(
                                          recipesfrmDB[x].documentID,
                                          recipesfrmDB[x]["name"],
                                          recipesfrmDB[x]["image_url"],
                                          recipesfrmDB[x]["totalTime"],
                                          recipesfrmDB[x]["prepTime"],
                                          recipesfrmDB[x]["cookTime"],
                                          recipesfrmDB[x]["calories"],
                                          recipeIngred,
                                          recipesfrmDB[x]["ingredients"],
                                          recipesfrmDB[x]["instructions"],
                                          recipesfrmDB[x]["servingSize"],
                                          recipesfrmDB[x]["cholesterol"]["amount"],
                                          recipesfrmDB[x]["sodium"]["amount"],
                                          recipesfrmDB[x]["protein"]["amount"],
                                          recipesfrmDB[x]["fat"]["amount"],
                                          recipesfrmDB[x]["carbohydrates"]["amount"],
                                          recipesfrmDB[x]["saturated fat"]["amount"],
                                          recipesfrmDB[x]["sugar"]["amount"],
                                          recipesfrmDB[x]["ingredientQuantity"],
                                        )

                                    );

                                  }
                                  else{
                                    Map recAllergies=recipesfrmDB[x]["allergies"];
                                    bool allergyFound=false;
                                    print("${recipesfrmDB[x].documentID}");
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
                                            recipesfrmDB[x].documentID,
                                            recipesfrmDB[x]["name"],
                                            recipesfrmDB[x]["image_url"],
                                            recipesfrmDB[x]["totalTime"],
                                            recipesfrmDB[x]["prepTime"],
                                            recipesfrmDB[x]["cookTime"],
                                            recipesfrmDB[x]["calories"],
                                            recipeIngred,
                                            recipesfrmDB[x]["ingredients"],
                                            recipesfrmDB[x]["instructions"],
                                            recipesfrmDB[x]["servingSize"],
                                            recipesfrmDB[x]["cholesterol"]["amount"],
                                            recipesfrmDB[x]["sodium"]["amount"],
                                            recipesfrmDB[x]["protein"]["amount"],
                                            recipesfrmDB[x]["fat"]["amount"],
                                            recipesfrmDB[x]["carbohydrates"]["amount"],
                                            recipesfrmDB[x]["saturated fat"]["amount"],
                                            recipesfrmDB[x]["sugar"]["amount"],
                                            recipesfrmDB[x]["ingredientQuantity"],
                                          )
                                      );
                                    }
                                  }
                                }
                                List<RecipeOverview> filteredListPantry= new List<RecipeOverview>();
                                for (int i=0; i<recipeList.length; i++){
                                  int counter=0;
                                  double similarity=0;
                                  for(int j=0; j<inventoryList.length; j++) {
                                    for(int k=0; k<recipeList[i].ingredName.length; k++){
                                      var recipeWord=recipeList[i].ingredName[k];
                                      if((recipeWord).contains(inventoryList[j])){
                                        counter=counter+1;
                                        print("-----------${recipeList[i].name}------------\n");
                                        print("Match:${inventoryList[j]}");

                                      }
                                    }
                                  }
                                  similarity= counter/recipeList[i].ingredName.length;
                                  print(similarity);
                                  if(similarity>=threshold){
                                    print("------------**********-------------");
                                    print(recipeList[i].name);
                                    filteredListPantry.add(
                                        RecipeOverview(
                                          recipeList[i].id,
                                          recipeList[i].name,
                                          recipeList[i].image,
                                          recipeList[i].totaltime,
                                          recipeList[i].preptime,
                                          recipeList[i].cooktime,
                                          recipeList[i].calories,
                                          recipeList[i].ingredName,
                                          recipeList[i].ingredients,
                                          recipeList[i].instructions,
                                          recipeList[i].serving,
                                          recipeList[i].cholesterol,
                                          recipeList[i].sodium,
                                          recipeList[i].protein,
                                          recipeList[i].fat,
                                          recipeList[i].carbs,
                                          recipeList[i].saturatedFat,
                                          recipeList[i].sugar,
                                          recipeList[i].quantity,
                                        )
                                    );
                                  }
                                }
                                return ListView.builder(
                                  itemCount: filteredListPantry.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return Card(
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:NetworkImage(filteredListPantry[index].image) ,
                                            ),

                                            title: Text(filteredListPantry[index].name),

                                            onTap: (){
                                              Navigator.push(context,
                                                new MaterialPageRoute(builder: (context)=>RecipeDetails(filteredListPantry[index], inventoryList)),
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
                    );
                  }
                },
              ),
            ),
          ],
        )
    );
  }
}




class RecipeOverview{
  String id;
  String name;
  String image;
  String totaltime;
  String preptime;
  String cooktime;
  int calories;
  List ingredName;
  Map ingredients;
  Map instructions;
  int serving;
  int carbs;
  int cholesterol;
  int fat;
  int protein;
  int saturatedFat;
  int sodium;
  int sugar;
  Map quantity;


  RecipeOverview(
      this.id,
      this.name,
      this.image,
      this.totaltime,
      this.preptime,
      this.cooktime,
      this.calories,
      this.ingredName,
      this.ingredients,
      this.instructions,
      this.serving,
      this.cholesterol,
      this.sodium,
      this.protein,
      this.fat,
      this.carbs,
      this.saturatedFat,
      this.sugar,
      this.quantity
      );
}