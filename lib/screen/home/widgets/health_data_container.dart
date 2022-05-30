import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_wide_container.dart';
import 'package:golden_ager/core/constant/age_icon_icons.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/constant/Constant.dart';

class HealthDataContainer extends StatelessWidget {
  const HealthDataContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.red,
      Constant.primaryColor,
      const Color(0xFFEA8877),
    ];

    List<Map<String, dynamic>> texts = [
      {
        "index": 0,
        "title": "Heart Rate",
        "icon": Icons.heart_broken,
        "first": '87 bpm',
        "second": "Lowest 72 bpm",
        "third": "Highest 120 bpm",
      },
      {
        "index": 1,
        "title": "Body Temp",
        "icon": AgeIcon.lightbulb,
        "first": '37 C',
        "second": "Normal",
        "third": "",
      },
      {
        "index": 2,
        "title": "Blood Pressure",
        "icon": AgeIcon.blood,
        "first": '141/90 mmhg',
        "second": "Normal",
        "third": "",
      },
    ];
    return Container(
      width: double.infinity,
      height: Constant.height(context) * 0.6,
      color: const Color(0xFFc6dffc),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Row(
            children: const [
              SizedBox(width: 15),
              CustomText(
                text: 'Health Data',
                color: Constant.primaryDarkColor,
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: Constant.primaryDarkColor,
                size: 25,
              ),
              SizedBox(width: 15),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: Constant.height(context) * 0.4,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _customContainer(
                  context: context,
                  icon: texts[index]['icon'],
                  title: texts[index]['title'],
                  firstText: texts[index]['first'],
                  secondText: texts[index]['second'],
                  thirdText: texts[index]['third'],
                  color: colors[index],
                );
              },
              itemCount: 3,
            ),
          )
        ],
      ),
    );
  }

  Widget _customContainer({
    required BuildContext context,
    IconData? icon,
    required String title,
    required String firstText,
    required String secondText,
    required String thirdText,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomWideContainer(
        width: Constant.width(context) * 0.5,
        height: Constant.height(context),
        radius: 20.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  icon != null
                      ? Icon(
                          icon,
                          color: Colors.white,
                          size: 25,
                        )
                      : Container(),
                  const Spacer(),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomText(
                      text: title,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
              const SizedBox(height: 8),
              CustomText(
                text: firstText,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: secondText,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: thirdText,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        onTap: () {},
        containerColor: color,
      ),
    );
  }
}
