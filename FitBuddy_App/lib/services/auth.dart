import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  void showLoading(context) {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  signInWithEmail(email, pw) async {
    try {
       return await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: pw);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // todo
      } else if (e.code == 'wrong-password') {
        // todo
      }
    }
  }

  registerWithEmail(email, pw) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: pw);
    } on FirebaseAuthException {
      // todo
    }
  }


  void signOutUser() {
    _firebaseAuth.signOut();
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential =  GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }


}