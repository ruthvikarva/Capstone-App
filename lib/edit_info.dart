import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';


class EditInfo extends StatefulWidget {
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  bool validate=true;
  final GlobalKey<FormBuilderState> _formKey= GlobalKey<FormBuilderState>();

  Widget _buildName(){
    return FormBuilderTextField(
      attribute: 'name',
      initialValue: "Name", //Name of the user obtained when signing up
      validators: [FormBuilderValidators.required()],
      decoration: InputDecoration(
        labelText: "Name",
      ),
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
        FormBuilderFieldOption(value: "None"),
        FormBuilderFieldOption(value: "Vegan"),
        FormBuilderFieldOption(value: "Vegetarian")
      ],
    );
  }

  Widget _buildAllergies(){
    return FormBuilderCheckboxList(
      decoration: InputDecoration(
          labelText: "Allergies"
      ),
      attribute: "allergies",
      initialValue: ["None"],
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




