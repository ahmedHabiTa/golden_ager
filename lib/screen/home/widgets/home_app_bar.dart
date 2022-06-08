import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SizedBox(width: 10),

        Spacer(),
        // GestureDetector(
        //   onTap: () {
        //     //todo: navigate to search screen
        //   },
        //   child: const Icon(
        //     Icons.search_sharp,
        //     color: Constant.primaryDarkColor,
        //     size: 40,
        //   ),
        // ),
        // const SizedBox(width: 10),
      ],
    );
  }
}
