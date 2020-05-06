import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeDetails extends StatefulWidget {
  final RecipeOverview recipe;
  List inventory;
  RecipeDetails(this.recipe, this.inventory);
  @override
  _RecipeDetailsState createState() => _RecipeDetailsState(this.recipe, this.inventory);
}

class _RecipeDetailsState extends State<RecipeDetails> {
  RecipeOverview recipe;
  List inventory;
  _RecipeDetailsState(this.recipe, this.inventory);
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

  Future<void> decrementIngred(String recipeID, List ingredName, List quant) async {
    final db = Firestore.instance;
    QuerySnapshot qSnapshot = await Firestore.instance.collection("inventory")
        .where("UserId", isEqualTo: userID)
        .getDocuments();

    var documentList = qSnapshot.documents.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.documentID;
    }).toList();

    print(recipe.quantity);
    //print(documentList[0]);
    //print(inventory[0]);
    print(recipeID);
    //print(int.parse(quant[2]));
    for (int j = 0; j < inventory.length; j++) {
      for (int k = 0; k < ingredName.length; k++) {
        var recipeWord = ingredName[k];
        if ((recipeWord).contains(inventory[j])) {
          print(documentList[j]);
          //int q= int.parse(quant[k]);
          print(quant[k].toString());
          await db.collection('inventory').document(documentList[j]).updateData(
              {'Quantity': FieldValue.increment(-quant[k])});
        }
      }
    }


  }


  Future<void> addToLog(String recipeID, String recipeName, Timestamp time, String userID) async{
    return Firestore.instance.collection('log').add(
        {
          'recipeID':recipeID,
          'recipeName': recipeName,
          'dateTime': time,
          'userID': userID,
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
    List quantity= new List();
    recipe.quantity.forEach((key, value) {
      quantity.add(value);
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
                    decrementIngred(recipe.id, recipe.ingredName, quantity);
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
          SliverToBoxAdapter(

          )
        ],
      ),
    );
  }
}
