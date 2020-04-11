import 'package:flutter/material.dart';

class EditInfo extends StatefulWidget {
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editing Information"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        margin: EdgeInsets.all(24),
      ),
    );
  }
}
