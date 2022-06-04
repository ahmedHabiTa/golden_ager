import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/common_widget/custom_wide_buttom.dart';
import '../../../core/common_widget/report_form_field.dart';

class AddReportScreen extends StatefulWidget {
  final String patientID;
  final String doctorName;
  final String patientName;

  const AddReportScreen({
    Key? key,
    required this.patientID,
    required this.doctorName,
    required this.patientName,
  }) : super(key: key);

  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final medicalSpecialty = TextEditingController();
  final sampleName = TextEditingController();
  final description = TextEditingController();
  final problem = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
  @override
  Widget build(BuildContext context) {
    print(widget.patientID);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: SizedBox(
              width: Constant.width(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const CustomText(
                          text: 'Post Report',
                          color: Color(0xFF091249),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 10),
                        ReportFormField(
                          controller: medicalSpecialty,
                          onChanged: (value) {
                            setState(() {
                              value = medicalSpecialty.text.trim();
                            });
                          },
                          validation: 'field is required',
                          width: Constant.width(context) * 0.9,
                          height: 50,
                          labelText: 'Medical Specialty',
                          hintText: '',
                        ),
                        const SizedBox(height: 10),
                        ReportFormField(
                          controller: sampleName,
                          onChanged: (value) {
                            setState(() {
                              value = sampleName.text.trim();
                            });
                          },
                          validation: 'field is required',
                          width: Constant.width(context) * 0.9,
                          height: 50,
                          labelText: 'Sample Name',
                          hintText: '',
                        ),
                        const SizedBox(height: 10),
                        ReportFormField(
                          maxLine: 2,
                          controller: problem,
                          onChanged: (value) {
                            setState(() {
                              value = problem.text.trim();
                            });
                          },
                          validation: 'field is required',
                          width: Constant.width(context) * 0.9,
                          height: 50,
                          labelText: 'Problem',
                          hintText: '',
                        ),
                        const SizedBox(height: 10),
                        ReportFormField(
                          maxLine: 5,
                          controller: description,
                          onChanged: (value) {
                            setState(() {
                              value = description.text.trim();
                            });
                          },
                          validation: 'field is required',
                          width: Constant.width(context) * 0.9,
                          height: 50,
                          labelText: 'Description',
                          hintText: '',
                        ),
                        const SizedBox(height: 10),
                        CustomWideButton(
                          radius: 10.0,
                          height: 40,
                          width: 130,
                          color: Constant.primaryDarkColor,
                          onTap: () async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            } else {
                              //implement from and to
                              toggleLoading();
                              await authProvider.postReportForDoctor(
                                context: context,
                                patientID: widget.patientID,
                                description: description.text.trim(),
                                from: widget.doctorName,
                                to: widget.patientName,
                                medicalSpecialty: medicalSpecialty.text.trim(),
                                problem: problem.text.trim(),
                                sampleName: sampleName.text.trim(),
                              );
                              toggleLoading();
                            }
                          },
                          child: const Center(
                            child: CustomText(
                              text: 'Post',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
