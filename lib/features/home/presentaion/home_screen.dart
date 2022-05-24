import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/util/shared_prefs_helper.dart';
import 'package:golden_ager/features/home/widgets/help_container.dart';
import 'package:golden_ager/features/home/widgets/reminders_container.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/common_widget/loading_widget.dart';
import '../widgets/feeling_container.dart';
import '../widgets/health_data_container.dart';
import '../widgets/home_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userUUID = SharedPrefsHelper.getData(key: 'userUUID');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
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
                    text: 'حدث خطأ',
                    color: Colors.red,
                    fontSize: 30,
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: LoadingWidget(),
                );
              }else if(snapshot.hasData){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const HomeAppBar(),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: 'Hello, ${snapshot.data!['name']} ! ',
                        color: const Color(0xFF0d2137),
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                     FeelingsContainer(feeling: snapshot.data!['feeling']),
                    const SizedBox(height: 15),
                    const HealthDataContainer(),
                    const SizedBox(height: 15),
                    const ReminderContainer(),
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: 'How can I help you?',
                        color: Color(0xFF0d2137),
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const HelpContainer(),
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
}
