import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/Constant.dart';
import 'package:golden_ager/features/home/presentaion/profile_screen.dart';
import 'package:golden_ager/features/home/presentaion/tips_screen.dart';

import 'home_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _index = 0;

  List<Map<String, dynamic>> pages = [
    {"index": 0, "page": const HomeScreen(), "title": "Home"},
    {"index": 1, "page": const TipsScreen(), "title": "Tips"},
    {"index": 2, "page": const Scaffold(), "title": "Reports"},
    {"index": 3, "page": const ProfileScreen(), "title": "Profile"},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Constant.primaryColor,
        actions: [
          GestureDetector(
            onTap: () {
              //todo: navigate to notifications screen
            },
            child: const Icon(
              Icons.search_sharp,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            //todo: navigate to search screen
          },
          child: const Icon(
            Icons.notifications_none_sharp,
            color: Colors.white,
            size: 40,
          ),
        ),
        centerTitle: true,
        title: Text(
          pages[_index]['title'],
          style: Constant.appBarTextStyle.copyWith(color: Colors.white),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Constant.primaryDarkColor,
        ),
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
              icon: Icon(Icons.pets),
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
      body: pages[_index]['page'],
    ));
  }
}
