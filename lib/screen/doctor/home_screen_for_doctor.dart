import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_text.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

class HomeScreenForDoctor extends StatefulWidget {
  const HomeScreenForDoctor({Key? key}) : super(key: key);

  @override
  _HomeScreenForDoctorState createState() => _HomeScreenForDoctorState();
}

class _HomeScreenForDoctorState extends State<HomeScreenForDoctor> {
  @override
  Widget build(BuildContext context) {
    final docor = context.watch<AuthProvider>().doctor!;
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
          SingleChildScrollView(
              child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(docor.uid)
                .snapshots(),
            builder: (cyx, sh) => GestureDetector(
              onTap: () {},
              child: Badge(
                  toAnimate: false,
                  shape: BadgeShape.circle,
                  badgeColor: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(8),
                  child: Center(child: Icon(Icons.request_page))),
            ),
          ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Text('Your Patients', style: Constant.semieBoldTextStyle),
              ListView.builder(
                itemCount: docor.patients.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: Constant.width(context) * 0.9,
                    child: Card(
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
                                children: [
                                  Container(
                                    height: Constant.height(context) * 0.2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            docor.patients[index].image),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  CustomText(
                                    text: docor.patients[index].name
                                        .toUpperCase(),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Constant.primaryDarkColor,
                                  ),
                                  const SizedBox(height: 5),
                                  CustomText(
                                    text: docor.patients[index].feeling,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Constant.primaryDarkColor,
                                  ),
                                  const SizedBox(height: 5),
                                  CustomText(
                                    text: docor.patients[index].age,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Constant.primaryDarkColor,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: Constant.width(context) * 0.3,
                              height: Constant.height(context) * 0.3,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  CustomText(
                                    text: 'Connect',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Constant.primaryDarkColor,
                                  ),
                                  CustomText(
                                    text: 'Chat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Constant.primaryDarkColor,
                                  ),
                                  CustomText(
                                    text: 'Report',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Constant.primaryDarkColor,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
