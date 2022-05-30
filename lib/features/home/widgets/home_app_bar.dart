import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            //todo: navigate to search screen
          },
          child: const Icon(
            Icons.notifications_none_sharp,
            color: Constant.primaryDarkColor,
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
            color: Constant.primaryDarkColor,
            size: 40,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
