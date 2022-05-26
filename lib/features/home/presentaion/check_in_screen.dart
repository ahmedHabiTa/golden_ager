import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_wide_container.dart';
import 'package:golden_ager/core/common_widget/loading_widget.dart';

import 'package:golden_ager/provider/home_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/constant/constant.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  String feeling = '';

  bool isLoading = false;
  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Map<String, bool> feelingGroup = {
    "Good": false,
    "Dizzy": false,
    "Headache": false,
    "Stomach pain": false,
    "Nausea": false,
    "Difficulty Breathing": false,
    "Heart pain": false,
    "Eye pain": false,
    "fever": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Constant.primaryDarkColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'How are you feeling today?',
                color: Constant.primaryDarkColor,
                fontSize: 34,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 15),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: feelingGroup.keys.map((String key) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF091249),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: key,
                        color: const Color(0xFF0d2137),
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: feelingGroup[key],
                    onChanged: (value) {
                      setState(() {
                        feelingGroup.forEach((key, value) {
                          feelingGroup[key] = false;
                        });
                        feelingGroup[key] = value!;
                        feeling = key;
                      });
                      if (value == false) {
                        feeling = '';
                      }
                      print(feeling);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              Consumer<HomeProvider>(
                builder: (context, homeProvider, _) {
                  return isLoading == true
                      ? const Center(
                          child: LoadingWidget(),
                        )
                      : Center(
                          child: CustomWideContainer(
                            child: const Center(
                              child: CustomText(
                                text: 'Done',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            height: Constant.height(context) * 0.1,
                            width: Constant.width(context) * 0.8,
                            radius: 1000.0,
                            containerColor: Constant.primaryColor,
                            onTap: () {
                              toggleLoading();
                              homeProvider.changeFeeling(
                                  feeling: feeling, context: context);
                              toggleLoading();
                            },
                          ),
                        );
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
