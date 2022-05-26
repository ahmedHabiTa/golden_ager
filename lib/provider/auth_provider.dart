import 'dart:io';

import 'package:golden_ager/models/medicine.dart';
import 'package:golden_ager/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/util/shared_prefs_helper.dart';
import 'package:golden_ager/features/home/presentaion/splash_screen.dart';
import '../features/home/presentaion/tabs_screen.dart';

class AuthProvider extends ChangeNotifier implements ReassembleHandler {
  User? _firebasecurrentUser;
  User? get firebasecurrentUser => _firebasecurrentUser;

  Patient? _patient;
  Patient? get patient => _patient;
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _firebasecurrentUser = FirebaseAuth.instance.currentUser!;
      getUserData();
      final userUUID = _firebasecurrentUser!.uid.toString();
      await SharedPrefsHelper.saveData(key: 'userUUID', value: userUUID);
      Constant.navigateToRep(routeName: const TabsScreen(), context: context);
    } on FirebaseAuthException catch (error) {
      Constant.showToast(
        message: error.message.toString(),
        color: Colors.red,
      );
    }
    notifyListeners();
  }

  Future<void> getUserData() async {
    final userUUID = FirebaseAuth.instance.currentUser!.uid.toString();
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .get();
    if (userData.data() != null) {
      if (userData.data()!['user_type'] == 'patient') {
        _patient = Patient.fromMap(userData.data()!);
      }
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
    } on PlatformException {
      print('failed to pick image');
    }
    notifyListeners();
  }

  bool isLoadingSignUp = false;

  toggleLoading() {
    isLoadingSignUp = !isLoadingSignUp;
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
    if (image == null) {
      Constant.showToast(
        message: 'Please select an image',
        color: Colors.red,
      );
    } else {
      try {
        toggleLoading();
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final userUUID = FirebaseAuth.instance.currentUser!.uid.toString();
        await SharedPrefsHelper.saveData(key: 'userUUID', value: userUUID);
        String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance.ref().child(imageFileName);
        UploadTask uploadTask = ref.putFile(image!);
        await uploadTask.then((res) async {
          await res.ref.getDownloadURL().then((url) {
            imageUrl = url;
          });
        });
        print(userUUID);
        await FirebaseFirestore.instance.collection('users').doc(userUUID).set({
          "image": imageUrl,
          "age": age,
          "description": desc,
          "email": email,
          "feeling": '',
          "gender": gender,
          "name": name,
          "phone": phone,
          'user_type': userType,
          "notification": [],
          'reports': [],
          'medicine': [],
          'doctors': []
        });
        Constant.navigateToRep(routeName: const TabsScreen(), context: context);
      } on FirebaseAuthException catch (error) {
        Constant.showToast(
          message: error.message.toString(),
          color: Colors.red,
        );
      }
    }

    toggleLoading();
  }

  Future<void> logOut(context) async {
    await FirebaseAuth.instance.signOut();
    Constant.navigateToRep(routeName: const SplashScreen(), context: context);
    notifyListeners();
  }

  bool isLoadingAddMedicine = false;
  toggleAddMedicineLoading() {
    isLoadingAddMedicine = !isLoadingAddMedicine;
    notifyListeners();
  }

  Future<bool> addMedicine(
      {required String name,
      required String pillDosage,
      required int shape,
      required int color,
      required int dose,
      required DateTime startAt,
      required DateTime endAt}) async {
    toggleAddMedicineLoading();
    await FirebaseFirestore.instance
        .doc('users/${_firebasecurrentUser!.uid}')
        .get();
    final Medicine medicine = Medicine(
        name: name,
        pillDosage: pillDosage,
        shape: shape,
        color: color,
        dose: dose,
        startAt: startAt,
        endAt: endAt);
    Map<String, Map<String, bool>> isDone = {};
    final int hours = 24 ~/ medicine.dose;
    int condition = medicine.endAt.difference(medicine.startAt).inDays;
    for (var i = 0; i < condition; i++) {
      isDone[DateFormat('yMd')
          .format(medicine.startAt.add(Duration(days: i)))] = {};
      for (var j = 0; j < medicine.dose; j++) {
        isDone[DateFormat('yMd')
                .format(medicine.startAt.add(Duration(days: i)))]!
            .addAll({(hours * j).toString(): false});
      }
    }
    medicine.isDone = isDone;
    _patient!.medicines.add(medicine);
    await updateUserData();
    toggleAddMedicineLoading();
    return true;
  }

  void toggleTakeMedicine(Medicine medicine, String key) {
    patient!.medicines[patient!.medicines.indexOf(medicine)]
        .isDone![DateFormat('yMd').format(DateTime.now())]![key] = true;
    getTodayActivity();
    updateUserData();
  }

  List<Medicine> displayMedcines = [];
  DateTime selectedDate = DateTime.now();
  void getDisplayMedcines(DateTime date) {
    selectedDate = date;
    notifyListeners();
    displayMedcines = patient!.medicines
        .where((element) =>
            element.startAt.isBefore(date) && element.endAt.isAfter(date))
        .toList();
  }

  List todayActivity = [1, 1, 1];
  void getTodayActivity() {
    int max = 0;
    int done = 0;
    int doneForOneMedicine = 0;
    displayMedcines = patient!.medicines
        .where((element) =>
            element.startAt.isBefore(DateTime.now()) &&
            element.endAt.isAfter(DateTime.now()))
        .toList();
    for (Medicine medicine in displayMedcines) {
      final int hours = 24 ~/ medicine.dose;
      int condition = medicine.endAt.difference(medicine.startAt).inDays;
      max++;
      for (var j = 0; j < medicine.dose; j++) {
        if (medicine.isDone![DateFormat('yMd').format(DateTime.now())]![
            (hours * j).toString()] as bool) {
          doneForOneMedicine++;
        }
      }
      if (doneForOneMedicine == medicine.dose) {
        done++;
      }
      doneForOneMedicine = 0;
    }
    todayActivity = [done / max, done, max];
    notifyListeners();
  }

  Future<void> updateUserData() async {
    await FirebaseFirestore.instance
        .doc('users/${_firebasecurrentUser!.uid}')
        .update(_patient!.toMap());
  }

  @override
  void reassemble() {}
}
