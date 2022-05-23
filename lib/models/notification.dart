import 'dart:convert';

class Notification {
  final String content;
  final String time;
  Notification({
    required this.content,
    required this.time,
  });

  Notification copyWith({
    String? content,
    String? time,
  }) {
    return Notification(
      content: content ?? this.content,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'time': time,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      content: map['content'] ?? '',
      time: map['time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source));

  @override
  String toString() => 'Notification(content: $content, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notification &&
        other.content == content &&
        other.time == time;
  }

  @override
  int get hashCode => content.hashCode ^ time.hashCode;
}
