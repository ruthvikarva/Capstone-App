
import 'package:flutter/material.dart';
import 'profile_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileAboutMe extends StatefulWidget {
  @override
  _ProfileAboutMeState createState() => _ProfileAboutMeState();
}

class _ProfileAboutMeState extends State<ProfileAboutMe> {
  final db= Firestore.instance;
  //Variables sent to the EDIT INFO screen---------------
  String id;
  String name;
  List<String> diet=new List(1); //will have to change to string also, we need calories
  var allergy;
  //-----------------------------------------------------
  //Variabes used for streambuilder
  var allergies;
  var diets; //we need to add calories
  var userName;

  void initState(){
    getUser();
    //test();
    //getCollection();
  }


  @override
  Widget build(BuildContext context) {
    print(id);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text("Allergies"),
            children: <Widget>[
              new StreamBuilder(
                stream: Firestore.instance
                    .collection('users').document(id).snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData) return Text('Loading data..');
                  var allergyTest=snapshot.data['allergies'];
                  var len=snapshot.data['allergies'].length;
                  allergies= new List(len);
                  for(int i=0; i<len; i++){
                    print('${allergyTest[i]}');
                    allergies[i]=allergyTest[i];
                    print(allergies[i]);
                  }
                  //var len=snapshot.data.documents[1]['allergies'].length;
                  //List<dynamic> m=snapshot.data.documents[1]['allergies'];
                  return Column(
                      children: <Widget>[
                        Text('Result: ${snapshot.data['allergies']}'),
                        //Text('${allergyTest[0]}'),
                        //Text(len.toString())
                        //Text(len.toString()),
                        //Text(m[0])
                      ]
                  );

                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Diet"),
            children: <Widget>[
              new StreamBuilder(
                stream: Firestore.instance
                    .collection('users').document(id).snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData) return Text('Loading data..');
                  var dietTest=snapshot.data['diet'];
                  diets= new List(1);
                  diets[0]=dietTest;
                  //var len=snapshot.data.documents[1]['allergies'].length;
                  //List<dynamic> m=snapshot.data.documents[1]['allergies'];
                  return Column(
                      children: <Widget>[
                        Text('Result: ${snapshot.data['diet']}'),
                      ]
                  );


                },
              )
            ],
          ),
          ExpansionTile(
            title: Text("Personal Information"),
            children: <Widget>[
              new StreamBuilder(
                stream: Firestore.instance
                    .collection('users').document(id).snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData) return Text('Loading data..');
                  userName=snapshot.data['name'];
                  print(userName);

                  //var len=snapshot.data.documents[1]['allergies'].length;
                  //List<dynamic> m=snapshot.data.documents[1]['allergies'];
                  return Column(
                      children: <Widget>[
                        Text('Result: ${snapshot.data['name']}'),
                        //Text(userName),
                        //Text(len.toString()),
                        //Text(m[0])
                      ]
                  );


                },
              ),

              /*
              new StreamBuilder(
                stream: Firestore.instance
                    .collection('recipe').document(id).snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData) return Text('Loading data..');
                  userName=snapshot.data['name'];
                  print(userName);
                  //var len=snapshot.data.documents[1]['allergies'].length;
                  //List<dynamic> m=snapshot.data.documents[1]['allergies'];
                  return Column(
                      children: <Widget>[
                        Text('Result: ${snapshot.data['name']}'),
                        //Text(userName),
                        //Text(len.toString()),
                        //Text(m[0])
                      ]
                  );
                },
              )
              */


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
                        builder: (context)=>ProfileEdit(
                            userid: id,
                            curName: name,
                            curAllergies: allergy,
                            curDiets: diet
                        )
                    )
                );
              },
            ),
          )


        ],
      ),
    );
  }


  void getUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    id=user.uid;
    setState(() {
      id=user.uid;
    });
    Firestore.instance.collection('users').document(id).get().then((DocumentSnapshot document){
      print("document_build:$document");
      setState(() {
        name=document.data['name'].toString();
        diet[0]=document.data['diet'].toString(); //diet will have to change from an array to a string
        allergy=document.data['allergies'];
      });
      print(name);
      print(diet);
      print(allergy);
    });

  }
/*
  void test() async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("recipe")
        .where("calories", isLessThan: 666).getDocuments();
    var list = querySnapshot.documents;
    print("TEST--------");
    var len=list.length;
    var userList=['arugula', 'Balsamic vinegar', 'olive oil', 'lemon zest', 'Parmesan cheese','Pine nuts'];
    for(int x=0; x<len; x++){
      print(list[x].data['ingredientName']);
      print(list[x].data['name']);
      print(list[x].documentID);
    }
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    QuerySnapshot qSnapshot = await Firestore.instance.collection("inventory")
        .where("UserId", isEqualTo: userId).where("Name", isEqualTo: "Lime").getDocuments();
    var ulist = querySnapshot.documents;
    print("TEST--------------------");
    print(userId);
    print(ulist.runtimeType);
    print(ulist);
    //var map= list[].data['ingredientName'];
  }
    void getCollection() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    List<DocumentSnapshot> templist;
    List<dynamic> list = new List();
    CollectionReference collectionRef = Firestore.instance.collection("inventory");
    QuerySnapshot collectionSnapshot = await collectionRef.where("UserId", isEqualTo: userId).getDocuments();
      QuerySnapshot querySnapshot = await Firestore.instance.collection("recipe")
          .where("calories", isLessThan: 666).getDocuments();
      var recipelist = querySnapshot.documents;
    templist = collectionSnapshot.documents; // <--- ERROR
    list = templist.map((DocumentSnapshot docSnapshot){
      return docSnapshot.data['Name'];
    }).toList();
      print("TEST--------------------------");
      print(list);
      double threshold=.70;
      List<String> filteredList= new List<String>();
      List dummyList=["arugula", "Balsamic vinegar", "Watermelon"];
      for(int x=0; x<recipelist.length; x++){
        int counter=0;
        double similarity=0;
        for(int y=0; y<list.length;y++){
          if(recipelist[x].data["ingredientName"].containsValue(list[y].toString().toLowerCase())){
            print(recipelist[x].data["ingredientName"]);
            print(list[y]);
            print("MATCHES");
            counter=counter+1;
          }
        }
        //\b(\w*word\w*)\b
        print(counter);
        similarity= counter/recipelist[x].data["ingredientName"].length;
        print(similarity);
        if( similarity>=threshold){
          filteredList.add(recipelist[x].documentID);
        }
        //print(recipelist[x].data['ingredientName']);
        //print(recipelist[x].data['name']);
        //print(recipelist[x].documentID);
      }
      print("FILTERED LIST----------------------");
      print(filteredList);
    Firestore.instance.collection('recipe').document(filteredList[0]).get().then((DocumentSnapshot document) {
      print("document_build:$document");
      print(document.data['name'].toString());
      print(document.data['instructions'].values);
    });
  }
*/
}
