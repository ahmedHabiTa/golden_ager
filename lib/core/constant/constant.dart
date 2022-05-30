import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constant {
  static const Color primaryColor = Color(0xFF10519A);

  static const Color primaryDarkColor = Color(0xFF0D2137);
  static const Color accentColor = Color(0xFF00B4D8);
  static const Color accentColorLight = Color(0xffDAE8F7);
  static List<Color> colorGrediant = const [
    Color(0xFF1E7879),
    Color(0xFF043E49)
  ];
  // font color
  // buttons
  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    primary: primaryColor,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );
  static ButtonStyle getbuttonStyleRounded(Color color) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(color),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

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

  static showToast({required String message, required Color color}) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  static const TextStyle appBarTextStyle = TextStyle(
      color: primaryDarkColor,
      fontSize: 28,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold);

  static const TextStyle headLineTextStyle = TextStyle(
      color: primaryDarkColor,
      fontSize: 28,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold);
  static const TextStyle semieBoldTextStyle = TextStyle(
      color: primaryDarkColor,
      fontSize: 24,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600);
  static const TextStyle mediumTextStyle = TextStyle(
      color: primaryDarkColor,
      fontSize: 20,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500);
  static const TextStyle normalTextStyle = TextStyle(
      color: primaryColor,
      fontSize: 14,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500);
}
