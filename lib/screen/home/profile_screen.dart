import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_wide_container.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/core/util/shared_prefs_helper.dart';
import 'package:provider/provider.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/common_widget/loading_widget.dart';
import '../../../provider/auth_provider.dart';
import 'package:clipboard/clipboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.userId, required this.isMe})
      : super(key: key);
  final String? userId;
  final bool isMe;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final String userId = widget.isMe
        ? SharedPrefsHelper.getData(key: 'userUUID')
        : widget.userId;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: LoadingWidget(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: CustomText(
                    text: 'Error happen',
                    color: Colors.red,
                    fontSize: 30,
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: LoadingWidget(),
                );
              } else if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          height: Constant.height(context) * 0.4,
                          width: Constant.width(context) * 0.4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(snapshot.data!['image'] ??
                                  'https://browsecat.net/sites/default/files/joker-wallpapers-51569-212800-859598.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: _customDynamicText(text: snapshot.data!['name']),
                    ),
                    _customDivider(),
                    Align(
                      child: _customFixedText(text: 'Contact Info'),
                      alignment: Alignment.centerLeft,
                    ),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        child: SizedBox(
                          width: Constant.width(context) * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _customFixedText(text: 'Email :'),
                              _customDynamicText(text: snapshot.data!['email']),
                              _customFixedText(text: 'Phone :'),
                              _customDynamicText(text: snapshot.data!['phone']),
                              if (snapshot.data!['user_type'] == 'patient')
                                _customFixedText(text: 'Bio :'),
                              if (snapshot.data!['user_type'] == 'patient')
                                _customDynamicText(
                                    text: snapshot.data!['description']),
                              if (snapshot.data!['user_type'] == 'doctor')
                                _customFixedText(text: 'Specialization :'),
                              if (snapshot.data!['user_type'] == 'doctor')
                                _customDynamicText(
                                    text: snapshot.data!['specialty']),
                              if (snapshot.data!['user_type'] == 'patient')
                                _customFixedText(text: 'Id :'),
                              if (snapshot.data!['user_type'] == 'patient')
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,

                                  children: [
                                    const SizedBox(width: 12),
                                    Text(
                                      snapshot.data!['uid'],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                        onTap: () {
                                          FlutterClipboard.copy(
                                                  snapshot.data!['uid'])
                                              .then((value) =>
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    content: Text(
                                                        'your id has been copied'),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  )));
                                        },
                                        child: Icon(Icons.copy))
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      child: _customFixedText(text: 'Personal Info'),
                      alignment: Alignment.centerLeft,
                    ),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        child: SizedBox(
                          width: Constant.width(context) * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _customFixedText(text: 'Gender :'),
                              _customDynamicText(
                                  text: snapshot.data!['gender']),
                              if (snapshot.data!['user_type'] == 'patient')
                                _customFixedText(text: 'Feeling :'),
                              if (snapshot.data!['user_type'] == 'patient')
                                _customDynamicText(
                                    text: snapshot.data!['feeling']),
                              _customFixedText(text: 'Type :'),
                              _customDynamicText(
                                  text: snapshot.data!['user_type']),
                              _customFixedText(text: 'Age :'),
                              _customDynamicText(text: snapshot.data!['age']),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (snapshot.data!['user_type'] == 'patient')
                      Align(
                        child: _customFixedText(text: 'Medical history'),
                        alignment: Alignment.centerLeft,
                      ),
                    if (snapshot.data!['user_type'] == 'patient')
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12.0),
                          child: SizedBox(
                            width: Constant.width(context) * 0.9,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!['medicalHistory'].length,
                              itemBuilder: (context,index){
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomText(
                                    fontSize: 20,
                                    text: snapshot.data!['medicalHistory'][index],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return Center(
                          child: CustomWideContainer(
                              child: const Center(
                                child: CustomText(
                                  text: 'Log out',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              height: Constant.height(context) * 0.12,
                              width: Constant.width(context) * 0.8,
                              radius: 20.0,
                              containerColor: Constant.primaryColor,
                              onTap: () async {
                                await authProvider.logOut(context);
                              }),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _customDivider() {
    return const Divider(
      thickness: 1,
      color: Colors.black87,
      indent: 50,
      endIndent: 50,
    );
  }

  Widget _customFixedText({
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: CustomText(
        text: text,
        fontSize: 20,
        color: Constant.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _customDynamicText({
    required String text,
  }) {
    return Container(
      //    alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: CustomText(
        text: text,
        fontSize: 18,
        color: Constant.primaryDarkColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
