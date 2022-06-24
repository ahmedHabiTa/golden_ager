import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/Constant.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../core/common_widget/custom_text.dart';
import '../../core/common_widget/custom_text_form_field.dart';

class CompletePatientDataScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String age;
  final String gender;
  final String userType;

  const CompletePatientDataScreen({
    Key? key,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.age,
    required this.gender,
    required this.userType,
  }) : super(key: key);

  @override
  State<CompletePatientDataScreen> createState() =>
      _CompletePatientDataScreenState();
}

class _CompletePatientDataScreenState extends State<CompletePatientDataScreen> {
  List<String> medicalHistory = [];
  Map<String, bool> medicalDiseases = {
    "Diabetes": false,
    "Pressure": false,
    "Heart Failuers": false,
  };

  final descController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 15),
            CustomText(
              textAlign: TextAlign.center,
              text: 'Please select any\n type of these',
              color: const Color(0xFF0d2137),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            Divider(
              thickness: 2,
              indent: 100,
              endIndent: 100,
              color: Colors.black87,
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: medicalDiseases.keys.map((String key) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: const Color(0xFF091249),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: key,
                      color: const Color(0xFF0d2137),
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: medicalDiseases[key],
                  onChanged: (value) {
                    setState(() {
                      medicalDiseases[key] = value!;
                      if(medicalHistory.contains(key)){
                        medicalHistory.remove(key);
                      }else{
                        medicalHistory.add(key);
                      }
                    });
                    print(medicalHistory);
                    //   Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomFormField(
                controller: descController,
                onChanged: (value) {
                  setState(() {
                    value = descController.text.trim();
                  });
                },
                width: Constant.width(context) * 0.9,
                height: 50,
                hintText: 'Others',
              ),
            ),
            const SizedBox(height: 10),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return GestureDetector(
                  onTap: () {
                    if (medicalHistory.isEmpty && descController.text.isEmpty) {
                      Constant.showToast(
                          message:
                              'please choose an option or Write about your medical history',
                          color: Colors.red);
                    } else if(descController.text.isNotEmpty){
                      if(medicalHistory.contains(descController.text.trim())){
                        print('موجود');
                      }else{
                        medicalHistory.add(descController.text.trim());
                        print(medicalHistory);
                      }
                      authProvider.signUp(
                        name: widget.name,
                        phone: widget.phone,
                        email: widget.email,
                        password: widget.password,
                        age: widget.age,
                        desc: descController.text,
                        gender: widget.gender,
                        userType: widget.userType,
                        specialty: '',
                        medicalHistory:medicalHistory,
                        context: context,
                      );
                     }


                  },
                  child: Container(
                    height: 40,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constant.primaryColor,
                    ),
                    child: Center(
                      child: CustomText(
                        text: 'Sign Up',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
