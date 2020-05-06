import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'editIngredients.dart';

class AddIng extends StatefulWidget {
  @override
  _PantryPageState createState() => _PantryPageState();
}

class _PantryPageState extends State<AddIng>{
  //TextEditingController _controller = TextEditingController();
  //TextEditingController _controller2 = TextEditingController();
  final db = Firestore.instance;
  String currentUser;
  bool alreadyExists;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    super.initState();
  }

  _asyncMethod() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    {
      setState(() {
        currentUser = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
        body: ListView(
          padding: EdgeInsets.all(12.0),
          children: <Widget>[
            SizedBox(height: 0.0),
            StreamBuilder<QuerySnapshot> (
                stream: db.collection('inventory')
                    .where("UserId", isEqualTo: currentUser)
                    //.where('time', isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.documents.map((doc) {
                        return ListTile(
                            title: Text(doc.data['Name']),
                            subtitle: Text(doc.data['Quantity'].toString()),
                            trailing: new IconButton(
                                icon: new Icon(Icons.delete),
                                onPressed: () async {
                                  await db
                                      .collection('inventory')
                                      .document(doc.documentID)
                                      .delete();
                                }
                            )
                        );
                      }).toList(),
                    );
                  }
                  else {
                    return SizedBox();
                  }
                }),
            SizedBox(
              height: 50.0,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("Add"),
          backgroundColor: Colors.redAccent,
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(
                  builder: (context)=>EditIngredients()
                )
            );
          },
        )
    );
  }
}