import 'dart:convert';

class Report {
  final String from;
  final String to;
  final String medicalSpecialty;
  final String sampleName;
  final String description;
  final String problem;
  final String time;

  Report({
    required this.from,
    required this.to,
    required this.medicalSpecialty,
    required this.sampleName,
    required this.description,
    required this.problem,
    required this.time,
  });

  Report copyWith({
    String? from,
    String? to,
    String? medicalSpecialty,
    String? sampleName,
    String? description,
    String? problem,
    String? time,
  }) {
    return Report(
      from: from ?? this.from,
      to: to ?? this.to,
      medicalSpecialty: medicalSpecialty ?? this.medicalSpecialty,
      sampleName: sampleName ?? this.sampleName,
      description: description ?? this.description,
      problem: problem ?? this.problem,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'medicalSpecialty': medicalSpecialty,
      'sampleName': sampleName,
      'description': description,
      'problem': problem,
      'time': time,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      medicalSpecialty: map['medicalSpecialty'] ?? '',
      sampleName: map['sampleName'] ?? '',
      description: map['description'] ?? '',
      problem: map['problem'] ?? '',
      time: map['time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) => Report.fromMap(json.decode(source));

  // @override
  // String toString() => 'Report(from: $from, content: $content, type: $time)';
  //
  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;
  //
  //   return other is Report &&
  //       other.from == from &&
  //       other.content == content &&
  //       other.time == time;
  // }
  //
  // @override
  // int get hashCode => from.hashCode ^ content.hashCode ^ time.hashCode;
}
