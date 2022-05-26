import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/util/shared_prefs_helper.dart';
import 'package:golden_ager/features/home/presentaion/splash_screen.dart';
import 'package:image_picker/image_picker.dart';

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

  File? image;
  String? imageUrl;

  Future pickImage({
    required ImageSource imageSource,
  }) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;

      final imageTemporary = File(image.path);
      this.image = imageTemporary;
      notifyListeners();
    } on PlatformException catch (e) {
      print('failed to pick image');
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
    if(image == null){
      Constants.showToast(
        message: 'Please select an image',
        color: Colors.red,
      );
    }else{
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final userUUID = FirebaseAuth.instance.currentUser!.uid.toString();
        await SharedPrefsHelper.saveData(key: 'userUUID', value: userUUID);
        String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance.ref().child(imageFileName);
        UploadTask uploadTask = ref.putFile(image!);
       await uploadTask.then((res)async {
          await  res.ref.getDownloadURL().then((url) {
            imageUrl = url;
          });
        });
        print(userUUID);
        await FirebaseFirestore.instance.collection('users').doc(userUUID).set({
          "image":imageUrl,
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
    }
    notifyListeners();
  }

  Future<void> logOut(context) async {
    await FirebaseAuth.instance.signOut();
    Constants.navigateToRep(routeName:const SplashScreen(), context: context);
    notifyListeners();
  }



}
