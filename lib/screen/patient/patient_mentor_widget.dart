import 'package:flutter/material.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/common_widget/custom_text.dart';
import '../../core/constant/constant.dart';
import '../../features/chat/domain/entities/order_user.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../home/profile_screen.dart';

class PatientMentorCard extends StatefulWidget {
  const PatientMentorCard({Key? key}) : super(key: key);

  @override
  State<PatientMentorCard> createState() => _PatientMentorCardState();
}

class _PatientMentorCardState extends State<PatientMentorCard> {
  void showMentorDialog() {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style:
            Constant.semieBoldTextStyle.copyWith(color: Constant.primaryColor),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Mentor"),
      content: Text(
          "for your safety please send your id (you can get it from your profile) to the mentor that has the app"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().patient!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Mentor',
              style: Constant.mediumTextStyle,
            ),
            GestureDetector(
              onTap: showMentorDialog,
              child: Icon(
                Icons.info,
                size: 35,
                color: Constant.primaryColor,
              ),
            )
          ]),
          if (user.mentor.isNotEmpty)
            SizedBox(
              width: Constant.width(context) * 0.9,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Constant.width(context) * 0.55,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Constant.navigateTo(
                                    routeName: ProfileScreen(
                                        isMe: false,
                                        userId: user.doctors[0].uid),
                                    context: context);
                              },
                              child: Container(
                                height: Constant.height(context) * 0.3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(user.mentor[0].image),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            CustomText(
                              text:
                                  user.mentor[0].name.toString().toUpperCase(),
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Constant.primaryDarkColor,
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: Constant.width(context) * 0.3,
                            child: ElevatedButton(
                              onPressed: () async {
                                Constant.navigateTo(
                                    routeName: ChatPage(
                                        user1: ChatUser.fromAppUser(user),
                                        user2: ChatUser.fromAppUser(
                                            user.mentor[0])),
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
                                await launchUrl(Uri(
                                  scheme: 'tel',
                                  path: user.mentor[0].phone.toString(),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                              child: CustomText(
                                text: 'Call',
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: Constant.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                "You don't have mentor till now",
                style: Constant.mediumTextStyle.copyWith(color: Colors.white),
              ),
            )
        ],
      ),
    );
  }
}
