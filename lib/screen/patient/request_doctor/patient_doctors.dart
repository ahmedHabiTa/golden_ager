import 'package:flutter/material.dart';
import 'package:golden_ager/features/chat/domain/entities/order_user.dart';
import 'package:golden_ager/features/chat/presentation/pages/chat_page.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/constant/constant.dart';
import '../../home/profile_screen.dart';
import '../../home/report_screen.dart';
import 'doctors_list_widget.dart';

class PatientDoctorCard extends StatefulWidget {
  const PatientDoctorCard({Key? key}) : super(key: key);

  @override
  State<PatientDoctorCard> createState() => _PatientDoctorCardState();
}

class _PatientDoctorCardState extends State<PatientDoctorCard> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().patient!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Doctors',
                style: Constant.mediumTextStyle,
              ),
              GestureDetector(
                onTap: () {
                  Constant.navigateTo(
                      routeName: DoctorListScreen(), context: context);
                },
                child: Icon(
                  Icons.add_box_rounded,
                  size: 35,
                  color: Constant.primaryColor,
                ),
              )
            ],
          ),
          if (user.doctors.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: user.doctors.length,
                itemBuilder: (context, index) => SizedBox(
                  width: Constant.width(context) * 0.55,
                  child: Card(
                    elevation: 5,
                    color: Constant.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Constant.navigateTo(
                                routeName: ProfileScreen(
                                    isMe: false,
                                    userId: user.doctors[index].uid),
                                context: context);
                          },
                          child: Container(
                            height: Constant.height(context) * 0.3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(user.doctors[index].image),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        CustomText(
                          text:
                              "name: " + user.doctors[index].name.toUpperCase(),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                        CustomText(
                          text: "age: " + user.doctors[index].age,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                        CustomText(
                          text: "specialization: " +
                              user.doctors[index].specialization,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: Constant.width(context) * 0.3,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Constant.navigateTo(
                                        routeName: ChatPage(
                                            user1: ChatUser.fromAppUser(user),
                                            user2: ChatUser.fromAppUser(
                                                user.doctors[index])),
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
                                          doctorId: user.doctors[index].uid,
                                          patientId: user.uid,
                                          userType: user.userType,
                                          patientName: user.name,
                                          doctorName: user.doctors[index].name,
                                        ),
                                        context: context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Constant.primaryColor,
              ),
              height: 150,
              width: double.infinity,
              alignment: AlignmentDirectional.center,
              child: Text(
                "You don't have any doctor till now",
                style: Constant.mediumTextStyle.copyWith(color: Colors.white),
              ),
            )
        ],
      ),
    );
  }
}
