import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../patient/patient_reports_screen.dart';
import 'home_screen.dart';
import '../doctor/home_screen_for_doctor.dart';
import 'profile_screen.dart';
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
      {
        "index": 0,
        "page": const HomeScreen(),
        "title": "Home",
        'icon': Icon(Icons.home_filled)
      },
      {
        "index": 1,
        "page": const TipsScreen(),
        "title": "Tips",
        'icon': Icon(Icons.lightbulb_outline)
      },
      {
        "index": 2,
        "page": const PatientReportsScreen(),
        "title": "Mentors",
        "icon": Icon(Icons.assessment_outlined)
      },
      {
        "index": 3,
        "page": const ProfileScreen(isMe: true),
        "title": "Profile",
        'icon': Icon(Icons.person_outline)
      },
    ],
    'doctor': [
      {
        "index": 0,
        "page": const HomeScreenForDoctor(),
        "title": "Home",
        'icon': Icon(Icons.home_filled)
      },
      {
        "index": 1,
        "page": const TipsScreen(),
        "title": "Tips",
        'icon': Icon(Icons.lightbulb_outline)
      },
      {
        "index": 2,
        "page": const ProfileScreen(isMe: true),
        "title": "Profile",
        'icon': Icon(Icons.person_outline)
      },
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
          items: pages
              .map(
                (e) => BottomNavigationBarItem(
                  icon: e['icon'],
                  label: e['title'],
                ),
              )
              .toList(),
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
