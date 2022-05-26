import 'dart:convert';

import 'package:flutter/foundation.dart';

class Medicine {
  final String name;
  final String pillDosage;
  final int shape;
  final int color;
  final int dose;
  final DateTime startAt;
  final DateTime endAt;
  Map<String, Map<String, bool>>? isDone;
  Medicine({
    required this.name,
    required this.pillDosage,
    required this.shape,
    required this.color,
    required this.dose,
    required this.startAt,
    required this.endAt,
    this.isDone,
  });
  int get quantity => startAt.difference(endAt).inDays * dose;
  int get residualQantity =>
      quantity -
      (startAt
              .difference(
                  DateTime.now().isBefore(endAt) ? DateTime.now() : endAt)
              .inDays *
          dose);

  Medicine copyWith({
    String? name,
    String? pillDosage,
    int? shape,
    int? color,
    int? dose,
    DateTime? startAt,
    DateTime? endAt,
    Map<String, Map<String, bool>>? isDone,
  }) {
    return Medicine(
      name: name ?? this.name,
      pillDosage: pillDosage ?? this.pillDosage,
      shape: shape ?? this.shape,
      color: color ?? this.color,
      dose: dose ?? this.dose,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'pillDosage': pillDosage,
      'shape': shape,
      'color': color,
      'dose': dose,
      'startAt': startAt.millisecondsSinceEpoch,
      'endAt': endAt.millisecondsSinceEpoch,
      "isDone": Map.from(isDone!).map((k, v) => MapEntry<String, dynamic>(
          k, Map.from(v).map((k, v) => MapEntry<String, dynamic>(k, v)))),
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      name: map['name'] ?? '',
      pillDosage: map['pillDosage'] ?? '',
      shape: map['shape'] ?? '',
      color: map['color']?.toInt() ?? 0,
      dose: map['dose']?.toInt() ?? 0,
      startAt: DateTime.fromMillisecondsSinceEpoch(map['startAt']),
      endAt: DateTime.fromMillisecondsSinceEpoch(map['endAt']),
      isDone: Map.from(map["isDone"]).map((k, v) =>
          MapEntry<String, Map<String, bool>>(
              k, Map.from(v).map((k, v) => MapEntry<String, bool>(k, v)))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Medicine.fromJson(String source) =>
      Medicine.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Medicine(name: $name, pillDosage: $pillDosage, shape: $shape, color: $color, dose: $dose, startAt: $startAt, endAt: $endAt, isDone: $isDone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Medicine &&
        other.name == name &&
        other.pillDosage == pillDosage &&
        other.shape == shape &&
        other.color == color &&
        other.dose == dose &&
        other.startAt == startAt &&
        other.endAt == endAt &&
        mapEquals(other.isDone, isDone);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        pillDosage.hashCode ^
        shape.hashCode ^
        color.hashCode ^
        dose.hashCode ^
        startAt.hashCode ^
        endAt.hashCode ^
        isDone.hashCode;
  }
}
