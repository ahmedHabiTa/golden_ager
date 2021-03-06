import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constant {
  static const Color primaryColor = Color(0xFF10519A);

  static const Color primaryDarkColor = Color(0xFF0D2137);
  static const Color accentColor = Color(0xFF00B4D8);
  static const Color accentColorLight = Color(0xffDAE8F7);

  static Color fontGraylight = const Color(0xFF989a9e);
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
      borderRadius: BorderRadius.circular(12.0),
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

  static Future<void> navigateTo({
    required var routeName,
    required BuildContext context,
  }) async {
    await Navigator.push(
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

  static CircularProgressIndicator indicator({Color color = primaryColor}) =>
      CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color));

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
  static TextStyle bodyText3 = TextStyle(
      fontSize: 14,
      fontFamily: "Quicksand",
      color: Colors.black,
      fontWeight: FontWeight.w300);

  static TextStyle bodyText2 = TextStyle(
      fontSize: 16,
      fontFamily: "Quicksand",
      color: Colors.black,
      fontWeight: FontWeight.normal);

  static const kPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
  static const kPadding2 = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const kPaddingGridView = EdgeInsets.all(8);
  static const kPaddingListTile =
      EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const kPaddingListTile2 =
      EdgeInsets.symmetric(horizontal: 16, vertical: 4);
  static const kMargin = EdgeInsets.symmetric(vertical: 2);
  static const kMargin4 = EdgeInsets.symmetric(vertical: 4);
  static const kMargin8 = EdgeInsets.symmetric(vertical: 8);
  static const kMargin12 = EdgeInsets.symmetric(vertical: 12);
  static const kMargin16 = EdgeInsets.symmetric(vertical: 16);
}
