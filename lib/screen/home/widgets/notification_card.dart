import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';

import '../../../core/common_widget/custom_text.dart';

class NotificationsCard extends StatelessWidget {
  final String title;
  final String from;
  final String body;
  final String category;

  const NotificationsCard({
    Key? key,
    required this.title,
    required this.body,
    required this.from,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 10,
          child: Container(
            height: Constant.height(context) * 0.35,
            color: const Color(0xFFfcfcfc),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/bell.png'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text: 'From :',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF292d32),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 149,
                            child: CustomText(
                              text: from,
                              fontSize: 12,
                              color: Constant.primaryDarkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: Constant.width(context) * 0.6,
                        child: CustomText(
                          text: body,
                          fontSize: 15,
                          color: Constant.primaryDarkColor,
                          fontWeight: FontWeight.bold,
                          textOverflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        textDirection: TextDirection.ltr,
                        text: title,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF575757),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
