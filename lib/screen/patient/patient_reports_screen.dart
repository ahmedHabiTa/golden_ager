import 'package:flutter/material.dart';

import '../../core/common_widget/custom_text.dart';
import '../../core/constant/constant.dart';
import 'request_doctor/patient_doctors.dart';
import 'patient_mentor_widget.dart';

class PatientReportsScreen extends StatefulWidget {
  const PatientReportsScreen({Key? key}) : super(key: key);

  @override
  State<PatientReportsScreen> createState() => _PatientReportsScreenState();
}

class _PatientReportsScreenState extends State<PatientReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: 'Medical Guide',
            color: Constant.primaryDarkColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(size: 0),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: const [
                PatientMentorCard(),
                Expanded(child: PatientDoctorCard())
              ],
            )));
  }
}
