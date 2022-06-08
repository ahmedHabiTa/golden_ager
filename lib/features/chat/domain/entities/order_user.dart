import 'dart:convert';

import 'package:golden_ager/models/user.dart';

class ChatUser {
  final String id;
  final String image;
  final String username;
  final String? fcmToken;
  ChatUser({
    required this.fcmToken,
    required this.id,
    required this.image,
    required this.username,
  });

  ChatUser copyWith(
      {String? id,
      String? image,
      String? username,
      String? email,
      String? phone,
      int? age,
      String? idLicence,
      String? idLicenceFace,
      String? idLicenceBack,
      String? longitude,
      String? latitude,
      String? address,
      String? fcmToken}) {
    return ChatUser(
      fcmToken: fcmToken ?? this.fcmToken,
      id: id ?? this.id,
      image: image ?? this.image,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'username': username,
      'fcm_token': fcmToken,
    };
  }

  factory ChatUser.fromAppUser(AppUser user) => ChatUser(
        fcmToken: user.fcmToken,
        id: user.uid,
        image: user.image,
        username: user.name,
      );
  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      fcmToken: map['fcm_token'],
      id: map['id'] ?? "0",
      image: map['image'] ?? '',
      username: map['username'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) =>
      ChatUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, image: $image, username: $username,)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatUser &&
        other.id == id &&
        other.image == image &&
        other.username == username;
  }

  @override
  int get hashCode {
    return id.hashCode ^ image.hashCode ^ username.hashCode;
  }
}
