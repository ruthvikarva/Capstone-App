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
  }



  @override
  Widget build(BuildContext context) {
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
              )
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

}




