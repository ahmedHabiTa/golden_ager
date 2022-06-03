import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_wide_container.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/core/util/shared_prefs_helper.dart';
import 'package:provider/provider.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/common_widget/loading_widget.dart';
import '../../../provider/auth_provider.dart';
import 'package:clipboard/clipboard.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userUUID = SharedPrefsHelper.getData(key: 'userUUID');
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userUUID)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: LoadingWidget(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: CustomText(
                    text: 'Error happen',
                    color: Colors.red,
                    fontSize: 30,
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: LoadingWidget(),
                );
              } else if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: Constant.height(context) * 0.55,
                          width: Constant.width(context),
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            height: Constant.height(context) * 0.4,
                            width: Constant.width(context),
                            decoration: BoxDecoration(
                              color: Constant.primaryColor,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(1000),
                                bottomLeft: Radius.circular(1000),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: Constant.height(context) * 0.4,
                            width: Constant.width(context) * 0.4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(snapshot.data!['image'] ??
                                    'https://browsecat.net/sites/default/files/joker-wallpapers-51569-212800-859598.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: _customDynamicText(text: snapshot.data!['name']),
                    ),
                    _customDivider(),
                    Align(
                      child: _customFixedText(text: 'Contact Info'),
                      alignment: Alignment.centerLeft,
                    ),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        child: SizedBox(
                          width: Constant.width(context) * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _customFixedText(text: 'Email :'),
                              _customDynamicText(text: snapshot.data!['email']),
                              _customFixedText(text: 'Phone :'),
                              _customDynamicText(text: snapshot.data!['phone']),
                              _customFixedText(text: 'Bio :'),
                              _customDynamicText(
                                  text: snapshot.data!['description']),
                              _customFixedText(text: 'Id :'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _customDynamicText(
                                      text: snapshot.data!['uid']),
                                  GestureDetector(
                                      onTap: () {
                                        FlutterClipboard.copy(
                                                snapshot.data!['uid'])
                                            .then((value) =>
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Text(
                                                      'your id has been copied'),
                                                  backgroundColor: Colors.grey,
                                                )));
                                      },
                                      child: Icon(Icons.copy))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      child: _customFixedText(text: 'Personal Info'),
                      alignment: Alignment.centerLeft,
                    ),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        child: SizedBox(
                          width: Constant.width(context) * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _customFixedText(text: 'Gender :'),
                              _customDynamicText(
                                  text: snapshot.data!['gender']),
                              if(snapshot.data!['feeling'] != '')
                              _customFixedText(text: 'Feeling :'),
                              if(snapshot.data!['feeling'] != '')
                              _customDynamicText(
                                  text: snapshot.data!['feeling']),
                              _customFixedText(text: 'Type :'),
                              _customDynamicText(
                                  text: snapshot.data!['user_type']),
                              _customFixedText(text: 'Age :'),
                              _customDynamicText(text: snapshot.data!['age']),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      child: _customFixedText(text: 'Medical history'),
                      alignment: Alignment.centerLeft,
                    ),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        child: SizedBox(
                          width: Constant.width(context) * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _customFixedText(text: 'Medical Specialty:'),
                              _customDynamicText(text: 'Endocrinology'),
                              _customFixedText(text: 'Sample Name :'),
                              _customDynamicText(
                                  text: 'Diabetes Mellitus Followup'),
                              _customFixedText(text: 'Description :'),
                              _customDynamicText(
                                  text:
                                      'Return visit to the endocrine clinic for followup management of type 1 diabetes mellitus. Plan today is to make adjustments to her pump based on a total daily dose of 90 units of insulin.(Medical Transcription Sample Report)'),
                              _customFixedText(text: 'PROBLEM LIST :'),
                              _customDynamicText(
                                  text:
                                      '1. Type two diabetes mellitus,insulin pump.\n2. Hypertension.\n3. Hyperlipidemia.'),
                              _customFixedText(text: 'CURRENT MEDICATIONS :'),
                              _customDynamicText(
                                text: '''1. Zoloft 50 mg p.o. once daily.
                                \n2. Lisinopril 40 mg once daily.
                              \n  3. Symlin 60 micrograms, not taking at this point.
                               \n 4. Folic acid 2 by mouth every day.
                               \n 5. NovoLog insulin via insulin pump about 90 units of insulin per day.''',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return Center(
                          child: CustomWideContainer(
                              child: const Center(
                                child: CustomText(
                                  text: 'LogOut',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              height: Constant.height(context) * 0.12,
                              width: Constant.width(context) * 0.8,
                              radius: 20.0,
                              containerColor: Constant.primaryColor,
                              onTap: () async {
                                await authProvider.logOut(context);
                              }),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _customDivider() {
    return const Divider(
      thickness: 1,
      color: Colors.black87,
      indent: 50,
      endIndent: 50,
    );
  }

  Widget _customFixedText({
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: CustomText(
        text: text,
        fontSize: 13,
        color: Constant.primaryDarkColor,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _customDynamicText({
    required String text,
  }) {
    return Container(
      //    alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: CustomText(
        text: text,
        fontSize: 15,
        color: Constant.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
