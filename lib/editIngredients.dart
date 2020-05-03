import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditIngredients extends StatefulWidget {
  @override
  _EditIngedientsState createState() => _EditIngedientsState();
}

class _EditIngedientsState extends State<EditIngredients> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  final db = Firestore.instance;
  String currentUser;
  bool alreadyExists;

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
        appBar: AppBar(title: Text('Enter Pantry')),
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
                color: Colors.redAccent,
                onPressed: () => _onAdd(_controller, _controller2),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
    );
  }
}

_onAdd(TextEditingController _controller, TextEditingController _controller2) async {
  final db = Firestore.instance;
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String currentUser = user.uid;

  int quantity = int.parse(_controller2.text);

  List<DocumentSnapshot> templist;
  List<dynamic> list = new List();
  List<dynamic> documentList = new List();
  CollectionReference collectionRef = Firestore.instance.collection(
      "inventory");
  QuerySnapshot collectionSnapshot = await collectionRef.where(
      "UserId", isEqualTo: currentUser).getDocuments();

  templist = collectionSnapshot.documents; // <--- ERROR
  list = templist.map((DocumentSnapshot docSnapshot) {
    return docSnapshot.data['Name'];
  }).toList();


  String ingName = _controller.text;


  if(list.contains(ingName)){
    //----------------------- UPDATE QUANTITY -----------------------//
    QuerySnapshot qSnapshot = await Firestore.instance.collection("inventory")
        .where("UserId", isEqualTo: currentUser)
        .where("Name", isEqualTo: ingName)
        .getDocuments();

    documentList = qSnapshot.documents.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.documentID;
    }).toList();

    await db.collection('inventory').document(documentList[0]).updateData(
        {'Quantity': FieldValue.increment(quantity)});
  }

  else{
    //------------------ ADDS TO THE DATABASE ------------------//
    await db.collection('inventory').add({'Name': _controller.text,
      'Quantity': quantity,
      'UserId': currentUser});
  }
      _controller.clear();
      _controller2.clear();
}