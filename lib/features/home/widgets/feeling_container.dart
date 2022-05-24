import 'package:flutter/material.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/common_widget/custom_wide_container.dart';
import '../../../core/constant/constants.dart';
import '../presentaion/check_in_screen.dart';

class FeelingsContainer extends StatelessWidget {
  final String feeling;
  const FeelingsContainer({Key? key,required this.feeling}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomWideContainer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              right: 15.0,
              top: 15.0,
              bottom: 15.0,
              child: Container(
                width: Constants.width(context) * 0.3,
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
                    text: feeling == '' ? 'How do you feel \n today?' : feeling,
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                  CustomWideContainer(
                    child: Row(
                      children: const [
                        SizedBox(width: 15),
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
                        SizedBox(width: 15),
                      ],
                    ),
                    height: Constants.height(context) * 0.11,
                    width: Constants.width(context) * 0.35,
                    radius: 20.0,
                    containerColor: const Color(0xFF00b4d8),
                    onTap: () {
                      //todo:navigator to feelings screen
                      Constants.navigateTo(
                          routeName:  CheckInScreen(), context: context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      height: Constants.height(context) * 0.4,
      width: Constants.width(context),
      radius: 15.0,
      containerColor: Constants.primaryColor,
      onTap: () {},
    );
  }
}
