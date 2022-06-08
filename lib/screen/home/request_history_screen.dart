import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/models/request.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../core/common_widget/loading_widget.dart';
import '../../core/constant/constant.dart';
import 'request_screen.dart';

class RequestHistoryScreen extends StatefulWidget {
  const RequestHistoryScreen({Key? key, required this.userId})
      : super(key: key);
  final String userId;

  @override
  State<RequestHistoryScreen> createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Requests History',
            style: Constant.mediumTextStyle,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users/${widget.userId}/requests')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 80.0),
                      child: LoadingWidget(),
                    );
                  } else {
                    print(snapshot.data!.docs[0]['status']);
                    final requests = snapshot.data!.docs
                        .map((e) =>
                            Request.fromMap(e.data() as Map<String, dynamic>))
                        .toList();
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: requests.length,
                              itemBuilder: (context, index) => RequestsItem(
                                    userPerview:
                                        context.read<AuthProvider>().userType!,
                                    request: requests[index],
                                  )),
                        )
                      ],
                    );
                  }
                })));
  }
}
