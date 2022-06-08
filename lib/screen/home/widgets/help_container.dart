import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_wide_container.dart';
import 'package:golden_ager/core/constant/Constant.dart';
import 'package:golden_ager/screen/home/contacts_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/common_widget/custom_text.dart';

class HelpContainer extends StatelessWidget {
  const HelpContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: Constant.width(context),
      child: Row(
        children: [
          CustomWideContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: Constant.height(context) * 0.12,
                  width: Constant.width(context) * 0.12,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/phoneeee.png'))),
                ),
                const SizedBox(height: 10),
                const CustomText(
                  text: 'Family Contacts',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            height: Constant.height(context) * 0.3,
            width: Constant.width(context) * 0.45,
            radius: 15.0,
            containerColor: Constant.primaryDarkColor,
            onTap: () {
              Constant.navigateTo(
                  routeName: const ContactScreen(), context: context);
            },
          ),
          const Spacer(),
          CustomWideContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: Constant.height(context) * 0.12,
                  width: Constant.width(context) * 0.2,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/ambulanceeee.png'))),
                ),
                const SizedBox(height: 10),
                const CustomText(
                  text: 'Emergency call',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            height: Constant.height(context) * 0.3,
            width: Constant.width(context) * 0.45,
            radius: 15.0,
            containerColor: Constant.primaryDarkColor,
            onTap: () async {
              await launchUrl(Uri(
                scheme: 'tel',
                path: 123.toString(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
