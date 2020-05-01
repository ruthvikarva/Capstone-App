import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {

  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType{
  login,
  register
}

class _LoginPageState extends State<LoginPage> {

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _name;
  String _calGoal;
  FormType _formType = FormType.login;

  final db = Firestore.instance;


  bool validateSafe(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
}

void validateAndSubmit() async{
    if(validateSafe()) {
      try {
        if(_formType == FormType.login) {
          String userId = await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
      }
        else {
          String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
          
          await db.collection('users').document(userId).updateData({"name": _name});
          
          print('Signed in: $userId');
        }
        widget.onSignedIn();
      }
      catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Capstone App'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: SingleChildScrollView(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons()
            ),
          )
        )
      )
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [new TextFormField(
        decoration: new InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            contentPadding: const EdgeInsets.all(20.0)
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
        SizedBox(height: 10),
        new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              contentPadding: const EdgeInsets.all(20.0)
          ),
          obscureText: true,
          validator: (value) =>
          value.isEmpty
              ? 'Password can\'t be empty'
              : null,
          onSaved: (value) => _password = value,
        ),
      ];
    }

    if (_formType == FormType.register) {
      return [
        new TextFormField(
          decoration: new InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
          onSaved: (value) => _name = value,
        ),
        SizedBox(height: 10),
        new TextFormField(
          decoration: new InputDecoration(
            labelText: 'Calorie Goal',
            prefixIcon: Icon(Icons.fastfood),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          validator: (value) =>
          value.isEmpty
              ? 'Calorie Goal can\'t be empty'
              : null,
          onSaved: (value) => _calGoal = value,
        ),
        SizedBox(height: 10),
        new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              contentPadding: const EdgeInsets.all(20.0)
          ),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        SizedBox(height: 10),
        new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              contentPadding: const EdgeInsets.all(20.0)
          ),
          obscureText: true,
          validator: (value) =>
          value.isEmpty
              ? 'Password can\'t be empty'
              : null,
          onSaved: (value) => _password = value,
        ),
      ];
    }
  }


  List<Widget> buildSubmitButtons(){
    if(_formType == FormType.login){
      return [
        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
          color: Color.fromRGBO(30, 176, 254, 100),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: Color.fromRGBO(30, 176, 254, 100))
          )
        ),
        new FlatButton(
          child: new Text('Create an account', style: new TextStyle(fontSize: 15.0)),
          onPressed: moveToRegister,
        )
      ];
    }
    else{
      return [
        new RaisedButton(
          child: new Text('Create an Account', style: new TextStyle(fontSize: 20.0)),
          onPressed://() async {
            // ignore: unnecessary_statements
            validateAndSubmit,
            //await db
/*                .collection('users')
                .add({'Name': _name,
              'calories': _calGoal});
          },*/
          color: Color.fromRGBO(30, 176, 254, 100),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: Color.fromRGBO(30, 176, 254, 100))
          ),
        ),
        new FlatButton(
          child: new Text('Have an account? Login', style: new TextStyle(fontSize: 15.0)),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}


