import 'package:badges/badges.dart' as badge;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/models/user.dart';
import 'package:provider/provider.dart';

import '../../core/common_widget/custom_text.dart';
import '../../core/constant/constant.dart';
import '../../models/request.dart';
import '../../provider/auth_provider.dart';
import '../home/request_history_screen.dart';
import 'patient_mentor_widget.dart';
import 'request_doctor/patient_doctors.dart';

class PatientMentorsScreen extends StatefulWidget {
  const PatientMentorsScreen({Key? key}) : super(key: key);

  @override
  State<PatientMentorsScreen> createState() => _PatientMentorsScreenState();
}

class _PatientMentorsScreenState extends State<PatientMentorsScreen> {
  @override
  Widget build(BuildContext context) {
    final patient = context.watch<AuthProvider>().patient!;
    return Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: 'Medical Guide',
            color: Constant.primaryDarkColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
          actions: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("users/${patient.uid}/requests")
                    .where('status', isEqualTo: 'waiting')
                    .snapshots(),
                builder: (cyx, sh) {
                  if (sh.connectionState != ConnectionState.waiting) {
                    final List<Request> requests = sh.data!.docs
                        .map((e) => Request.fromMap(e.data()))
                        .toList();
                    return badge.Badge(
                      position: requests.isEmpty
                          ? null
                          : badge.BadgePosition.topEnd(top: 2, end: 2),
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
                              routeName: RequestHistoryScreen(
                                userId: patient.uid,
                              ),
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
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .doc("users/${patient.uid}")
                .snapshots(),
            builder: (cyx, sh) {
              if (sh.connectionState != ConnectionState.waiting) {
                final patient = Patient.fromMap(sh.data!.data()!);
                context.read<AuthProvider>().updateUserLocal(patient: patient);
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: const [
                        PatientMentorCard(),
                        Expanded(child: PatientDoctorCard())
                      ],
                    ));
              } else {
                return Container();
              }
            }));
  }
}
