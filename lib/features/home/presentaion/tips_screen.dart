import 'package:flutter/material.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/constant/Constant.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      'General tips',
      'Exercise Videos',
      'Diet & Food Recipies',
    ];
    List<String> images = [
      'assets/images/Doctor-Talking-with-Patient.jpg',
      'assets/images/senior-health.jpg',
      'assets/images/food.jpg',
    ];
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: _customCard(
                  image: images[index],
                  title: titles[index],
                  onTap: () {},
                  context: context,
                  width: Constant.width(context) * 0.9,
                  height: Constant.height(context) * 0.5,
                  color: Colors.white),
            ),
          );
        },
        itemCount: 3,
      ),
    );
  }

  Widget _customCard({
    required double height,
    required double width,
    required Function onTap,
    required String image,
    required String title,
    required Color color,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 5),
              Container(
                height: Constant.height(context) * 0.35,
                width: Constant.width(context) * 0.9,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(image),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              CustomText(
                text: title,
                color: Constant.primaryDarkColor,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
