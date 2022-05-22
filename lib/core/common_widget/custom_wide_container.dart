import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomWideContainer extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final Color containerColor;
  final Color textColor;
  final Function onTap;

  const CustomWideContainer({
    Key? key,
    required this.title,
    required this.height,
    required this.width,
    required this.containerColor,
    required this.textColor,
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
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: const Color(0xFF003473), width: 1.0),
        ),
        child: Center(
          child: CustomText(
            text: title,
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
