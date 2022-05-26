import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';

class CustomDropDownFormField extends StatelessWidget {
  final String title;
  final List<DropdownMenuItem<String>> items;
  final Function(String)? onChanged;
  final double? iconSize;
  final Widget? prefixIcon;
  const CustomDropDownFormField({
    Key? key,
    required this.title,
    required this.items,
    this.prefixIcon,
    this.onChanged,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 60,
      child: DropdownButtonFormField<String>(
        alignment: Alignment.center,
        iconSize: iconSize ?? 0,
        onTap: () => FocusScope.of(context).unfocus(),
        validator: (value) {
          return null;
        },
        // isExpanded: true,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: Constant.primaryColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: Constant.primaryColor,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: Constant.primaryColor,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            //hintText: title,
            prefixIcon: prefixIcon,
            hintText: title,
            iconColor: Constant.primaryDarkColor,
            hintStyle: Constant.normalTextStyle),
        items: items,
        onSaved: (value) {},
        onChanged: (value) => onChanged!(value!),
      ),
    );
  }
}
