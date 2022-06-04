import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/models/request.dart';
import 'package:golden_ager/provider/requests_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../home/request_history_screen.dart';

class DoctoreRequestsScreen extends StatelessWidget {
  const DoctoreRequestsScreen({Key? key, required this.requests})
      : super(key: key);
  final List<Request> requests;
  @override
  Widget build(BuildContext context) {
    final docor = context.watch<AuthProvider>().doctor!;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Requests',
            style: Constant.semieBoldTextStyle,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Constant.navigateTo(
                    routeName: RequestHistory(
                        userId: context.read<AuthProvider>().doctor!.uid),
                    context: context);
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.history,
                  )),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("users/${docor.uid}/requests")
                .where('status', isEqualTo: 'waiting')
                .snapshots(),
            builder: (cyx, sh) {
              if (sh.connectionState != ConnectionState.waiting) {
                final List<Request> requests = sh.data!.docs
                    .map((e) => Request.fromMap(e.data()))
                    .toList();
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: requests.length,
                          itemBuilder: (context, index) => RequestsItem(
                                isDoctorPreview: true,
                                request: requests[index],
                              )),
                    )
                  ],
                );
              } else {
                return Container();
              }
            }));
  }
}

class RequestsItem extends StatelessWidget {
  final Request request;
  final bool isDoctorPreview;
  RequestsItem({Key? key, required this.request, required this.isDoctorPreview})
      : super(key: key);

  final Map<String, Color> colorByStatus = {
    "waiting": Colors.amber,
    "accepted": Colors.green,
    "declined": Colors.red
  };
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(8),
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: !isDoctorPreview
            ? Column(children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Constant.primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Request to be Mentor",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                infoListTile("doctor name : ", request.doctor.name),
                infoListTile("age : ", request.doctor.age),
                infoListTile("gender : ", request.doctor.gender),
                infoListTile("status : ", request.status,
                    color: colorByStatus[request.status]!),
              ])
            : Column(children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Constant.primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Request to be Mentor",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                infoListTile("patient name : ", request.patient.name),
                infoListTile("age : ", request.patient.age),
                infoListTile("gender : ", request.patient.gender),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      onPressed: () async {
                        await context
                            .read<RequestsProvider>()
                            .changeRequestStatus(
                                context: context,
                                request: request,
                                status: 'accepted');
                      },
                      child: Text("Accept",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: () async {
                        await context
                            .read<RequestsProvider>()
                            .changeRequestStatus(
                                context: context,
                                request: request,
                                status: 'declined');
                      },
                      child: Text("Decline",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ]));
  }

  Padding infoListTile(
    String text1,
    String text2, {
    Color color = Constant.primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(children: [
        Text(text1,
            style: TextStyle(
                color: Constant.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Text(text2,
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.bold))
      ]),
    );
  }
}
