import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/constant/constant.dart';

class HomeProvider extends ChangeNotifier {
  Future<void> changeFeeling(
      {required String feeling,
      required BuildContext context,
      required String userID}) async {
    if (feeling == '') {
      Constant.showToast(
          message: 'Please Tell us about your feeling', color: Colors.green);
    } else {
      await FirebaseFirestore.instance.collection('users').doc(userID).update({
        'feeling': feeling,
      });
    }
    notifyListeners();
  }
}
