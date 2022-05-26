import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:golden_ager/core/constant/constant.dart';
=======
import 'package:golden_ager/core/constant/constants.dart';
>>>>>>> 2a33480485c5115cb74505fdbb1f7f7a29cf24d2

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
<<<<<<< HEAD
      width: double.infinity,
      height: 60,
=======
      width: Constants.width(context)*0.9,
      //height: Constants.height(context)*0.13,
>>>>>>> 2a33480485c5115cb74505fdbb1f7f7a29cf24d2
      child: DropdownButtonFormField<String>(
        alignment: Alignment.center,
        iconSize: iconSize ?? 0,
        onTap: () => FocusScope.of(context).unfocus(),
        validator: (value) {
          if(value == null){
            return 'field is required';
          }
        },
        // isExpanded: true,
        decoration: InputDecoration(
<<<<<<< HEAD
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
=======
          filled: true,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: const BorderSide(
          //     color: Color(0xFF262D34),
          //     width: 2.0,
          //   ),
          // ),
          //hintText: title,
          labelText: title,
          iconColor: Colors.black87,
          labelStyle: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
>>>>>>> 2a33480485c5115cb74505fdbb1f7f7a29cf24d2
        items: items,
        onSaved: (value) {},
        onChanged: (value) => onChanged!(value!),
      ),
    );
  }
}
