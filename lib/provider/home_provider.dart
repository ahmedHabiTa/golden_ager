import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/util/shared_prefs_helper.dart';
import 'package:golden_ager/features/home/presentaion/tabs_screen.dart';

import '../core/constant/constant.dart';

class HomeProvider extends ChangeNotifier {
  Future<void> changeFeeling({
    required String feeling,
    required BuildContext context,
  }) async {
    if (feeling == '') {
      Constant.showToast(
          message: 'Please Tell us about your feeling', color: Colors.green);
    } else {
      final userUUID = SharedPrefsHelper.getData(key: 'userUUID');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUUID)
          .update({
        'feeling': feeling,
      });
      Constant.navigateToRep(routeName: const TabsScreen(), context: context);
    }
    notifyListeners();
  }
}
