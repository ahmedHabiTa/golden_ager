import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_text.dart';
import 'package:golden_ager/core/constant/constant.dart';

import '../../../core/common_widget/loading_widget.dart';

class HomeScreenForDoctor extends StatefulWidget {
  const HomeScreenForDoctor({Key? key}) : super(key: key);

  @override
  _HomeScreenForDoctorState createState() => _HomeScreenForDoctorState();
}

class _HomeScreenForDoctorState extends State<HomeScreenForDoctor> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('user_type', isEqualTo: 'patient')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  CustomText(
                    text: 'Patients you may know',
                    color: Constant.primaryDarkColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: Constant.width(context) * 0.9,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: Constant.width(context) * 0.55,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: Constant.height(context) * 0.2,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(snapshot
                                                .data!.docs[index]['image']),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      CustomText(
                                        text: snapshot.data!.docs[index]
                                            ['name'].toString().toUpperCase(),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: Constant.primaryDarkColor,
                                      ),
                                      const SizedBox(height: 5),
                                      CustomText(
                                        text: snapshot.data!.docs[index]
                                            ['phone'],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: Constant.primaryDarkColor,
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: Constant.width(context) * 0.3,
                                  height: Constant.height(context)*0.3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: 'Connect',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: Constant.primaryDarkColor,
                                      ),

                                      CustomText(
                                        text: 'Chat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: Constant.primaryDarkColor,
                                      ),
                                      CustomText(
                                        text: 'Report',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: Constant.primaryDarkColor,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
