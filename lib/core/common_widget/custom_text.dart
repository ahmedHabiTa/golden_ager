import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final Color? color;
  final TextOverflow? textOverflow;
  final int? maxLines ;
  final TextDirection? textDirection;

  const CustomText({
    Key? key,
    required this.text,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.color,
    this.textOverflow,
    this.maxLines,
    this.textDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      textDirection: textDirection,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: 'Tajawal',
        fontSize: fontSize,
        color: color,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
        overflow: textOverflow,
      ),
    );
  }
}