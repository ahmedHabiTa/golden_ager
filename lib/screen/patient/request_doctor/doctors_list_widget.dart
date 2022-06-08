import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/common_widget/custom_text.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/provider/requests_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/common_widget/loading_widget.dart';
import '../../../models/user.dart';
import '../../../provider/auth_provider.dart';
import '../../home/request_history_screen.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({Key? key}) : super(key: key);

  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  @override
  Widget build(BuildContext context) {
    final patient = context.read<AuthProvider>().patient!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctors',
          style: Constant.mediumTextStyle,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Constant.navigateTo(
                  routeName: RequestHistoryScreen(
                    userId: context.read<AuthProvider>().patient!.uid,
                  ),
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
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('user_type', isEqualTo: 'doctor')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: LoadingWidget(),
                );
              } else if (snapshot.hasData) {
                final List<Doctor> doctors = snapshot.data!.docs
                    .map(
                        (e) => Doctor.fromMap(e.data() as Map<String, dynamic>))
                    .toList();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'click to connect to send follow up request',
                          style: Constant.normalTextStyle,
                        ),
                      ),
                      ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            color: Constant.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4.0),
                                  width: 100,
                                  height: Constant.height(context) * 0.2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(doctors[index].image),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                CustomText(
                                  text: "name: " +
                                      doctors[index]
                                          .name
                                          .toString()
                                          .toUpperCase(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 5),
                                CustomText(
                                  text: 'Anesthesiology',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                CustomText(
                                  text:
                                      "number of patient on the app right now " +
                                          doctors[index]
                                              .patients
                                              .length
                                              .toString(),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .doc(
                                          "users/${doctors[index].uid}/requests/${patient.uid}")
                                      .snapshots(),
                                  builder: (context, sh) => sh
                                              .connectionState ==
                                          ConnectionState.waiting
                                      ? Center(
                                          child: Constant.indicator(),
                                        )
                                      : sh.data!.exists
                                          ? patient.doctors
                                                  .where((element) =>
                                                      element.uid ==
                                                      doctors[index].uid)
                                                  .isNotEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "this doctor is follow up with you already",
                                                    style: Constant
                                                        .normalTextStyle
                                                        .copyWith(
                                                            color:
                                                                Colors.amber),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "you have been send request already",
                                                    style: Constant
                                                        .normalTextStyle
                                                        .copyWith(
                                                            color:
                                                                Colors.amber),
                                                  ),
                                                )
                                          : ConnectButton(
                                              doctor: doctors[index]),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          )),
    );
  }
}

class ConnectButton extends StatefulWidget {
  const ConnectButton({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  final Doctor doctor;

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
  bool isLoading = false;
  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: Constant.indicator(color: Colors.white))
        : ElevatedButton(
            onPressed: () async {
              toggleIsLoading();
              await context.read<RequestsProvider>().makeDoctorRequest(
                  context: context,
                  patient: context.read<AuthProvider>().patient!,
                  doctor: widget.doctor);
              Future.delayed(Duration(seconds: 1));
              toggleIsLoading();
            },
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: CustomText(
              text: 'Connect',
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: Constant.primaryColor,
            ),
          );
  }
}
