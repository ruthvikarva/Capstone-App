import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditInfo extends StatefulWidget {
  String userid;
  String curName;
  List<dynamic> curAllergies;
  List<dynamic> curDiets;

  EditInfo({this.userid,
            this.curName,
            this.curAllergies,
            this.curDiets});
  @override
  _EditInfoState createState() =>_EditInfoState(userid, curName, curAllergies, curDiets);

}

class _EditInfoState extends State<EditInfo> {
  String id;
  String curName;
  List<dynamic> curAllergies;
  List<dynamic> curDiets;
  String name;
  bool nameChange=false;

  _EditInfoState(this.id, this.curName, this.curAllergies, this.curDiets);


  Map<String, bool> allergies={
    "None": false,
    "Eggs": false,
     "Milk": false,
    "Peanuts": false,
    "Seafood": false,
     "Soy": false,
     "Tree Nuts": false,
     "Wheat": false
  };

  bool validate=true;
  final GlobalKey<FormBuilderState> _formKey= GlobalKey<FormBuilderState>();


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
          name=value;
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
    );
  }


  Widget _buildDiet(){
    return FormBuilderCheckboxList(
      decoration: InputDecoration(
          labelText: "Dietary Preferences"
      ),
      attribute: "diets",
      initialValue: ["None"],
      options: [
        FormBuilderFieldOption(value: "None", ),
        FormBuilderFieldOption(value: "Vegan"),
        FormBuilderFieldOption(value: "Vegetarian"),
        FormBuilderFieldOption(value: "Non-Vegetarian",)
      ],
      onChanged: (active){
        print(active);
      },
    );
  }

  Widget _buildAllergies(){
    return FormBuilderCheckboxList(
      decoration: InputDecoration(
          labelText: "Allergies"
      ),
      attribute: "allergies",
      initialValue: ['None'],
      options: [
        FormBuilderFieldOption(value: "None"),
        FormBuilderFieldOption(value: "Eggs"),
        FormBuilderFieldOption(value: "Milk"),
        FormBuilderFieldOption(value: "Peanuts"),
        FormBuilderFieldOption(value: "Seafood"),
        FormBuilderFieldOption(value: "Soy"),
        FormBuilderFieldOption(value: "Tree Nuts"),
        FormBuilderFieldOption(value: "Wheat"),
      ],
      onChanged: (active){
        print(active);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    print(curName);
    print(curDiets);
    print(curAllergies);
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
                  onPressed: () {
                    if(_formKey.currentState.saveAndValidate()){
                      _formKey.currentState.value;
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

List<String> gAllergies(){
  StreamBuilder(
    stream: Firestore.instance
        .collection('users')
        .snapshots(),
    builder: (context, snapshot){
      if(!snapshot.hasData) return Text('Loading data..');
      return Column(
        children: <Widget>[
          Text('Result: ${snapshot.data.documents[3]['allergies']}')
        ],
      );
    },
  );
}


