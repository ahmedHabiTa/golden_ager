import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'contact.dart';
import 'medicine.dart';
import 'notification.dart';
import 'report.dart';
import 'request.dart';

class AppUser {
  final String fcmToken;
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final String age;
  final String image;
  final String gender;
  final List<AppNotification> notifications;

  AppUser({
    required this.fcmToken,
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

  AppUser copyWith(
      {String? uid,
      String? name,
      String? email,
      String? phone,
      String? userType,
      String? age,
      String? image,
      String? gender,
      List<AppNotification>? notifications,
      String? fcmToken}) {
    return AppUser(
      fcmToken: fcmToken ?? this.fcmToken,
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
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      fcmToken: map['fcm_token'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      userType: map['userType'] ?? '',
      age: map['age'] ?? '',
      image: map['image'] ?? '',
      gender: map['gender'] ?? '',
      notifications: List<AppNotification>.from(
          map['notifications']?.map((x) => AppNotification.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(uid: $uid, name: $name, email: $email, phone: $phone, userType: $userType, age: $age, image: $image, gender: $gender, notifications: $notifications,)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
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

class Patient extends AppUser {
  final String description;
  final String feeling;
  final String latitude;
  final String longitude;
  final List<String> medicalHistory;
  final List<Mentor> mentor;
  final List<Doctor> doctors;
  final List<Report> reports;
  final List<Medicine> medicines;
  final List<Contact> contacts;

  Patient({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String userType,
    required String age,
    required String image,
    required String gender,
    required String fcmToken,
    required List<AppNotification> notifications,
    required this.contacts,
    required this.medicines,
    required this.description,
    required this.feeling,
    required this.latitude,
    required this.longitude,
    required this.medicalHistory,
    required this.mentor,
    required this.doctors,
    required this.reports,
  }) : super(
            fcmToken: fcmToken,
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
  Patient copyWith(
      {String? uid,
      String? name,
      String? email,
      String? phone,
      String? userType,
      String? age,
      String? image,
      String? gender,
      String? latitude,
      String? longitude,
      List<AppNotification>? notifications,
      String? description,
      String? feeling,
      List<String>? medicalHistory,
      List<Mentor>? mentor,
      List<Medicine>? medicine,
      List<Report>? reports,
      List<Doctor>? doctors,
      String? fcmToken,
      List<Contact>? contacts}) {
    return Patient(
        contacts: contacts ?? this.contacts,
        fcmToken: fcmToken ?? this.fcmToken,
        age: age ?? this.age,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        userType: userType ?? this.userType,
        image: image ?? this.image,
        gender: gender ?? this.gender,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        medicalHistory: medicalHistory ?? this.medicalHistory,
        notifications: notifications ?? this.notifications,
        medicines: medicine ?? medicines,
        description: description ?? this.description,
        feeling: feeling ?? this.feeling,
        mentor: mentor ?? this.mentor,
        doctors: doctors ?? this.doctors,
        reports: reports ?? this.reports);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'age': age,
      'image': image,
      'gender': gender,
      'description': description,
      'feeling': feeling,
      'latitude': latitude,
      'longitude': longitude,
      'medicalHistory': medicalHistory,
      'fcm_token': fcmToken
    };
  }

  Map<String, dynamic> toMapFirstUser() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'fcm_token': fcmToken,
      'phone': phone,
      'user_type': userType,
      'age': age,
      'image': image,
      'gender': gender,
      'description': description,
      'feeling': feeling,
      'contacts': contacts.map((e) => e.toMap()).toList(),
      'mentor': mentor.map((e) => e.toMap()).toList(),
      'notifications': notifications.map((e) => e.toMap()).toList(),
      'medicines': medicines.map((e) => e.toMap()).toList(),
      'doctors': doctors.map((x) => x.toMap()).toList(),
      'reports': reports.map((e) => e.toMap()).toList()
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
        fcmToken: map['fcm_token'] ?? '',
        uid: map['uid'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        userType: map['user_type'] ?? '',
        age: map['age'] ?? '',
        image: map['image'] ?? '',
        gender: map['gender'] ?? '',
        latitude: map['latitude'] ?? '',
        longitude: map['longitude'] ?? '',
        medicalHistory: map['medicalHistory'] == null ||
                (map['medicalHistory'] as List).isEmpty
            ? []
            : List<String>.from(map['medicalHistory']?.map((x) => x)),
        contacts: map['contacts'] == null || (map['contacts'] as List).isEmpty
            ? []
            : List<Contact>.from(
                map['contacts']?.map((x) => Contact.fromMap(x))),
        notifications: map['notifications'] == null ||
                (map['notifications'] as List).isEmpty
            ? []
            : List<AppNotification>.from(
                map['notifications']?.map((x) => AppNotification.fromMap(x))),
        description: map['description'] ?? '',
        feeling: map['feeling'] ?? '',
        mentor: map['mentor'] == null || (map['mentor'] as List).isEmpty
            ? []
            : List<Mentor>.from(map['mentor']?.map((x) => Mentor.fromMap(x))),
        medicines:
            map['medicines'] == null || (map['medicines'] as List).isEmpty
                ? []
                : List<Medicine>.from(
                    map['medicines']?.map((x) => Medicine.fromMap(x))),
        doctors: map['doctors'] == null || (map['doctors'] as List).isEmpty
            ? []
            : List<Doctor>.from(map['doctors']?.map((x) => Doctor.fromMap(x))),
        reports: map['reports'] == null || (map['reports'] as List).isEmpty
            ? []
            : List<Report>.from(map['reports']?.map((x) => Report.fromMap(x))));
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

class Mentor extends AppUser {
  final List<Patient> patients;

  Mentor({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String userType,
    required String age,
    required String image,
    required String gender,
    required String fcmToken,
    required List<AppNotification> notifications,
    required this.patients,
  }) : super(
            fcmToken: fcmToken,
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
    String? fcmToken,
    List<AppNotification>? notifications,
    List<Patient>? patient,
  }) {
    return Mentor(
      fcmToken: fcmToken ?? this.fcmToken,
      age: age ?? this.age,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      notifications: notifications ?? this.notifications,
      patients: patient ?? patients,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'age': age,
      'fcm_token': fcmToken,
      'image': image,
      'gender': gender,
    };
  }

  factory Mentor.fromMap(Map<String, dynamic> map) {
    return Mentor(
      fcmToken: map['fcm_token'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      userType: map['user_type'] ?? '',
      age: map['age'] ?? '',
      image: map['image'] ?? '',
      gender: map['gender'] ?? '',
      notifications:
          map['notifications'] == null || (map['notifications'] as List).isEmpty
              ? []
              : List<AppNotification>.from(
                  map['notifications']?.map((x) => AppNotification.fromMap(x))),
      patients: map['patients'] == null || (map['patients'] as List).isEmpty
          ? []
          : List<Patient>.from(map['patients']?.map((x) => Patient.fromMap(x))),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory Mentor.fromJson(String source) => Mentor.fromMap(json.decode(source));

  @override
  String toString() => 'Mentor(patient: $patients)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mentor && other.patients == patients;
  }

  @override
  int get hashCode => patients.hashCode;
}

class Doctor extends AppUser {
  final List<Patient> patients;
  final String specialization;

  Doctor({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String userType,
    required String age,
    required String image,
    required String gender,
    required String fcmToken,
    required List<AppNotification> notifications,
    required this.patients,
    required this.specialization,
  }) : super(
            fcmToken: fcmToken,
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
    List<Request>? requests,
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? age,
    String? image,
    String? gender,
    List<AppNotification>? notifications,
    List<Patient>? patients,
    String? fcmToken,
    String? specialization,
  }) {
    return Doctor(
      fcmToken: fcmToken ?? this.fcmToken,
      specialization: specialization ?? this.specialization,
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
      'user_type': userType,
      'age': age,
      'image': image,
      'gender': gender,
      'fcm_token': fcmToken,
      'specialty': specialization,
      'notifications': notifications.map((x) => x.toMap()).toList(),
      'patients': patients.map((x) => x.toMap()).toList(),
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      fcmToken: map['fcm_token'] ?? "",
      specialization: map["specialty"] ?? "",
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      userType: map['user_type'] ?? '',
      age: map['age'] ?? '',
      image: map['image'] ?? '',
      gender: map['gender'] ?? '',
      notifications:
          map['notifications'] == null || (map['notifications'] as List).isEmpty
              ? []
              : List<AppNotification>.from(
                  map['notification']?.map((x) => AppNotification.fromMap(x))),
      patients: map['patients'] == null || (map['patients'] as List).isEmpty
          ? []
          : List<Patient>.from(map['patients']?.map((x) => Patient.fromMap(x))),
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
