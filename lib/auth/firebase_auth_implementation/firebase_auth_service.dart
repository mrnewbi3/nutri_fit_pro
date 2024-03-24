// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpwithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some Error occured");
    }
    return null;
  }
  
  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some Error occured");
    }
    return null;
  }
  
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // ignore: duplicate_ignore
      // ignore: avoid_print
      print("Some Error occured");
    }
  }

}
