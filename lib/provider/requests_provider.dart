import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/models/user.dart';

import '../models/request.dart';

class RequestsProvider extends ChangeNotifier {
  Future<void> makeRequest(
      {required Patient patient,
      required Doctor doctor,
      required BuildContext context}) async {
    final Request request = Request(
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
    if (data.exists) {
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

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('request sended successfly'),
        backgroundColor: Colors.green,
      ));
    }
  }

  Future<void> changeRequestStatus(
      {required Request request,
      required String status,
      required BuildContext context}) async {
    try {
      // chnage request Status for the doctor
      FirebaseFirestore.instance
          .doc("users/${request.doctor.uid}/requests/${request.patient.uid}")
          .update({'status': status});
      // chnage request Status for the patient
      FirebaseFirestore.instance
          .doc("users/${request.patient.uid}/requests/${request.doctor.uid}")
          .update({"status": status});

      if (status == 'accepted') {
        // add doctor to patient data
        final patientRef =
            FirebaseFirestore.instance.doc("users/${request.patient.uid}");
        request.patient.doctors.add(request.doctor);
        patientRef.update({
          'doctors': request.patient.doctors.map((e) => e.toMap()).toList()
        });
        // add patient to doctor data
        final docRef =
            FirebaseFirestore.instance.doc("users/${request.doctor.uid}");
        request.doctor.patients.add(request.patient);
        docRef.update({
          'patients': request.doctor.patients.map((e) => e.toMap()).toList()
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('request $status successfly'),
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

  Stream<List<Request>> getRequests({required String uid}) {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('users/$uid/requests')
        .orderBy('time_stamp', descending: true)
        .snapshots();
    return stream.map((qShot) => qShot.docs
        .map((doc) => Request.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
