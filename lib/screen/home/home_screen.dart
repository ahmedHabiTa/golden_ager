import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/constant/Constant.dart';
import '../home/widgets/help_container.dart';
import '../home/widgets/reminders_container.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/common_widget/loading_widget.dart';
import 'widgets/feeling_container.dart';
import 'widgets/health_data_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.userUUID}) : super(key: key);
  final userUUID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Color(0xffEFF1F3),
        actions: [
          GestureDetector(
            onTap: () {
              //todo: navigate to notifications screen
            },
            child: const Icon(
              Icons.notifications_none_sharp,
              color: Constant.primaryDarkColor,
              size: 40,
            ),
          ),
        ],
      ),
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
                  Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text:
                          'Hello, ${snapshot.data!['name'].toString().split(' ')[0]} ! ',
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
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: 'Contacts',
                        color: Color(0xFF0d2137),
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      )),
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
    );
  }
}
