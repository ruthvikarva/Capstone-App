import 'package:flutter/material.dart';

class EditIngredients extends StatefulWidget {
  @override
  _EditIngedientsState createState() => _EditIngedientsState();
}

class _EditIngedientsState extends State<EditIngredients> {
  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit the Ingridents"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        margin: EdgeInsets.all(24),
      ),
    );
  }
}
