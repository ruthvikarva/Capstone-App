import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_info.dart';
import 'login_page.dart';

// ignore: must_be_immutable
class AddDataToFireStore extends StatelessWidget {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  final db = Firestore.instance;
  String currentUser = "dK0URoDBtdQi8m4qFNQzulKe5062";
  String myName = "Ruthvik";

  someMethod() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    print(user.uid);
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Add Data to Firestore")),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Enter Name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: TextField(
              controller: _controller2,
              decoration: InputDecoration(hintText: 'Enter Quantity'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Add'),
              color: Colors.blue,
              onPressed: () async {
                FirebaseUser user = await FirebaseAuth.instance.currentUser();
                currentUser = user.uid;
                await db.collection('inventory').add({'Name': _controller.text,
                  'Quantity': _controller2.text,
                  'UserId': currentUser});

                _controller.clear();
                _controller2.clear();
              },
            ),
          ),
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot> (
              stream: db.collection('inventory')
                  .where("UserId", isEqualTo: someMethod())
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) {
                      return ListTile(
                        title: Text(doc.data['Name']),
                        subtitle: Text(doc.data['Quantity']),
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
        ],
      ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.edit),
          label: Text("Edit"),
          backgroundColor: Colors.redAccent ,
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(
                    //builder: (context)=>EditIngredients()
                )
            );
          },
        )
    );
  }
}

/*
someMethod() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String userId = user.uid;
  print(user.uid);
  return userId;
}

Future<String> getUser() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String userId = user.uid;
  return userId;
}*/

Future<Null> getData() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  var userId = user.uid;
  return userId;
}

/*
class ingredientList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('inventory').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['Name']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
*/