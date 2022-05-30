import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_text.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/core/util/shared_prefs_helper.dart';

import '../../../core/common_widget/loading_widget.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    final userUUID = SharedPrefsHelper.getData(key: 'userUUID');
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userUUID)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: LoadingWidget(),
            ),
          );
        }
        else if (snapshot.hasError) {
          return Scaffold(
            body: const Center(
              child: CustomText(
                text: 'Error happen',
                color: Colors.red,
                fontSize: 30,
              ),
            ),
          );
        }
        else if (!snapshot.hasData) {
          return Scaffold(
            body: const Center(
              child: CustomText(
                text: 'Error happen',
                color: Colors.red,
                fontSize: 30,
              ),
            ),
          );
        }
        else if (snapshot.hasData) {
          final reportsList = snapshot.data!['reports'] ;
          return Scaffold(
            body:reportsList.isEmpty ? const Center(
              child: CustomText(
                text: 'There is no Reports yet !!',
                color: Constant.primaryDarkColor,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ) : Container(),
            appBar: AppBar(
              title: CustomText(
                text: 'Medical Reports',
                color: Constant.primaryDarkColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              centerTitle: true,
              iconTheme: IconThemeData(size: 0),
            ),
          );
        }
        return Container();
      },
    );
  }
}
