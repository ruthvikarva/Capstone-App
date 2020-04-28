import 'package:firebase_auth/firebase_auth.dart';
import 'userProfile.dart';
import 'dart:async';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth{
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;

    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user;
    //Create a new document for the user with a uid
    await UserCollection(uid: user.uid).intializeProfile(
        [],
        'None');
    return user.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = (await FirebaseAuth.instance.currentUser());
    return user.uid;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

