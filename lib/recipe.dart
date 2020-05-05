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
                            /*
                            if(recipeList[i].ingredName.containsValue(inventoryList[j])){
                              print("-----------${recipeList[i].name}------------\n");
                              print("Match:${inventoryList[j]}");
                              counter=counter+1;
                            }
                            */
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
                                        new MaterialPageRoute(builder: (context)=>RecipeDetails(filteredListPantry[index])),
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

class RecipeDetails extends StatefulWidget {
  final RecipeOverview recipe;
  RecipeDetails(this.recipe);
  @override
  _RecipeDetailsState createState() => _RecipeDetailsState(this.recipe);
}

class _RecipeDetailsState extends State<RecipeDetails> {
  RecipeOverview recipe;
  _RecipeDetailsState(this.recipe);
  var timestamp;
  var userID;
  void getUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userID=user.uid;
    setState(() {
      userID=user.uid;
    });
  }

  Timestamp dateTime() {
    DateTime currentDate = new DateTime.now();
    var tsStart = Timestamp.fromDate(currentDate);
    print("Start: $currentDate");
    //print("Timestamp: $tsStart");
    return tsStart;
  }

  Future<void> addToLog(String recipeID, String recipeName, Timestamp time, String userID) async{
    return Firestore.instance.collection('log').add(
        {
          'recipeID':recipeID,
          'recipeName': recipeName,
          'dateTime': time,
          'userID': userID
        });
  }

  Future<void> addToNutrition(Timestamp time) async{
    DateTime beginDate= new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    //Check if a meal was already entered in nutrition
    QuerySnapshot querySnapshot= await Firestore.instance.collection("nutrition")
        .where("userID", isEqualTo: userID).where("dateTime", isGreaterThanOrEqualTo: beginDate).getDocuments();
    if(querySnapshot.documents.length==0){
      print("yes");
      return Firestore.instance.collection("nutrition").add(
          {
            'userID': userID,
            'dateTime': time,
            'calories': recipe.calories,
            'carbohydrates': recipe.carbs,
            'cholesterol': recipe.cholesterol,
            'fat': recipe.fat,
            'protein': recipe.protein,
            'saturatedFat': recipe.saturatedFat,
            'sodium': recipe.sodium,
            'sugar': recipe.sugar,
          });
    }
    else{
      print("no");
      int calories=recipe.calories;
      int cholesterol=recipe.cholesterol;
      int sodium=recipe.sodium;
      int protein=recipe.protein;
      int fat=recipe.fat;
      int carbs=recipe.carbs;
      int saturatedFat=recipe.saturatedFat;
      int sugar=recipe.sugar;
      var documents=querySnapshot.documents;
      var id;
      documents.forEach((element) {
        id=element.documentID;
        calories=calories + element.data["calories"];
        cholesterol=cholesterol + element.data["cholesterol"];
        sodium=sodium + element.data["sodium"];
        protein=protein + element.data["protein"];
        fat=fat + element.data["fat"];
        carbs=carbs + element.data["carbohydrates"];
        sugar=sugar + element.data["sugar"];
        saturatedFat=saturatedFat + element.data["saturatedFat"];
      });
      return Firestore.instance.collection("nutrition").document(id).updateData(
          {
            "calories": calories,
            "cholesterol": cholesterol,
            "sodium" : sodium,
            "protein":protein,
            "fat":fat,
            "carbohydrates":carbs,
            "saturatedFat":saturatedFat,
            "sugar": sugar,
            "dateTime": time
          }
      );
    }

  }

  void initState() {
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    List ingredientList=new List();
    recipe.ingredients.forEach((key, value) {
      ingredientList.add(value);
    });
    List instructionList= new List();
    recipe.instructions.forEach((key, value) {
      instructionList.add(value);
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            floating:false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                recipe.image,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child:Column(
                              children: <Widget>[
                                Text(
                                  "Prep Time",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Center(
                                  child: Text(
                                      recipe.preptime
                                  ),
                                ),
                                Center(
                                  child: Text("minutes"),
                                )
                              ],
                            ) ,
                          )

                      ),
                      Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child:Column(
                              children: <Widget>[
                                Text(
                                  "Cook Time",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Center(
                                  child: Text(
                                      recipe.cooktime
                                  ),
                                ),
                                Center(
                                  child: Text("minutes"),
                                )
                              ],
                            ) ,
                          )

                      ),
                      Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child:Column(
                              children: <Widget>[
                                Text(
                                  "Total Time",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Center(
                                  child: Text(
                                      recipe.totaltime
                                  ),
                                ),
                                Center(
                                  child: Text("minutes"),
                                )
                              ],
                            ) ,
                          )
                      ),
                    ]
                ),

              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Serving Size: ${recipe.serving}"),
                RaisedButton(
                  child: Text("Cook it!"),
                  color: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  onPressed: (){
                    timestamp=dateTime();
                    addToNutrition(timestamp);
                    addToLog(recipe.id, recipe.name, timestamp, userID);
                  },
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              title:Text("Ingredients") ,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child:Row(
                        children: <Widget>[
                          SizedBox(width: 20,),
                          Icon(Icons.label_important, size: 15,),
                          SizedBox(width: 10,),
                          Flexible(
                              child: Text(ingredientList[index])
                          )
                        ],
                      ) ,
                    )

                  ],
                );
              },
              childCount: ingredientList.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Directions",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index){
                return Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Step ${index+1}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child:Row(
                              children: <Widget>[
                                Flexible(
                                    child: Text(
                                      instructionList[index],
                                      style: TextStyle(
                                          height: 1.5,
                                          fontWeight: FontWeight.w400
                                      ) ,
                                    )
                                )
                              ],
                            ) ,
                          )

                        ],
                      ) ,
                    )

                );
              },
              childCount: instructionList.length,
            ),
          ),


        ],
      ),
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
      );
}