import 'package:capstoneapp/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'items.dart';

class PantryPageTesting extends StatelessWidget {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantry',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: IngredientsPage(),
    );
  }
}

class IngredientsPage extends StatefulWidget {
  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

Future navigateToHome(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
}

final db = Firestore.instance;
String currentUser;
bool alreadyExists;

class _IngredientsPageState extends State<IngredientsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController = new TextEditingController();

  List<Item> items = [];


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

  _onAddItemPressed() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Container(
        //decoration: new BoxDecoration(color: Colors.blueGrey),
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 50.0, 32.0, 32.0),
          child: new TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Please enter an item',
            ),
            onSubmitted: _onSubmit,
          ),
        ),

      );
    });
  }

  _onSubmit(String s) async {
    final db = Firestore.instance;
    await db.collection('inventory').add({'title': _textEditingController.text});
    if (s.isNotEmpty) {
      items.add(Item(s));
      _textEditingController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Pantry'),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            navigateToHome(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 0.0),
          StreamBuilder<QuerySnapshot> (
              stream: db.collection('inventory')
                  .where("UserId", isEqualTo: currentUser)
                  .snapshots(),
              // ignore: missing_return
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data != null) {
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
                else if (snapshot.hasError) {
                  const Text('Data Error');
                }
                else {
                  return SizedBox();
                }
              }),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onAddItemPressed,
        tooltip: 'Add item',
        child: new Icon(Icons.add),
      ),
    );
  }
}
