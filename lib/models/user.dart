import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:golden_ager/models/notification.dart';
import 'package:golden_ager/models/report.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final String age;
  final String image;
  final String gender;
  final List<Notification> notifications;
  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.age,
    required this.image,
    required this.gender,
    required this.notifications,
  });

  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? age,
    String? image,
    String? gender,
    List<Notification>? notifications,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      age: age ?? this.age,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      notifications: notifications ?? this.notifications,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'age': age,
      'image': image,
      'gender': gender,
      'notifications': notifications.map((x) => x.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      userType: map['userType'] ?? '',
      age: map['age'] ?? '',
      image: map['image'] ?? '',
      gender: map['gender'] ?? '',
      notifications: List<Notification>.from(
          map['notifications']?.map((x) => Notification.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(uid: $uid, name: $name, email: $email, phone: $phone, userType: $userType, age: $age, image: $image, gender: $gender, notifications: $notifications)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.userType == userType &&
        other.age == age &&
        other.image == image &&
        other.gender == gender &&
        listEquals(other.notifications, notifications);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        userType.hashCode ^
        age.hashCode ^
        image.hashCode ^
        gender.hashCode ^
        notifications.hashCode;
  }
}

class Patient extends User {
  final String description;
  final String feeling;
  final Mentor mentor;
  final List<Doctor> doctors;
  final List<Report> reports;
  Patient({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String userType,
    required String age,
    required String image,
    required String gender,
    required List<Notification> notifications,
    required this.description,
    required this.feeling,
    required this.mentor,
    required this.doctors,
    required this.reports,
  }) : super(
            age: age,
            uid: uid,
            name: name,
            phone: phone,
            email: email,
            userType: userType,
            image: image,
            gender: gender,
            notifications: notifications);

  @override
  Patient copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? age,
    String? image,
    String? gender,
    List<Notification>? notifications,
    String? description,
    String? feeling,
    Mentor? mentor,
    List<Report>? reports,
    List<Doctor>? doctors,
  }) {
    return Patient(
        age: age ?? this.age,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        userType: userType ?? this.userType,
        image: image ?? this.image,
        gender: gender ?? this.gender,
        notifications: notifications ?? this.notifications,
        description: description ?? this.description,
        feeling: feeling ?? this.feeling,
        mentor: mentor ?? this.mentor,
        doctors: doctors ?? this.doctors,
        reports: reports ?? this.reports);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'feeling': feeling,
      'mentor': mentor.toMap(),
      'doctors': doctors.map((x) => x.toMap()).toList(),
      'reports': reports.map((e) => e.toMap()).toList()
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
        uid: map['uid'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        userType: map['userType'] ?? '',
        age: map['age'] ?? '',
        image: map['image'] ?? '',
        gender: map['gender'] ?? '',
        notifications: List<Notification>.from(
            map['notifications']?.map((x) => Notification.fromMap(x))),
        description: map['description'] ?? '',
        feeling: map['feeling'] ?? '',
        mentor: Mentor.fromMap(map['mentor']),
        doctors:
            List<Doctor>.from(map['doctors']?.map((x) => Doctor.fromMap(x))),
        reports:
            List<Report>.from(map['reports']?.map((x) => Report.fromMap(x))));
  }

  @override
  String toJson() => json.encode(toMap());

  factory Patient.fromJson(String source) =>
      Patient.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Patient(description: $description, feeling: $feeling, mentor: $mentor, doctors: $doctors)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Patient &&
        other.description == description &&
        other.feeling == feeling &&
        other.mentor == mentor &&
        listEquals(other.doctors, doctors);
  }

  @override
  int get hashCode {
    return description.hashCode ^
        feeling.hashCode ^
        mentor.hashCode ^
        doctors.hashCode;
  }
}

class Mentor extends User {
  final Patient patient;
  Mentor({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String userType,
    required String age,
    required String image,
    required String gender,
    required List<Notification> notifications,
    required this.patient,
  }) : super(
            age: age,
            uid: uid,
            name: name,
            phone: phone,
            email: email,
            userType: userType,
            image: image,
            gender: gender,
            notifications: notifications);

  @override
  Mentor copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? age,
    String? image,
    String? gender,
    List<Notification>? notifications,
    Patient? patient,
  }) {
    return Mentor(
      age: age ?? this.age,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      notifications: notifications ?? this.notifications,
      patient: patient ?? this.patient,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'age': age,
      'image': image,
      'gender': gender,
      'notifications': notifications.map((x) => x.toMap()).toList(),
      'patient': patient.toMap(),
    };
  }

  factory Mentor.fromMap(Map<String, dynamic> map) {
    return Mentor(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      userType: map['userType'] ?? '',
      age: map['age'] ?? '',
      image: map['image'] ?? '',
      gender: map['gender'] ?? '',
      notifications: List<Notification>.from(
          map['notifications']?.map((x) => Notification.fromMap(x))),
      patient: Patient.fromMap(map['patient']),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory Mentor.fromJson(String source) => Mentor.fromMap(json.decode(source));

  @override
  String toString() => 'Mentor(patient: $patient)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mentor && other.patient == patient;
  }

  @override
  int get hashCode => patient.hashCode;
}

class Doctor extends User {
  final List<Patient> patients;
  Doctor({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String userType,
    required String age,
    required String image,
    required String gender,
    required List<Notification> notifications,
    required this.patients,
  }) : super(
            age: age,
            uid: uid,
            name: name,
            phone: phone,
            email: email,
            userType: userType,
            image: image,
            gender: gender,
            notifications: notifications);

  @override
  Doctor copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? age,
    String? image,
    String? gender,
    List<Notification>? notifications,
    List<Patient>? patients,
  }) {
    return Doctor(
      age: age ?? this.age,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      notifications: notifications ?? this.notifications,
      patients: patients ?? this.patients,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'age': age,
      'image': image,
      'gender': gender,
      'notifications': notifications.map((x) => x.toMap()).toList(),
      'patients': patients.map((x) => x.toMap()).toList(),
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      userType: map['userType'] ?? '',
      age: map['age'] ?? '',
      image: map['image'] ?? '',
      gender: map['gender'] ?? '',
      notifications: List<Notification>.from(
          map['notifications']?.map((x) => Notification.fromMap(x))),
      patients:
          List<Patient>.from(map['patients']?.map((x) => Patient.fromMap(x))),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory Doctor.fromJson(String source) => Doctor.fromMap(json.decode(source));

  @override
  String toString() => 'Doctor(patients: $patients)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Doctor && listEquals(other.patients, patients);
  }

  @override
  int get hashCode => patients.hashCode;
}
