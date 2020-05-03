import 'package:cloud_firestore/cloud_firestore.dart';

class UserCollection{
  final String  uid;
  UserCollection({this.uid});
  final users=Firestore.instance.collection("users");

  Future intializeProfile(List<String>allergy, String diet ) async{
    return await users.document(uid).setData({
      'allergies':allergy,
      'diet': diet
    });
  }
}