import 'dart:convert';

import 'package:golden_ager/models/user.dart';

class Request {
  final String uid;
  final String fromId;
  final String toId;
  final Patient patient;
  final Doctor doctor;
  String status; // waiting, accepted, declined
  final DateTime timeStamp;
  Request({
    required this.uid,
    required this.fromId,
    required this.toId,
    required this.patient,
    required this.doctor,
    required this.status,
    required this.timeStamp,
  });

  Request copyWith({
    String? uid,
    String? fromId,
    String? toId,
    Patient? patient,
    Doctor? doctor,
    String? status,
    DateTime? timeStamp,
  }) {
    return Request(
      uid: uid ?? this.uid,
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
      patient: patient ?? this.patient,
      doctor: doctor ?? this.doctor,
      status: status ?? this.status,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fromId': fromId,
      'toId': toId,
      'patient': patient.toMap(),
      'doctor': doctor.toMap(),
      'status': status,
      'time_stamp': timeStamp.millisecondsSinceEpoch,
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      uid: map['uid'] ?? '',
      fromId: map['fromId'] ?? '',
      toId: map['toId'] ?? '',
      patient: Patient.fromMap(map['patient']),
      doctor: Doctor.fromMap(map['doctor']),
      status: map['status'] ?? '',
      timeStamp: DateTime.fromMillisecondsSinceEpoch(map['time_stamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) =>
      Request.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Request(uid: $uid, fromId: $fromId, toId: $toId, patient: $patient, doctor: $doctor, status: $status, time_stamp: $timeStamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Request &&
        other.uid == uid &&
        other.fromId == fromId &&
        other.toId == toId &&
        other.patient == patient &&
        other.doctor == doctor &&
        other.status == status &&
        other.timeStamp == timeStamp;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fromId.hashCode ^
        toId.hashCode ^
        patient.hashCode ^
        doctor.hashCode ^
        status.hashCode ^
        timeStamp.hashCode;
  }
}
