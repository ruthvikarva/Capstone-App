import 'package:capstoneapp/home.dart';
import 'package:capstoneapp/home2.dart';
import 'package:capstoneapp/profile.dart';
import 'package:capstoneapp/testingDB.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class ProfileEdit extends StatefulWidget {
  String userid;
  String curName;
  List<dynamic> curAllergies;
  String curDiet;
  int curCalories;


  ProfileEdit({this.userid,
    this.curName,
    this.curAllergies,
    this.curDiet,
    this.curCalories
  });

  @override
  _ProfileEditState createState() => _ProfileEditState(userid, curName, curAllergies, curDiet, curCalories);
}

class _ProfileEditState extends State<ProfileEdit> {
  String id;
  //The current variables
  String curName;
  List curAllergies;
  String curDiet;
  int curCalories;

  //The variables where the new values will be stored
  int newCalories;
  String newName;
  String newDiet;
  List<String> newAllergies=List<String>();

  //Variables used to check if the user changed any values in form
  bool nameChange=false;
  bool dietChange=false;
  bool allergyChange=false;
  bool calorieChange=false;

  _ProfileEditState(this.id, this.curName, this.curAllergies, this.curDiet, this.curCalories);

  Map<String, bool> allergies={
    "Eggs": false,
    "Milk": false,
    "Peanuts": false,
    "Shellfish": false,
    "Soy": false,
    "Tree Nuts": false,
    "Wheat": false
  };



  List<String> _initial(){
    List<String> value=List<String>();
    for (int i=0; i<curAllergies.length; i++) {
      if (curAllergies[i] != "None") {
        print("Cur: ${curAllergies[i]}");
        //allergies[curAllergies[i]] = true;
        value.add(curAllergies[i]);
      }
    }
    print("Current: $curAllergies");
    return value;
  }

  bool validate=true;
  final GlobalKey<FormBuilderState> _formKey= GlobalKey<FormBuilderState>();

  Future<void> updateNumber(Map<String, int> data) async{
    return Firestore.instance
        .collection('users')
        .document(id)
        .updateData(data);
  }

  Future<void> updateString(Map<String, String> data) async{
    return Firestore.instance
        .collection('users')
        .document(id)
        .updateData(data);
  }
  Future<void> updateList(Map<String, List<String>> data) async{
    return Firestore.instance
        .collection('users')
        .document(id)
        .updateData(data);
  }

  Widget _buildName(){
    return FormBuilderTextField(
      attribute: 'name',
      initialValue: curName, //Name of the user obtained when signing up
      validators: [FormBuilderValidators.required()],
      decoration: InputDecoration(
        labelText: "Name",
      ),
      onChanged: (text){
        //print("First text field: $text");
        setState(() {
          nameChange=true;
        });
      },
      onSaved: (value){
        if (nameChange==true){
          newName=value;
        }
      },
    );
  }



  Widget _buildCalories(){
    return FormBuilderTextField(
      attribute: 'calories',
      initialValue: curCalories.toString(), //Name of the user obtained when signing up
      validators: [
        FormBuilderValidators.min(800),
        FormBuilderValidators.max(3500),
        FormBuilderValidators.numeric()
      ],
      decoration: InputDecoration(
        labelText: "Calorie Goal",
      ),
      onChanged: (value){
        setState(() {
          calorieChange=true;
        });
      },
      onSaved: (value){
        newCalories=int.parse(value);
      },
    );
  }


  Widget _buildDiet(){
    return FormBuilderRadio(
      decoration: InputDecoration(
          labelText: "Dietary Preferences"
      ),
      attribute: "diets",
      leadingInput: true,
      initialValue: curDiet, //has to just be changed to curDiets not an array
      options: [
        FormBuilderFieldOption(value: "None", ),
        FormBuilderFieldOption(value: "Vegan"),
        FormBuilderFieldOption(value: "Vegetarian"),
        FormBuilderFieldOption(value: "Non-Vegetarian",)
      ],
      onChanged: (active){
        print(active);
        setState(() {
          dietChange=true;
        });
      },
      onSaved: (active){
        if(dietChange==true){
          newDiet=active;
        }
      },
    );
  }

  Widget _buildAllergies(){
    return FormBuilderCheckboxList(
      decoration: InputDecoration(
          labelText: "Allergies"
      ),
      initialValue: _initial() ,
      attribute: "allergies",
      leadingInput: true,
      options:[
        FormBuilderFieldOption(value: "Eggs"),
        FormBuilderFieldOption(value: "Milk"),
        FormBuilderFieldOption(value: "Peanuts"),
        FormBuilderFieldOption(value: "Shellfish"),
        FormBuilderFieldOption(value: "Soy"),
        FormBuilderFieldOption(value: "Tree Nuts"),
        FormBuilderFieldOption(value: "Wheat"),
      ],
      onChanged: (active){
        setState(() {
          allergyChange=true;
        });
      },
      onSaved: (active) {
        for (int i=0; i<active.length; i++){
          newAllergies.add(active[i]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Editing Information"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: <Widget>[

                FormBuilder(
                  key: _formKey,
                  autovalidate: true,
                  child:Column(
                    children: <Widget>[
                      _buildName(),
                      _buildCalories(),
                      _buildDiet(),
                      _buildAllergies()
                    ],
                  ),
                ),
                SizedBox(height: 100,),
                RaisedButton(
                  child: Text("Save"),
                  color: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    if(_formKey.currentState.saveAndValidate()){
                      _formKey.currentState.value;
                      if(nameChange){
                        updateString({'name': newName});
                      }
                      if(dietChange){
                        updateString({'diet': newDiet});
                      }
                      if(allergyChange){
                        print(newAllergies);
                        updateList({'allergies': newAllergies});
                      }
                      if(calorieChange){
                        print(newCalories);
                        updateNumber({"calories": newCalories});
                      }


                      Navigator.push((context),
                          MaterialPageRoute(
                              builder: (context)=>HomePage2()
                          )
                      );


                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),


    );
  }
}
