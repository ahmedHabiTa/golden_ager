import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import '../doctor/home_screen_for_doctor.dart';
import 'profile_screen.dart';
import 'report_screen.dart';
import 'tips_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _index = 0;

  Map<String, List<Map<String, dynamic>>> pagesForTypeUser = {
    'patient': [
      {"index": 0, "page": const HomeScreen(), "title": "Home"},
      {"index": 1, "page": const TipsScreen(), "title": "Tips"},
      {"index": 2, "page": const Scaffold(), "title": "Reports"},
      {"index": 3, "page": const ProfileScreen(), "title": "Profile"},
    ],
    'doctor': [
      {"index": 0, "page": const HomeScreenForDoctor(), "title": "Home"},
      {"index": 1, "page": const TipsScreen(), "title": "Tips"},
      {"index": 2, "page": const ReportScreen(), "title": "Reports"},
      {"index": 3, "page": const ProfileScreen(), "title": "Profile"},
    ]
  };

  late List<Map<String, dynamic>> pages;
  @override
  void initState() {
    super.initState();
    pages = pagesForTypeUser[context.read<AuthProvider>().userType]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index]['page'],
      bottomNavigationBar: Theme(
        data:
            Theme.of(context).copyWith(canvasColor: Constant.primaryDarkColor),
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
}
