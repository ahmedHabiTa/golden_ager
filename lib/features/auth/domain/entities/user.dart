import 'dart:convert';

class User {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final String age;
  final String gender;
  final String address;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.age,
    required this.gender,
    required this.address,
  });

  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? age,
    String? gender,
    String? address,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: uid ?? this.name,
      email: uid ?? this.email,
      phone: uid ?? this.phone,
      userType: uid ?? this.userType,
      age: uid ?? this.age,
      gender: gender ?? this.gender,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "phone": phone,
      "userType": userType,
      "age": age,
      "gender": gender,
      "address": address,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      userType: map['userType'],
      age: map['age'],
      gender: map['gender'],
      address: map['address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return "User(uid: $uid, name: $name, email: $email, phone: $phone , userType: $userType, age: $age, gender: $gender , address: $address)";
  }
}
