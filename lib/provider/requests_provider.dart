import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/models/user.dart';
import 'package:golden_ager/provider/auth_provider.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../core/error/exceptions.dart';
import '../models/notification.dart';
import '../models/request.dart';

class RequestsProvider extends ChangeNotifier {
  // should send FCM to doctor
  Future<void> makeDoctorRequest(
      {required Patient patient,
      required Doctor doctor,
      required BuildContext context}) async {
    final Request request = Request(
        requestType: 'doctor',
        timeStamp: DateTime.now(),
        uid: patient.uid,
        fromId: patient.uid,
        toId: doctor.uid,
        patient: patient,
        doctor: doctor,
        status: 'waiting');
    // add to docotr requests collection
    final docRef = FirebaseFirestore.instance
        .doc("users/${doctor.uid}/requests/${patient.uid}");
    final data = await docRef.get();
    // check if patient send request before
    if (data.exists && data.data()!['status'] == "waiting") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('pervious request in waiting'),
        backgroundColor: Colors.grey,
      ));
    } else {
      await docRef.set(request.toMap());
      FirebaseFirestore.instance
          .doc("users/${patient.uid}/requests/${doctor.uid}")
          .set(request.toMap());
      final AppNotification notification = AppNotification(
          senderName: patient.name,
          senderToken: doctor.fcmToken,
          body: "${patient.name} needs your help ",
          category: "request",
          title: "Request",
          timeStamp: DateTime.now());
      await sendNotification(notification: notification, reciverID: doctor.uid);
    }
  }

  // should send FCM to patient
  Future<void> changeDoctorRequestStatus(
      {required Request request,
      required String status,
      required BuildContext context}) async {
    try {
      // chnage request Status for the doctor
      FirebaseFirestore.instance
          .doc("users/${request.doctor!.uid}/requests/${request.patient.uid}")
          .update({'status': status});
      // chnage request Status for the patient
      FirebaseFirestore.instance
          .doc("users/${request.patient.uid}/requests/${request.doctor!.uid}")
          .update({"status": status}).then((value) async {
        final AppNotification notification = AppNotification(
            senderName: request.doctor!.name,
            senderToken: request.patient.fcmToken,
            body: "${request.doctor!.name} has $status your request ",
            category: "request",
            title: "Request",
            timeStamp: DateTime.now());
        await sendNotification(
            notification: notification, reciverID: request.patient.uid);
      });

      if (status == 'accepted') {
        // add doctor to patient data
        final patientRef =
            FirebaseFirestore.instance.doc("users/${request.patient.uid}");
        request.patient.doctors.add(request.doctor!);
        patientRef.update({
          'doctors': request.patient.doctors.map((e) => e.toMap()).toList()
        });
        // add patient to doctor data
        final docRef =
            FirebaseFirestore.instance.doc("users/${request.doctor!.uid}");
        request.doctor!.patients.add(request.patient);
        docRef.update({
          'patients': request.doctor!.patients.map((e) => e.toMap()).toList()
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('request $status successfully'),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('error happend'),
        backgroundColor: Colors.red,
      ));
    }
  }

// send to patient
  Future<void> makeMentorRequest(
      {required String patientId,
      required Mentor mentor,
      required BuildContext context}) async {
    final patientRef =
        await FirebaseFirestore.instance.doc("users/$patientId").get();
    if (!patientRef.exists || patientRef.data()!["user_type"] != 'patient') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Invaild patient id'),
        backgroundColor: Colors.red,
      ));
      return;
    } else {
      final Patient patient =
          Patient.fromMap(patientRef.data() as Map<String, dynamic>);
      final Request request = Request(
          requestType: "mentor",
          timeStamp: DateTime.now(),
          uid: patient.uid,
          fromId: mentor.uid,
          toId: patient.uid,
          patient: patient,
          mentor: mentor,
          status: 'waiting');
      // add to docotr requests collection
      final mentorRef = FirebaseFirestore.instance
          .doc("users/${mentor.uid}/requests/${patient.uid}");
      final data = await mentorRef.get();
      // check if patient send request before
      if (data.exists && data.data()!['status'] == "waiting") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1),
          content: Text('pervious request in waiting'),
          backgroundColor: Colors.grey,
        ));
      } else {
        await mentorRef.set(request.toMap());
        FirebaseFirestore.instance
            .doc("users/${patient.uid}/requests/${mentor.uid}")
            .set(request.toMap());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1),
          content: Text('request sended successfly'),
          backgroundColor: Colors.green,
        ));
        final AppNotification notification = AppNotification(
            senderName: mentor.name,
            senderToken: patient.fcmToken,
            body: "${mentor.name} wants to be your MENTOR ",
            category: "request",
            title: "Request",
            timeStamp: DateTime.now());
        await sendNotification(
            notification: notification, reciverID: patient.uid);
      }
    }
  }

// send to mentor
  Future<void> changeMentorRequestStatus(
      {required Request request,
      required String status,
      required BuildContext context}) async {
    try {
      // chnage request Status for the doctor
      FirebaseFirestore.instance
          .doc("users/${request.mentor!.uid}/requests/${request.patient.uid}")
          .update({'status': status});
      // chnage request Status for the patient
      FirebaseFirestore.instance
          .doc("users/${request.patient.uid}/requests/${request.mentor!.uid}")
          .update({"status": status}).then((value)async{

        print('hhhhhhhhhhhhhhh');
        final AppNotification notification = AppNotification(
            senderName: request.patient.name,
            senderToken: request.mentor!.fcmToken,
            body: "${request.patient.name} has $status your request ",
            category: "request",
            title: "Request",
            timeStamp: DateTime.now());
        await sendNotification(
            notification: notification, reciverID: request.mentor!.uid);
      });

      if (status == 'accepted') {
        // add doctor to patient data
        final patientRef =
            FirebaseFirestore.instance.doc("users/${request.patient.uid}");
        request.patient.mentor.add(request.mentor!);
        patientRef.update(
            {'mentor': request.patient.mentor.map((e) => e.toMap()).toList()});
        // add patient to doctor data
        final mentorRef =
            FirebaseFirestore.instance.doc("users/${request.mentor!.uid}");
        request.mentor!.patients.add(request.patient);
        mentorRef.update({
          'patients': request.mentor!.patients.map((e) => e.toMap()).toList()
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('request $status successfly'),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('error happend'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Stream<List<Request>> getRequests({required String uid}) {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('users/$uid/requests')
        .orderBy('time_stamp', descending: true)
        .snapshots();
    return stream.map((qShot) => qShot.docs
        .map((doc) => Request.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> sendNotification(
      {required AppNotification notification,
      required String reciverID}) async {
    await sendPushMessage(notification: notification);
    await FirebaseFirestore.instance
        .collection("notifications/$reciverID/notifications")
        .add(notification.toMap());
  }

  Future<void> sendPushMessage({required AppNotification notification}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAA1qlt7Qg:APA91bGGGR-c_wv3L7BPGby8TqBDX6dgJK3WT455n3zNRj5tOS68ReSQKtsO02q25cKKFKim4m7Vp_JlkZAYSQfX176WZ5y4JIlHl3aMtdbJ87v9MDiPPi_wcqg7ZM_isFYSutu0GHnI'
        },
        body: jsonEncode({
          'to': notification.senderToken,
          'data': {
            'via': 'FlutterFire Cloud Messaging!!!',
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "category": notification.category,
          },
          'notification': {
            'title': notification.title,
            'body': notification.body,
            "sound": "default"
          },
        }),
      );
    } catch (e) {
      throw ServerException();
    }
  }
}
