import 'dart:convert';

class AppNotification {
  final String senderName;
  final String senderToken;
  final String body;
  final String category;
  final String title;
  final DateTime timeStamp;
  AppNotification({
    required this.senderName,
    required this.senderToken,
    required this.body,
    required this.category,
    required this.title,
    required this.timeStamp,
  });

  AppNotification copyWith({
    String? senderName,
    String? senderToken,
    String? body,
    String? category,
    String? title,
    DateTime? timeStamp,
  }) {
    return AppNotification(
      senderName: senderName ?? this.senderName,
      senderToken: senderToken ?? this.senderToken,
      body: body ?? this.body,
      category: category ?? this.category,
      title: title ?? this.title,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'senderToken': senderToken,
      'body': body,
      'category': category,
      'title': title,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      senderName: map['senderName'] ?? '',
      senderToken: map['senderToken'] ?? '',
      body: map['body'] ?? '',
      category: map['category'] ?? '',
      title: map['title'] ?? '',
      timeStamp: DateTime.fromMillisecondsSinceEpoch(map['timeStamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppNotification.fromJson(String source) =>
      AppNotification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppNotification(senderName: $senderName, senderToken: $senderToken, body: $body, category: $category, title: $title, timeStamp: $timeStamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppNotification &&
        other.senderName == senderName &&
        other.senderToken == senderToken &&
        other.body == body &&
        other.category == category &&
        other.title == title &&
        other.timeStamp == timeStamp;
  }

  @override
  int get hashCode {
    return senderName.hashCode ^
        senderToken.hashCode ^
        body.hashCode ^
        category.hashCode ^
        title.hashCode ^
        timeStamp.hashCode;
  }
}
