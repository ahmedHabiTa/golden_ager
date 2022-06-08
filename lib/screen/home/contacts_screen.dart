import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/models/user.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../core/common_widget/custom_text.dart';
import '../../core/common_widget/custom_text_form_field.dart';
import '../../core/common_widget/custom_wide_buttom.dart';
import '../../core/common_widget/loading_widget.dart';
import '../../core/constant/Constant.dart';
import '../../provider/home_provider.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Patient? patient;

  @override
  void initState() {
    super.initState();
    patient = context.read<AuthProvider>().patient;
  }

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  bool visible = false;
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                visible = !visible;
              });
            },
            child: Icon(
              Icons.add_circle_outline,
              color: Constant.primaryColor,
              size: 50,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        title: CustomText(
          text: 'Contacts',
          color: Constant.primaryDarkColor,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              visible == false
                  ? Container()
                  : Form(
                      key: formKey,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            CustomFormField(
                              prefix: const Icon(
                                Icons.person,
                                color: Colors.black87,
                                size: 30,
                              ),
                              controller: nameController,
                              onChanged: (value) {
                                setState(() {
                                  value = nameController.text.trim();
                                });
                              },
                              validation: 'Name is required',
                              width: double.infinity,
                              height: 50,
                              labelText: 'Name',
                              hintText: '',
                            ),
                            const SizedBox(height: 10),
                            CustomFormField(
                              prefix: const Icon(
                                Icons.person,
                                color: Colors.black87,
                                size: 30,
                              ),
                              controller: phoneController,
                              onChanged: (value) {
                                setState(() {
                                  value = phoneController.text.trim();
                                });
                              },
                              validation: 'Phone is required',
                              width: double.infinity,
                              height: 50,
                              labelText: 'Phone',
                              inputType: TextInputType.number,
                              hintText: '',
                            ),
                            const SizedBox(height: 10),
                            Consumer<HomeProvider>(
                              builder: (context, homeProvider, _) {
                                return isLoading == true
                                    ? CircularProgressIndicator(
                                        color: Constant.primaryDarkColor,
                                      )
                                    : CustomWideButton(
                                        height: Constant.height(context) * 0.1,
                                        width: Constant.width(context) * 0.8,
                                        radius: 20.0,
                                        color: const Color(0xFF003473),
                                        onTap: () async {
                                          if (!formKey.currentState!
                                              .validate()) {
                                            return;
                                          } else {
                                            toggleLoading();
                                            await homeProvider
                                                .addContact(
                                              userUUID: patient!.uid,
                                              context: context,
                                              name: nameController.text
                                                  .toString()
                                                  .trim(),
                                              phone: phoneController.text
                                                  .toString()
                                                  .trim(),
                                            )
                                                .then((value) {
                                              nameController.clear();
                                              phoneController.clear();
                                              setState(() {
                                                visible = false;
                                              });
                                            });
                                            toggleLoading();
                                          }
                                        },
                                        child: const Center(
                                          child: CustomText(
                                            text: 'Add new Contact',
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              if(patient!.mentor != null)
              _customCard(
                name: patient!.mentor[0].name,
                phone: patient!.mentor[0].phone,
              ),
              if(patient!.mentor != null)
              _customCard(
                name: patient!.doctors[0].name,
                phone: patient!.doctors[0].phone,
              ),
              StreamBuilder<DocumentSnapshot>(
                builder: (context, snapshot) {
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
                    return ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _customCard(
                          name: snapshot.data!['contacts'][index]['name'],
                          phone: snapshot.data!['contacts'][index]['phone'],
                        );
                      },
                      itemCount: snapshot.data!['contacts'].length,
                    );
                  }
                  return Container();
                },
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(patient!.uid)
                    .snapshots(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customCard({
    required String name,
    required String phone,
  }) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  color: Constant.primaryDarkColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  text: phone,
                  color: Constant.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () async {
                await launchUrl(Uri(
                  scheme: 'tel',
                  path: phone.toString(),
                ));
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    shape: BoxShape.rectangle,
                    color: Colors.green),
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
