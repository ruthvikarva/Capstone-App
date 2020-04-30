import 'package:flutter/cupertino.dart';
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
  String diet;
  var calories;
  var allergy;
  //-----------------------------------------------------
  //Variabes used for streambuilder
  var allergies;
  var diets; //we need to add calories
  var userName;

  void initState(){
    super.initState();
    getUser();
    //test();
    //getCollection();
  }


  @override
  Widget build(BuildContext context) {
    print(id);
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          //Allergies
          ExpansionTile(
            title: Text("Allergies",
              style: TextStyle(
                fontSize: 16
              ),
            ),
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
                  if(len==0){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          title: Text("You have not indicated any allergies."),
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                        ),
                      ],
                    );
                  }
                  else{
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                          child: Text("You have indicated having allergies of:",
                            style: TextStyle(
                              fontSize: 16
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: len,
                          itemBuilder: (context, index){
                            return ListTile(
                              title: Text(allergies[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              dense: true,
                              leading: Icon(Icons.track_changes),
                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                            );
                          },
                        ),
                      ],
                    );
                  }

                },
              ),
            ],
          ),
          //Diet
          ExpansionTile(
            title: Text("Diet"),
            children: <Widget>[
              new StreamBuilder(
                stream: Firestore.instance
                    .collection('users').document(id).snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData) return Text('Loading data..');
                  diet=snapshot.data['diet'];
                  if(diet=="None"){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          title: Text("You have not indicated a specific diet."),
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                        ),
                      ],
                    );

                  }
                  else{
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                          child: Text("You have indicated practicing the following diet:",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.track_changes),
                          title: Text(diet,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                        )
                      ],
                    );
                  }

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

                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            children: <Widget>[
                              Text("Name: "),
                              Text(userName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                        )

                        //Text(userName),
                        //Text(len.toString()),
                        //Text(m[0])
                      ]
                  );


                },
              ),

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
                            curDiet: diet,
                            curCalories: calories,
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
        diet=document.data['diet'].toString(); //diet will have to change from an array to a string
        allergy=document.data['allergies'];
        calories=document.data["calories"];
      });
      print("Name: $name");
      print("Diet: $diet");
      print("Allergy: $allergy");
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





