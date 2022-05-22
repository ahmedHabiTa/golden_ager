import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constants {
  static double width(context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(context) {
    return MediaQuery.of(context).size.width;
  }

  static void navigateToRep({
    required var routeName,
    required BuildContext context,
  }) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => routeName,
      ),
    );
  }

  static void navigateTo({
    required var routeName,
    required BuildContext context,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => routeName,
      ),
    );
  }

  static showToast({
    required String message,
    required Color color,
  }) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
