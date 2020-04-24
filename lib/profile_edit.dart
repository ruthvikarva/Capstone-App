import 'package:capstoneapp/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class ProfileEdit extends StatefulWidget {
  String userid;
  String curName;
  List<dynamic> curAllergies;
  List<String> curDiets;

  ProfileEdit({this.userid,
    this.curName,
    this.curAllergies,
    this.curDiets});

  @override
  _ProfileEditState createState() => _ProfileEditState(userid, curName, curAllergies, curDiets);
}

class _ProfileEditState extends State<ProfileEdit> {
  String id;
  //The current variables
  String curName;
  List curAllergies;
  List curDiets; //has to change to a String because it needs a radial button
  int curCalories;

  //The variables where the new values will be stored
  //MISSING CALORIES
  String newName;
  String newDiet;
  List<String> newAllergies=List<String>();

  //Variables used to check if the user changed any values in form
  bool nameChange=false;
  bool dietChange=false;
  bool allergyChange=false;
  bool calorieChange=false;

  _ProfileEditState(this.id, this.curName, this.curAllergies, this.curDiets);

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
        allergies[curAllergies[i]] = true;
        value.add(curAllergies[i]);
      }
    }
    return value;
  }

  bool validate=true;
  final GlobalKey<FormBuilderState> _formKey= GlobalKey<FormBuilderState>();

  Future<void> updateNameDiet(Map<String, String> data) async{
    return Firestore.instance
        .collection('users')
        .document(id)
        .updateData(data);
  }
  Future<void> updateAllergy(Map<String, List<String>> data) async{
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
      initialValue: "2000", //Name of the user obtained when signing up
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
        curCalories=int.parse(value);
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
      initialValue: curDiets[0], //has to just be changed to curDiets not an array
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
        newDiet=active;
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
        print(active);
        setState(() {
          calorieChange=true;
        });
      },
      onSaved: (active){
        for (int i=0; i<active.length; i++){
          print("SAVED---------------");
          print(active[i]);
          print(active.runtimeType);
          newAllergies.add(active[i]);
        }
        allergyChange=true;

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("CURRENT DIET");
    print(curDiets);
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
                  child: Text("Submit"),
                  color: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    if(_formKey.currentState.saveAndValidate()){
                      _formKey.currentState.value;
                      if(nameChange){
                        updateNameDiet({'name': newName});
                      }
                      if(dietChange){
                        updateNameDiet({'diet': newDiet});
                      }
                      if(allergyChange){
                        print(newAllergies);
                        updateAllergy({'allergies': newAllergies});
                      }
                      //WILL NEED TO CREATE AN IF STATEMENT FOR THE CALORIES
                      Navigator.push(context,
                         MaterialPageRoute(
                           builder: (context)=> ProfilePage()
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
