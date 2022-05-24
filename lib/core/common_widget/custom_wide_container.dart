import 'package:flutter/material.dart';



class CustomWideContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final double radius;
  final Color containerColor;
  final Function onTap;

  const CustomWideContainer({
    Key? key,
    required this.child,
    required this.height,
    required this.width,
    required this.radius,
    required this.containerColor,
    required this.onTap,
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
          color: containerColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    );
  }
}
