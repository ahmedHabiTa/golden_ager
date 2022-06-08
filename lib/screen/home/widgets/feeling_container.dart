import 'package:flutter/material.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/common_widget/custom_wide_container.dart';
import '../../../core/constant/Constant.dart';
import '../check_in_screen.dart';

class FeelingsContainer extends StatelessWidget {
  final String feeling;
  const FeelingsContainer({Key? key, required this.feeling}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomWideContainer(
        child: Stack(
          children: [
            Positioned(
              right: 15.0,
              top: 15.0,
              bottom: 15.0,
              child: Container(
                width: Constant.width(context) * 0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/smileee.png'),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15.0,
              top: 15.0,
              bottom: 15.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: feeling == ''
                        ? 'How do you feel \n today?'
                        : "you feel\n" + feeling + "\ntoday",
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  CustomWideContainer(
                    child: Row(
                      children: const [
                        SizedBox(width: 10),
                        CustomText(
                          text: 'Check in',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    height: Constant.height(context) * 0.11,
                    width: Constant.width(context) * 0.35,
                    radius: 20.0,
                    containerColor: const Color(0xFF00b4d8),
                    onTap: () {
                      Constant.navigateTo(
                          routeName: const CheckInScreen(), context: context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        height: Constant.height(context) * 0.4,
        width: Constant.width(context),
        radius: 15.0,
        containerColor: Constant.primaryColor,
        onTap: () {},
      ),
    );
  }
}
