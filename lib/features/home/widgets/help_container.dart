import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_wide_container.dart';
import 'package:golden_ager/core/constant/constants.dart';

import '../../../core/common_widget/custom_text.dart';

class HelpContainer extends StatelessWidget {
  const HelpContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Constants.width(context),
      child: Row(
        children: [
          CustomWideContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: Constants.height(context) * 0.12,
                  width: Constants.width(context) * 0.12,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/phoneeee.png'))),
                ),
                const SizedBox(height: 10),
                const   CustomText(
                  text: 'Family Contacts',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            height: Constants.height(context) * 0.3,
            width: Constants.width(context) * 0.45,
            radius: 15.0,
            containerColor: Constants.primaryDarkColor,
            onTap: () {
              //todo: call the mentor number vis url launcher
            },
          ),
          const Spacer(),
          CustomWideContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: Constants.height(context) * 0.12,
                  width: Constants.width(context) * 0.2,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/ambulanceeee.png'))),
                ),
                const SizedBox(height: 10),
                const   CustomText(
                  text: 'Emergency call',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            height: Constants.height(context) * 0.3,
            width: Constants.width(context) * 0.45,
            radius: 15.0,
            containerColor: Constants.primaryDarkColor,
            onTap: () {
              //todo: call the ambulance 123
            },
          ),
        ],
      ),
    );
  }
}
