import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/common_widget/custom_text.dart';
import '../../../core/common_widget/loading_widget.dart';
import '../../../core/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class TipsDetailsScreen extends StatelessWidget {
  final String docId;

  const TipsDetailsScreen({
    Key? key,
    required this.docId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tips')
            .doc(docId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: customCard(
                        image: snapshot.data!['videos'][index]['image'],
                        title: snapshot.data!['videos'][index]['title'],
                        onTap: () {
                          UrlLauncher.launchUrl(Uri.parse(
                              snapshot.data!['videos'][index]['link']));
                        },
                        context: context,
                        width: Constant.width(context) * 0.9,
                        height: Constant.height(context) * 0.5,
                        color: Colors.white),
                  ),
                );
              },
              itemCount: snapshot.data!['videos'].length,
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget customCard({
    required double height,
    required double width,
    required Function onTap,
    required String image,
    required String title,
    required Color color,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 5),
              Container(
                height: Constant.height(context) * 0.35,
                width: Constant.width(context) * 0.9,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(image),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              CustomText(
                text: title,
                color: Constant.primaryDarkColor,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
