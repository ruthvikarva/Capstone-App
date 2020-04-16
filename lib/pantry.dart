import 'package:capstoneapp/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'items.dart';

class PantryPage extends StatelessWidget {
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

class _IngredientsPageState extends State<IngredientsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _textEditingController = new TextEditingController();

  List<Item> items = [];

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

  _onDeleteItemPressed(item) async {
    final db = Firestore.instance;
    //await db.collection('inventory').delete({'title': _textEditingController.text});
    items.removeAt(item);
    setState(() {});
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
      body: new Container(
        child: new ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                '${items[index].title}',
              ),
              trailing: new IconButton(
                icon: new Icon(Icons.delete),
                onPressed: () {
                  _onDeleteItemPressed(index);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onAddItemPressed,
        tooltip: 'Add item',
        child: new Icon(Icons.add),
      ),
    );
  }
}
