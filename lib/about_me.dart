import 'package:flutter/material.dart';
import 'edit_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AboutMe extends StatefulWidget{
  AboutMe({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AboutMe();
  }
}

class _AboutMe extends State<AboutMe> {
  final db= Firestore.instance;
  String id;
  var allergies;
  var diets;
  var userName;

  void initState(){
    userid();
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
              /*
              new FutureBuilder<String>(
                future: _userDetails(), // async work
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                    Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Result: ${snapshot.data}'),
                    )
                  ];
                }
                  else {
                    children = <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                      ),
                    );
                },
              )
              */
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
                  var len=snapshot.data['diet'].length;
                  diets= new List(len);
                  for(int i=0; i<len; i++){
                    print('${dietTest[i]}');
                    diets[i]=dietTest[i];
                    print(diets[i]);
                  }
                  //var len=snapshot.data.documents[1]['allergies'].length;
                  //List<dynamic> m=snapshot.data.documents[1]['allergies'];
                  return Column(
                    children: <Widget>[
                      Text('Result: ${snapshot.data['diet']}'),
                      //Text('${dietTest[0]}'),
                      //Text(len.toString())
                      //Text(len.toString()),
                      //Text(m[0])
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
                        builder: (context)=>EditInfo(
                          userid: id,
                          curName: userName,
                          curAllergies: allergies,
                          curDiets: diets
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


  void userid() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      id=user.uid;
    });
  }

}

/*
Future<String> _userDetails() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  final String uid = user.uid;
  return uid;
}
*/
Text allergies(){
  StreamBuilder(
    stream: Firestore.instance
        .collection('users')
        .snapshots(),
    builder: (context, snapshot){
      if(!snapshot.hasData) return Text('Loading data..');

      return Column(
        children: <Widget>[
          Text('Result: ${snapshot.data.documents[3]['allergies']}')
        ],
      );
    },
  );


}


