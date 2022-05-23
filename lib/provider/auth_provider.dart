import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/constant/constants.dart';

class AuthProvider extends ChangeNotifier {
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Constants.navigateToRep(routeName: const TabsScreen(), context: context);
    } on FirebaseAuthException catch (error) {
      Constants.showToast(
        message: error.message.toString(),
        color: Colors.red,
      );
      // print(error);
    }
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      //     .then((value) async {
      //    await SharedPrefsHelper.saveData(key: 'name', value: name);
      //   await SharedPrefsHelper.saveData(key: 'phoneNumber', value: phone);
      //   await SharedPrefsHelper.saveData(key: 'email', value: email);
      //   });
      print(FirebaseAuth.instance.currentUser!.uid.toString());
      await FirebaseFirestore.instance.collection('users').doc().set({
        "name": name,
        "phone": phone,
        "email": email,
      });
      // Constants.navigateToRep(routeName: const TabsScreen(), context: context);
    } on FirebaseAuthException catch (error) {
      print(error);
      // Constants.showToast(message: error.message.toString(), color: Colors.red);
    }
  }
}
