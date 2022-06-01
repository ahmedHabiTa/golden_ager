import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';

class ReportFormField extends StatefulWidget {
  final String? hintText;
  final String? initialValue;
  final String? labelText;
  final bool security;
  final double? width;
  final double? height;
  final TextInputType inputType;
  final String? validation;
  final String? Function(String?)? validationFunction;
  final Function(dynamic)? saved;
  final int maxLine;
  final Widget? prefix;
  final Widget? suffix;
  final bool suffixBool;
  final Function(String)? onChanged;
  final int? number;
  final TextEditingController? controller;
  final EdgeInsets? contentPadding;
  final Color? backgroundColor;
  final bool? readOnly;

  const ReportFormField(
      {Key? key,
        required this.hintText,
        this.initialValue,
        this.labelText,
        this.validationFunction,
        this.width,
        this.height,
        this.security = false,
        this.controller,
        this.inputType = TextInputType.text,
        this.validation = 'this field is required',
        this.saved,
        this.maxLine = 1,
        this.prefix,
        this.suffixBool = false,
        this.suffix,
        this.onChanged,
        this.contentPadding,
        this.backgroundColor,
        this.readOnly,
        this.number = 0})
      : super(key: key);

  @override
  State<ReportFormField> createState() => _ReportFormFieldState();
}

class _ReportFormFieldState extends State<ReportFormField> {
  bool security = true;

  @override
  void initState() {
    super.initState();
    security = widget.security;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   color:widget.backgroundColor ?? Colors.white,
      //   borderRadius: BorderRadius.circular(20),
      // ),
      padding: const EdgeInsets.symmetric(vertical: 4),
      //  height: widget.height ?? MediaQuery.of(context).size.height * 0.1,
      child: TextFormField(
        readOnly: widget.readOnly ?? false,
        initialValue: widget.initialValue,
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: const TextStyle(color:  Constant.primaryDarkColor),
        decoration: InputDecoration(
          labelText: widget.labelText,
          prefixIcon: widget.prefix,
          suffixIcon: widget.suffixBool
              ? IconButton(
              onPressed: () {
                setState(() {
                  security = !security;
                });
              },
              icon: const Icon(Icons.remove_red_eye, color: Colors.black))
              : null,
          contentPadding: widget.contentPadding,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontSize: 15,
            color: Color(0xFF4a4a4a),
          ),
          enabledBorder: OutlineInputBorder(

            borderSide: const BorderSide(
              color: Constant.primaryDarkColor,
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color:  Constant.primaryDarkColor,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color:  Constant.primaryDarkColor,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
        ),
        validator: widget.validationFunction ??
                (value) {
              if (value!.isEmpty || value.length < widget.number!) {
                return widget.validation;
              }
              return null;
            },
        onSaved: widget.saved,
        onFieldSubmitted: widget.saved,
        obscureText: security,
        maxLines: widget.maxLine,
        keyboardType: widget.inputType,
      ),
    );
  }
}
