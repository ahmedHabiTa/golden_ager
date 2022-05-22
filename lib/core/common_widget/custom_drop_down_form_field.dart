import 'package:flutter/material.dart';

class CustomDropDownFormField extends StatelessWidget {
  final String title;
  final List<DropdownMenuItem<String>> items;
  final Function(String)? onChanged;
  final double? iconSize;

  const CustomDropDownFormField({
    Key? key,
    required this.title,
    required this.items,
    this.onChanged,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 200,
      height: 50,
      child: DropdownButtonFormField<String>(
        iconSize: iconSize ?? 0,
        onTap: () => FocusScope.of(context).unfocus(),
        validator: (value) {
          return null;
        },
       // isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF262D34),
              width: 2.0,
            ),
          ),
          //hintText: title,
          labelText: title,
          iconColor: Colors.black87,
          labelStyle: const TextStyle(
            fontSize: 12,
            color: Colors.blue,
          ),
        ),
        items: items,
        onSaved: (value) {},
        onChanged: (value) => onChanged!(value!),
      ),
    );
  }
}
