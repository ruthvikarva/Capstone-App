import 'package:cloud_firestore/cloud_firestore.dart';

class UserCollection{
  final String  uid;
  UserCollection({this.uid});
  final users=Firestore.instance.collection("users");

  Future intializeProfile(String name, List<String>allergy, List<String> diet ) async{
    return await users.document(uid).setData({
      'name': name,
      'allergies':allergy,
      'diet': diet
    });
  }


}
