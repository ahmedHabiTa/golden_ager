import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/core/util/shared_prefs_helper.dart';
import 'package:golden_ager/features/home/presentaion/profile_screen.dart';
import 'package:golden_ager/features/home/presentaion/report_screen.dart';
import 'package:golden_ager/features/home/presentaion/tips_screen.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/common_widget/loading_widget.dart';
import 'home_screen.dart';
import 'home_screen_for_doctor.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _index = 0;

  List<Map<String, dynamic>> pagesForPatient = [
    {"index": 0, "page": const HomeScreen(), "title": "Home"},
    {"index": 1, "page": const TipsScreen(), "title": "Tips"},
    {"index": 2, "page": const Scaffold(), "title": "Reports"},
    {"index": 3, "page": const ProfileScreen(), "title": "Profile"},
  ];
  List<Map<String, dynamic>> pagesForDoctor = [
    {"index": 0, "page": const HomeScreenForDoctor(), "title": "Home"},
    {"index": 1, "page": const TipsScreen(), "title": "Tips"},
    {"index": 2, "page": const ReportScreen(), "title": "Reports"},
    {"index": 3, "page": const ProfileScreen(), "title": "Profile"},
  ];

  @override
  Widget build(BuildContext context) {
    final userUUID = SharedPrefsHelper.getData(key: 'userUUID');
    return SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userUUID)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: const Padding(
                padding: EdgeInsets.only(top: 80.0),
                child: LoadingWidget(),
              ),
            );
          }
          else if (snapshot.hasError) {
            return Scaffold(
              body: const Center(
                child: CustomText(
                  text: 'Error happen',
                  color: Colors.red,
                  fontSize: 30,
                ),
              ),
            );
          }
          else if (!snapshot.hasData) {
            return Scaffold(
              body: const Center(
                child: CustomText(
                  text: 'Error happen',
                  color: Colors.red,
                  fontSize: 30,
                ),
              ),
            );
          }
          else if (snapshot.hasData) {
            return Scaffold(
              body: snapshot.data!['user_type'] == 'patient'
                  ? pagesForPatient[_index]['page']
                  : pagesForDoctor[_index]['page'],
              bottomNavigationBar: Theme(
                data: Theme.of(context)
                    .copyWith(canvasColor: Constant.primaryDarkColor),
                child: BottomNavigationBar(
                  showUnselectedLabels: true,
                  selectedIconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  selectedItemColor: Colors.white,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_filled),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.lightbulb_outline),
                      label: 'Tips',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.assessment_outlined),
                      label: 'Report',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: _index,
                  onTap: (int value) {
                    setState(() {
                      _index = value;
                    });
                  },
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
