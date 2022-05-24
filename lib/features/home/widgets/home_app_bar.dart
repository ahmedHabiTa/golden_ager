import 'package:flutter/material.dart';
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            //todo: navigate to search screen
          },
          child: const Icon(
            Icons.notifications_none_sharp,
            color: Colors.black87,
            size: 40,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            //todo: navigate to notifications screen
          },
          child: const Icon(
            Icons.search_sharp,
            color: Colors.black87,
            size: 40,
          ),
        ),
      ],
    );
  }
}
