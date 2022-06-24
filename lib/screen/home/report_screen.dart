import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_text.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/screen/doctor/add_report_screen.dart';

import '../../../core/common_widget/loading_widget.dart';

class ReportScreen extends StatefulWidget {
  final String doctorId;
  final String patientId;
  final String userType;
  final String doctorName;
  final String patientName;
  final String patientFcm;

  const ReportScreen({
    Key? key,
    required this.doctorId,
    required this.patientId,
    required this.userType,
    required this.doctorName,
    required this.patientName,
    required this.patientFcm,
  }) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reports')
          .doc('${widget.doctorId}-${widget.patientId}')
          .collection('${widget.doctorId}-${widget.patientId}')
          .orderBy("time")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: LoadingWidget(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: const Center(
              child: CustomText(
                text: 'Error happen',
                color: Colors.red,
                fontSize: 30,
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            body: const Center(
              child: CustomText(
                text: 'Error happen',
                color: Colors.red,
                fontSize: 30,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          print(snapshot.data!.docs.length);
          return Scaffold(
            appBar: AppBar(
              elevation: 3,
              title: CustomText(
                text: 'Reports',
                color: Constant.primaryDarkColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            floatingActionButton: widget.userType == 'doctor'
                ? FloatingActionButton(
                    backgroundColor: Constant.primaryDarkColor,
                    child: const Center(
                      child: Icon(Icons.add),
                    ),
                    onPressed: () {
                      Constant.navigateTo(
                          routeName: AddReportScreen(
                            patientID: widget.patientId,
                            doctorName: widget.doctorName,
                            patientName: widget.patientName,
                            patientFcm: widget.patientFcm,
                          ),
                          context: context);
                    },
                  )
                : Container(),
            body: Container(
              padding: Constant.kPaddingListTile,
              height: double.infinity,
              width: double.infinity,
             // color: Constant.primaryColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
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
                                  if (widget.userType != 'doctor')
                                    _customFixedText(text: 'From:'),
                                  if (widget.userType != 'doctor')
                                    _customDynamicText(
                                        text: snapshot.data!.docs[index]
                                            ['from']),
                                  if (widget.userType == 'doctor')
                                    _customFixedText(text: 'To:'),
                                  if (widget.userType == 'doctor')
                                    _customDynamicText(
                                        text: snapshot.data!.docs[index]['to']),
                                  _customFixedText(text: 'Medical Specialty:'),
                                  _customDynamicText(
                                      text: snapshot.data!.docs[index]
                                          ['medicalSpecialty']),
                                  _customFixedText(text: 'Sample Name :'),
                                  _customDynamicText(
                                      text: snapshot.data!.docs[index]
                                          ['sampleName']),
                                  _customFixedText(text: 'Description :'),
                                  _customDynamicText(
                                      text: snapshot.data!.docs[index]
                                          ['description']),
                                  _customFixedText(text: 'Problem :'),
                                  _customDynamicText(
                                      text: snapshot.data!.docs[index]
                                          ['problem']),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          );
          // return Scaffold(
          //   body: reportsList.isEmpty
          //       ? const Center(
          //           child: CustomText(
          //             text: 'There is no Reports yet !!',
          //             color: Constant.primaryDarkColor,
          //             fontSize: 25,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         )
          //       : Container(),
          //   appBar: AppBar(
          //     title: CustomText(
          //       text: 'Medical Reports',
          //       color: Constant.primaryDarkColor,
          //       fontSize: 20,
          //       fontWeight: FontWeight.w600,
          //     ),
          //     centerTitle: true,
          //     iconTheme: IconThemeData(size: 0),
          //   ),
          // );
        }
        return Container();
      },
    );
  }
}

Widget _customFixedText({
  required String text,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
    child: CustomText(
      text: text,
      fontSize: 13,
      color: Constant.primaryDarkColor,
      fontWeight: FontWeight.w300,
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
      fontSize: 15,
      color: Constant.primaryColor,
      fontWeight: FontWeight.bold,
    ),
  );
}
