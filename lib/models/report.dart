import 'dart:convert';

class Report {
  final String from;
  final String content;
  final String time;
  Report({
    required this.from,
    required this.content,
    required this.time,
  });

  Report copyWith({
    String? from,
    String? content,
    String? time,
  }) {
    return Report(
      from: from ?? this.from,
      content: content ?? this.content,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'content': content,
      'type': time,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      from: map['from'] ?? '',
      content: map['content'] ?? '',
      time: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) => Report.fromMap(json.decode(source));

  @override
  String toString() => 'Report(from: $from, content: $content, type: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Report &&
        other.from == from &&
        other.content == content &&
        other.time == time;
  }

  @override
  int get hashCode => from.hashCode ^ content.hashCode ^ time.hashCode;
}
