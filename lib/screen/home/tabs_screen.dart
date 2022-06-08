import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:golden_ager/screen/home/check_in_screen.dart';
import 'package:provider/provider.dart';
import '../../core/util/shared_prefs_helper.dart';
import '../../features/chat/domain/entities/order_user.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../notifications.dart';
import '../medicine/medicine_reminder.dart';
import '../mentor/mentor_home_screen.dart';
import '../patient/patient_mentor_screen.dart';
import 'home_screen.dart';
import '../doctor/home_screen_for_doctor.dart';
import 'profile_screen.dart';
import 'tips_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key, this.userId}) : super(key: key);
  final String? userId;
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _index = 0;

  onNotificationReceive(ReceivedNotification notification) {
    print('notification received');
  }

  onNotificationClick(String payload) {
    print(payload);
    if (payload == 'tabs_screen') {
      Constant.navigateTo(routeName: const TabsScreen(), context: context);
    } else if (payload == 'medicine_screen') {
      Constant.navigateTo(
          routeName: MedicineReminderScreen(), context: context);
    } else if (payload == 'checkIn_screen') {
      Constant.navigateTo(routeName: const CheckInScreen(), context: context);
    } else if (payload.contains('chat')) {
      Map<String, dynamic> payloadMap = json.decode(payload);
      Constant.navigateTo(
          context: context,
          routeName: ChatPage(
              user1: ChatUser.fromMap(jsonDecode(payloadMap["reciver_user"])),
              user2: ChatUser.fromMap(jsonDecode(payloadMap["sender_user"]))));
    }
  }

  late Map<String, List<Map<String, dynamic>>> pagesForTypeUser;

  late List<Map<String, dynamic>> pages;

  @override
  void initState() {
    super.initState();
    pagesForTypeUser = {
      'patient': [
        {
          "index": 0,
          "page": HomeScreen(
              userUUID:
                  widget.userId ?? SharedPrefsHelper.getData(key: 'userUUID')),
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
          "page": const PatientMentorsScreen(),
          "title": "Mentors",
          "icon": Icon(Icons.assessment_outlined)
        },
        {
          "index": 3,
          "page": ProfileScreen(
              isMe: (widget.userId == null), userId: widget.userId),
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
      ],
      'mentor': [
        {
          "index": 0,
          "page": const MentorHomeScreen(),
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
    pages = pagesForTypeUser[context.read<AuthProvider>().userType]!;
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
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
          unselectedItemColor: Constant.primaryColor,
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
