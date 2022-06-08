import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/util/shared_prefs_helper.dart';
import 'package:golden_ager/screen/home/widgets/notification_card.dart';

import '../../core/common_widget/custom_text.dart';
import '../../core/common_widget/loading_widget.dart';
import '../../core/constant/Constant.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final userUUID = SharedPrefsHelper.getData(key: 'userUUID');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: 'Notifications',
            color:Constant.primaryDarkColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Constant.primaryDarkColor,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 80.0),
                    child: LoadingWidget(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: CustomText(
                      text: 'No Notifications yet!!',
                      color: Colors.red,
                      fontSize: 30,
                    ),
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
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return NotificationsCard(
                        title: snapshot.data!.docs[index]['title'],
                        body: snapshot.data!.docs[index]['body'],
                        category: snapshot.data!.docs[index]['category'],
                        from: snapshot.data!.docs[index]['senderName'],
                      );
                    },
                  );
                }
                return Container();
              },
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .doc(userUUID)
                  .collection('notifications').orderBy('timeStamp',descending: true)
                  .snapshots(),
            ),
          ),
        ),
      ),
    );
  }
}
