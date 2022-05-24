import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constants.dart';
import 'package:provider/provider.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../provider/auth_provider.dart';
import 'home_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _index = 0;

  List<Map<String, dynamic>> pages = [
    {"index": 0, "page": const HomeScreen()},
    {"index": 1, "page": const Scaffold()},
    {"index": 2, "page": const Scaffold()},
    {"index": 3, "page":  Scaffold(
      body: Center(
        child:
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return Center(
              child: GestureDetector(
                onTap: () async {
                  await authProvider.logOut(context);
                },
                child:  CustomText(
                  text: 'LogOut',
                  fontSize: 30,
                  color: Constants.primaryDarkColor,
                ),
              ),
            );
          },
        ),
      ),
    )},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Constants.primaryDarkColor,
            ),
            child: BottomNavigationBar(
              showUnselectedLabels: true,
              selectedIconTheme: const IconThemeData(
                color: Colors.white,
              ),
              selectedItemColor: Colors.white,

              items:const [
                  BottomNavigationBarItem(
                  icon:  Icon(Icons.home_filled),
                  label:'Home',
                ),
                BottomNavigationBarItem(
                  icon:  Icon(Icons.pets),
                  label:'Tips',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assessment_outlined),
                  label:'Report',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label:'Profile',
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
