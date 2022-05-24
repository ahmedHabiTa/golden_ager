import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_wide_container.dart';
import 'package:golden_ager/core/constant/constants.dart';

import '../../../core/common_widget/custom_text.dart';

class ReminderContainer extends StatelessWidget {
  const ReminderContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'assets/images/medicineeee.png',
      'assets/images/reminderrrrr.png'
    ];
    List<String> titles = ['Medications', 'Other reminders'];
    return SizedBox(
      width: Constants.width(context) * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(width: 15),
              CustomText(
                text: 'Today\'s Reminders',
                color: Constants.primaryDarkColor,
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
              const Spacer(),
              Icon(
                Icons.add_circle_outline,
                color: Constants.primaryDarkColor,
                size: 30,
              ),
              const SizedBox(width: 15),
            ],
          ),
          const SizedBox(),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _customContainer(
                context: context,
                image: images[index],
                title: titles[index],
              );
            },
            itemCount: 2,
          ),
        ],
      ),
    );
  }

  Widget _customContainer({
    required BuildContext context,
    required String image,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: CustomWideContainer(
        child: Row(
          children: [
            const SizedBox(width: 15),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(image),
                  )),
            ),
            const SizedBox(width: 15),
            CustomText(
              text: title,
              color: const Color(0xFF0d2137),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Color(0xFF0d2137),
            ),
            const SizedBox(width: 15),
          ],
        ),
        height: Constants.height(context) * 0.14,
        width: Constants.width(context) * 0.6,
        radius: 100.0,
        containerColor: const Color(0xFFc6dffc),
        onTap: () {},
      ),
    );
  }
}
