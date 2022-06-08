import 'dart:convert';

import 'package:golden_ager/models/user.dart';

class Request {
  final String uid;
  final String fromId;
  final String toId;
  final Patient patient;
  final Doctor? doctor;
  final Mentor? mentor;
  String status; // waiting, accepted, declined
  final DateTime timeStamp;
  final String requestType; // mentor , doctor
  Request({
    required this.uid,
    required this.fromId,
    required this.toId,
    required this.patient,
    this.doctor,
    this.mentor,
    required this.status,
    required this.timeStamp,
    required this.requestType,
  });

  Request copyWith({
    String? uid,
    String? fromId,
    String? toId,
    Patient? patient,
    Doctor? doctor,
    Mentor? mentor,
    String? status,
    DateTime? timeStamp,
    String? requestType,
  }) {
    return Request(
      uid: uid ?? this.uid,
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
      patient: patient ?? this.patient,
      doctor: doctor ?? this.doctor,
      mentor: mentor ?? this.mentor,
      status: status ?? this.status,
      timeStamp: timeStamp ?? this.timeStamp,
      requestType: requestType ?? this.requestType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fromId': fromId,
      'toId': toId,
      'patient': patient.toMap(),
      'doctor': doctor?.toMap(),
      'mentor': mentor?.toMap(),
      'status': status,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'requestType': requestType,
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      uid: map['uid'] ?? '',
      fromId: map['fromId'] ?? '',
      toId: map['toId'] ?? '',
      patient: Patient.fromMap(map['patient']),
      doctor: map['doctor'] != null ? Doctor.fromMap(map['doctor']) : null,
      mentor: map['mentor'] != null ? Mentor.fromMap(map['mentor']) : null,
      status: map['status'] ?? '',
      timeStamp: DateTime.fromMillisecondsSinceEpoch(map['timeStamp']),
      requestType: map['requestType'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) =>
      Request.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Request(uid: $uid, fromId: $fromId, toId: $toId, patient: $patient, doctor: $doctor, mentor: $mentor, status: $status, timeStamp: $timeStamp, requestType: $requestType)';
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
        other.mentor == mentor &&
        other.status == status &&
        other.timeStamp == timeStamp &&
        other.requestType == requestType;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fromId.hashCode ^
        toId.hashCode ^
        patient.hashCode ^
        doctor.hashCode ^
        mentor.hashCode ^
        status.hashCode ^
        timeStamp.hashCode ^
        requestType.hashCode;
  }
}
