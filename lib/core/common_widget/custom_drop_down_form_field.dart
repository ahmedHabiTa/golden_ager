import 'package:flutter/material.dart';
import '../../core/constant/constant.dart';

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
      width: Constant.width(context) * 0.9,
      //height: Constants.height(context)*0.13,
      child: DropdownButtonFormField<String>(
        alignment: Alignment.center,
        iconSize: iconSize ?? 0,
        onTap: () => FocusScope.of(context).unfocus(),
        validator: (value) {
          if (value == null) {
            return 'field is required';
          }
          return null;
        },
        // isExpanded: true,
        decoration: InputDecoration(
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
        items: items,
        onSaved: (value) {},
        onChanged: (value) => onChanged!(value!),
      ),
    );
  }
}
