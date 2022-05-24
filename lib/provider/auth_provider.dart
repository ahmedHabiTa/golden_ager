import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:golden_ager/core/util/shared_prefs_helper.dart';
import 'package:golden_ager/features/home/presentaion/splash_screen.dart';

import '../../../../core/constant/constants.dart';
import '../core/constant/constants.dart';
import '../features/home/presentaion/tabs_screen.dart';

class AuthProvider extends ChangeNotifier {
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final userUUID = FirebaseAuth.instance.currentUser!.uid.toString();
      await SharedPrefsHelper.saveData(key: 'userUUID', value: userUUID);
       Constants.navigateToRep(routeName: const TabsScreen(), context: context);
    } on FirebaseAuthException catch (error) {
      Constants.showToast(
        message: error.message.toString(),
        color: Colors.red,
      );
    }
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String age,
    required String desc,
    required String gender,
    required String userType,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final userUUID = FirebaseAuth.instance.currentUser!.uid.toString();
      await SharedPrefsHelper.saveData(key: 'userUUID', value: userUUID);
      print(userUUID);
      await FirebaseFirestore.instance.collection('users').doc(userUUID).set({
        "age": age,
        "description" : desc,
        "email" : email,
        "feeling" : '',
        "gender" : gender,
        "name" : name,
        "notification" : [],
        "phone": phone,
        'reports' : [],
        'user_type':userType,
      });
       Constants.navigateToRep(routeName: const TabsScreen(), context: context);
    } on FirebaseAuthException catch (error) {
      Constants.showToast(
        message: error.message.toString(),
        color: Colors.red,
      );
    }
    notifyListeners();
  }

  Future<void> logOut(context) async {
    await FirebaseAuth.instance.signOut();
    Constants.navigateToRep(routeName:const SplashScreen(), context: context);
    notifyListeners();
  }
}
