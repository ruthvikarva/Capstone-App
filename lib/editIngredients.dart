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


  List<DocumentSnapshot> templist;
  List<dynamic> list = new List();
  CollectionReference collectionRef = Firestore.instance.collection("inventory");
  QuerySnapshot collectionSnapshot = await collectionRef.where("UserId", isEqualTo: currentUser).getDocuments();

  templist = collectionSnapshot.documents; // <--- ERROR
  list = templist.map((DocumentSnapshot docSnapshot){
    return docSnapshot.data['Name'];
  }).toList();

  print(list);
  print("TEST--------------------");

  String ingName = _controller.text;
  int quant;
  quant = int.parse(_controller2.text);



  for(int y=0; y<list.length;y++){
    //RegExp exp = new RegExp("\b(\w*"+list[y]+"\w*)\b");
    //print(list[y]);
    if(ingName == list[y]){
      QuerySnapshot qSnapshot = await Firestore.instance.collection("inventory")
          .where("UserId", isEqualTo: currentUser)
          .where("Name", isEqualTo: _controller.text)
          .getDocuments();
      var ulist = qSnapshot.documents;
      print("TEST--------------------");
      print(ulist);

      /*await db
          .collection('inventory')
          .where('UserId', isEqualTo: currentUser)
          .where('Name', isEqualTo: _controller.text)
          .updateData({'Quantity': FieldValue.increment(1.0)});*/
    }
      print('MATCHES');
  }


  await db.collection('inventory').add({'Name': _controller.text,
    'Quantity': _controller2.text,
    'UserId': currentUser});
  
  DocumentSnapshot _currentDocument;

  var yourRef = db.collection('inventory')
      .where('UserId', isEqualTo: currentUser)
      .where('name', isEqualTo: _controller);

  if(yourRef != null){
    //await db.collection('inventory').document(_currentDocument.documentID).updateData({'Name': "AM I Working"});
  }


      //\b(\w*word\w*)\b



  _controller.clear();
  _controller2.clear();

    }









/*  if (s.isNotEmpty) {
    items.add(Item(s));
    _textEditingController.clear();
    setState(() {});
  }*/


