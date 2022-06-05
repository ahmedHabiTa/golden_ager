import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_text.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/models/request.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:golden_ager/screen/home/add_report_screen.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import '../../features/chat/domain/entities/order_user.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../models/user.dart';
import '../../notifications.dart';
import '../home/profile_screen.dart';
import '../home/report_screen.dart';
import 'doctor_request_screen.dart';

class HomeScreenForDoctor extends StatefulWidget {
  const HomeScreenForDoctor({Key? key}) : super(key: key);

  @override
  _HomeScreenForDoctorState createState() => _HomeScreenForDoctorState();
}


class _HomeScreenForDoctorState extends State<HomeScreenForDoctor> {




  @override
  Widget build(BuildContext context) {
    final doctor = context.watch<AuthProvider>().doctor!;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Color(0xffEFF1F3),
        leading: GestureDetector(
          onTap: () {
            //todo: navigate to notifications screen
          },
          child: const Icon(
            Icons.notifications_none_sharp,
            color: Constant.primaryDarkColor,
            size: 40,
          ),
        ),
        actions: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("users/${doctor.uid}/requests")
                  .where('status', isEqualTo: 'waiting')
                  .snapshots(),
              builder: (cyx, sh) {
                if (sh.connectionState != ConnectionState.waiting) {
                  final List<Request> requests = sh.data!.docs
                      .map((e) => Request.fromMap(e.data()))
                      .toList();
                  return Badge(
                    position: requests.isEmpty
                        ? null
                        : BadgePosition.topEnd(top: 2, end: 2),
                    badgeContent: requests.isNotEmpty
                        ? Text(
                            requests.length.toString(),
                            style: TextStyle(color: Colors.white),
                          )
                        : null,
                    child: IconButton(
                      icon: Icon(Icons.email, size: 30),
                      onPressed: () {
                        Constant.navigateTo(
                            routeName:
                                DoctoreRequestsScreen(requests: requests),
                            context: context);
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Text('Your Patients', style: Constant.semieBoldTextStyle),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .doc("users/${doctor.uid}")
                    .snapshots(),
                builder: (cyx, sh) {
                  if (sh.connectionState != ConnectionState.waiting) {
                    final Doctor doctorData =
                        Doctor.fromMap(sh.data!.data() as Map<String, dynamic>);
                    return Expanded(
                        child: ListView.builder(
                      itemCount: doctorData.patients.length,
                      itemBuilder: (context, index) {
                        return AttatedUserItem(docor: doctorData, index: index);
                      },
                    ));
                  } else if (sh.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: Center(
                        child: Constant.indicator(),
                      ),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Constant.primaryColor,
                      ),
                      height: 150,
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        "You don't have any patients till now",
                        style: Constant.mediumTextStyle
                            .copyWith(color: Colors.white),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}

class AttatedUserItem extends StatelessWidget {
  const AttatedUserItem({Key? key, required this.docor, required this.index})
      : super(key: key);
  final int index;
  final Doctor docor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Constant.width(context) * 0.9,
      child: Card(
        color: Constant.primaryColor,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Constant.width(context) * 0.55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Constant.navigateTo(
                            routeName: ProfileScreen(
                                isMe: false, userId: docor.patients[index].uid),
                            context: context);
                      },
                      child: Container(
                        height: Constant.height(context) * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(docor.patients[index].image),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomText(
                      text: "name: " + docor.patients[index].name.toUpperCase(),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 5),
                    CustomText(
                      text: "age: " + docor.patients[index].age,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 5),
                    CustomText(
                      text: "feeling: " + docor.patients[index].feeling,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                width: Constant.width(context) * 0.3,
                height: Constant.height(context) * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: Constant.width(context) * 0.3,
                      child: ElevatedButton(
                        onPressed: () async {
                          Constant.navigateTo(
                              routeName: ChatPage(
                                  user1: ChatUser.fromAppUser(docor),
                                  user2: ChatUser.fromAppUser(
                                      docor.patients[index])),
                              context: context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        child: CustomText(
                          text: 'Chat',
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Constant.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Constant.width(context) * 0.3,
                      child: ElevatedButton(
                        onPressed: () async {
                          Constant.navigateTo(
                              routeName: ReportScreen(
                                doctorId: docor.uid,
                                patientId: docor.patients[index].uid,
                                userType: docor.userType,
                                patientName: docor.patients[index].name,
                                doctorName: docor.name,
                              ),
                              context: context);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        child: CustomText(
                          text: 'Reports',
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Constant.primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
