import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:golden_ager/screen/home/check_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final bool isMentor;
  const TabsScreen({Key? key, this.userId,this.isMentor = false,}) : super(key: key);
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
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
  }
  void _launchMapsUrl(double lat, double lon) async {
    var url = Uri.parse("google.navigation:q=$lat,$lon&mode=d").toString();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    pagesForTypeUser = {
      'patient': [
        {
          "index": 0,
          "page": HomeScreen(
              userUUID:
                  widget.userId ?? SharedPrefsHelper.getData(key: 'userUUID')),
          "title": "Home",
          'icon':
              _index == 0 ? Icon(Icons.home_filled) : Icon(Icons.home_outlined)
        },
        {
          "index": 1,
          "page": const TipsScreen(),
          "title": "Tips",
          'icon': _index == 1
              ? Icon(Icons.lightbulb)
              : Icon(Icons.lightbulb_outline)
        },
        {
          "index": 2,
          "page": const PatientMentorsScreen(),
          "title": "Guide",
          "icon": _index == 2
              ? Icon(Icons.assessment)
              : Icon(Icons.assessment_outlined)
        },
        {
          "index": 3,
          "page": ProfileScreen(
              isMe: (widget.userId == null), userId: widget.userId),
          "title": "Profile",
          'icon': _index == 3 ? Icon(Icons.person) : Icon(Icons.person_outline)
        },
      ],
      'doctor': [
        {
          "index": 0,
          "page": const HomeScreenForDoctor(),
          "title": "Home",
          'icon':   _index == 0 ? Icon(Icons.home_filled) : Icon(Icons.home_outlined)
        },
        {
          "index": 1,
          "page": const TipsScreen(),
          "title": "Tips",
          'icon':_index == 1
              ? Icon(Icons.lightbulb)
              : Icon(Icons.lightbulb_outline)
        },
        {
          "index": 2,
          "page": const ProfileScreen(isMe: true),
          "title": "Profile",
          'icon':_index == 2 ? Icon(Icons.person) : Icon(Icons.person_outline)
        },
      ],
      'mentor': [
        {
          "index": 0,
          "page": const MentorHomeScreen(),
          "title": "Home",
          'icon':_index == 0 ? Icon(Icons.home_filled) : Icon(Icons.home_outlined)
        },
        {
          "index": 1,
          "page": const TipsScreen(),
          "title": "Tips",
          'icon': _index == 1
              ? Icon(Icons.lightbulb)
              : Icon(Icons.lightbulb_outline)
        },
        {
          "index": 2,
          "page": const ProfileScreen(isMe: true),
          "title": "Profile",
          'icon':_index == 2 ? Icon(Icons.person) : Icon(Icons.person_outline)
        },
      ]
    };
    pages = pagesForTypeUser[context.read<AuthProvider>().userType]!;
    return Scaffold(
      floatingActionButton:!widget.isMentor ?null:  StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(widget.userId!).snapshots(),
        builder: (context, snapshot) {
          return  SizedBox(
                      width: Constant.width(context) * 0.12,
                      child: GestureDetector(
                        onTap: (){
                           double lat = double.parse(snapshot.data!['latitude']);
                           double long = double.parse(snapshot.data!['longitude']);
                          print(snapshot.data!['latitude']);
                          _launchMapsUrl(lat, long);
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Constant.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.location_pin,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
        },
      ),
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
          unselectedItemColor: Colors.white,
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
