import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomWideButton extends StatelessWidget {
  double height;
  double width;
  Color color;
  Function onTap;
  Widget child;

  CustomWideButton({
    Key? key,
    required this.height,
    required this.width,
    required this.color,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: color,
        ),
        child: child,
      ),
    );
  }
}