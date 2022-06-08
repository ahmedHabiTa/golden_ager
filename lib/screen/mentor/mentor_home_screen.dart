import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/provider/requests_provider.dart';
import 'package:golden_ager/screen/home/tabs_screen.dart';
import 'package:provider/provider.dart';

import '../../core/common_widget/custom_text.dart';
import '../../core/common_widget/custom_text_form_field.dart';
import '../../core/common_widget/custom_wide_buttom.dart';
import '../../core/constant/constant.dart';
import '../../features/chat/domain/entities/order_user.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../models/user.dart';
import '../../provider/auth_provider.dart';
import '../home/profile_screen.dart';
import '../home/request_history_screen.dart';

class MentorHomeScreen extends StatefulWidget {
  const MentorHomeScreen({Key? key}) : super(key: key);

  @override
  State<MentorHomeScreen> createState() => _MentorHomeScreenState();
}

class _MentorHomeScreenState extends State<MentorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mentor = context.watch<AuthProvider>().mentor!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Patient', style: Constant.semieBoldTextStyle),
        foregroundColor: Color(0xffEFF1F3),
        actions: [
          GestureDetector(
            onTap: () {
              //todo: navigate to notifications screen
            },
            child: const Icon(
              Icons.notifications_none_sharp,
              color: Constant.primaryDarkColor,
              size: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MentorPatientWidget(mentor: mentor),
            MentorAddPatientWidget(mentor: mentor)
          ],
        ),
      ),
    );
  }
}

class MentorPatientWidget extends StatelessWidget {
  const MentorPatientWidget({
    Key? key,
    required this.mentor,
  }) : super(key: key);

  final Mentor mentor;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.doc("users/${mentor.uid}").snapshots(),
        builder: (cyx, sh) {
          if (sh.connectionState != ConnectionState.waiting) {
            final Mentor MentorData =
                Mentor.fromMap(sh.data!.data() as Map<String, dynamic>);
            if (MentorData.patients.isEmpty) {
              return Padding(
                padding: Constant.kPaddingListTile,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Constant.primaryColor,
                  ),
                  height: 150,
                  width: double.infinity,
                  alignment: AlignmentDirectional.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You don't have patient till now",
                        style: Constant.mediumTextStyle
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        "connect to some one and get his id",
                        style: Constant.normalTextStyle
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return MentorPatientCardWidget(mentorData: MentorData);
            }
          } else {
            return Center(
              child: Constant.indicator(),
            );
          }
        });
  }
}

class MentorPatientCardWidget extends StatelessWidget {
  const MentorPatientCardWidget({
    Key? key,
    required this.mentorData,
  }) : super(key: key);

  final Mentor mentorData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constant.kPaddingListTile,
      child: Card(
        color: Constant.primaryColor,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Constant.navigateTo(
                      routeName: ProfileScreen(
                          isMe: false, userId: mentorData.patients[0].uid),
                      context: context);
                },
                child: Container(
                  height: Constant.height(context) * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(mentorData.patients[0].image),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              CustomText(
                text: "name: " + mentorData.patients[0].name.toUpperCase(),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
              const SizedBox(height: 5),
              CustomText(
                text: "age: " + mentorData.patients[0].age,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
              const SizedBox(height: 5),
              CustomText(
                text: "feeling: " + mentorData.patients[0].feeling,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Constant.width(context) * 0.3,
                      child: ElevatedButton(
                        onPressed: () {
                          Constant.navigateTo(
                              routeName: ChatPage(
                                  user1: ChatUser.fromAppUser(mentorData),
                                  user2: ChatUser.fromAppUser(
                                      mentorData.patients[0])),
                              context: context);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.white),
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
                          await context.read<AuthProvider>().changeUserType(
                              newUserType: 'patient',
                              PatientId: mentorData.patients[0].uid);
                          await Constant.navigateTo(
                              routeName: TabsScreen(
                                userId: mentorData.patients[0].uid,
                              ),
                              context: context);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        child: CustomText(
                          text: 'access',
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Constant.primaryColor,
                        ),
                      ),
                    ),
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

class MentorAddPatientWidget extends StatefulWidget {
  const MentorAddPatientWidget({
    Key? key,
    required this.mentor,
  }) : super(key: key);

  final Mentor mentor;
  @override
  State<MentorAddPatientWidget> createState() => _MentorAddPatientWidgetState();
}

class _MentorAddPatientWidgetState extends State<MentorAddPatientWidget> {
  final TextEditingController addPatientController = TextEditingController();
  bool isLoading = false;
  void toggleLoading() => isLoading = !isLoading;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .doc("users/${widget.mentor.uid}")
            .snapshots(),
        builder: (cyx, sh) {
          if (sh.connectionState != ConnectionState.waiting) {
            final Mentor MentorData =
                Mentor.fromMap(sh.data!.data() as Map<String, dynamic>);
            if (MentorData.patients.isEmpty) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                        Text('Add Patient', style: Constant.semieBoldTextStyle),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          controller: addPatientController,
                          onChanged: (value) {
                            addPatientController.text.trim();
                          },
                          prefix:
                              Icon(Icons.person, color: Constant.primaryColor),
                          validation: 'field is Required',
                          width: Constant.width(context) * 0.9,
                          height: 50,
                          hintText: 'Patient\'s ID',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Constant.navigateTo(
                                routeName: RequestHistoryScreen(
                                  userId:
                                      context.read<AuthProvider>().mentor!.uid,
                                ),
                                context: context);
                          },
                          child: Icon(
                            Icons.history,
                            color: Constant.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  isLoading
                      ? Constant.indicator()
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomWideButton(
                            radius: 10.0,
                            height: 40,
                            width: 130,
                            color: Constant.primaryDarkColor,
                            onTap: () async {
                              toggleLoading();
                              await context
                                  .read<RequestsProvider>()
                                  .makeMentorRequest(
                                      patientId: addPatientController.text,
                                      mentor:
                                          context.read<AuthProvider>().mentor!,
                                      context: context);
                              toggleLoading();
                            },
                            child: const Center(
                              child: CustomText(
                                text: 'Send request',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ))
                ],
              );
            } else {
              return SizedBox();
            }
          } else {
            return Center(
              child: Constant.indicator(),
            );
          }
        });
  }
}
