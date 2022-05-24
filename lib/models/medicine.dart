import 'dart:convert';

class Medicine {
  final String name;
  final String pillDosage;
  final String shape;
  final int color;
  final int dose;
  final DateTime programDays;
  final DateTime startAt;
  final DateTime endAt;
  final int quantity;
  Medicine({
    required this.name,
    required this.pillDosage,
    required this.shape,
    required this.color,
    required this.dose,
    required this.programDays,
    required this.startAt,
    required this.endAt,
    required this.quantity,
  });

  Medicine copyWith({
    String? name,
    String? pillDosage,
    String? shape,
    int? color,
    int? dose,
    DateTime? programDays,
    DateTime? startAt,
    DateTime? endAt,
    int? quantity,
  }) {
    return Medicine(
      name: name ?? this.name,
      pillDosage: pillDosage ?? this.pillDosage,
      shape: shape ?? this.shape,
      color: color ?? this.color,
      dose: dose ?? this.dose,
      programDays: programDays ?? this.programDays,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'pillDosage': pillDosage,
      'shape': shape,
      'color': color,
      'dose': dose,
      'programDays': programDays.millisecondsSinceEpoch,
      'startAt': startAt.millisecondsSinceEpoch,
      'endAt': endAt.millisecondsSinceEpoch,
      'quantity': quantity,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      name: map['name'] ?? '',
      pillDosage: map['pillDosage'] ?? '',
      shape: map['shape'] ?? '',
      color: map['color']?.toInt() ?? 0,
      dose: map['dose']?.toInt() ?? 0,
      programDays: DateTime.fromMillisecondsSinceEpoch(map['programDays']),
      startAt: DateTime.fromMillisecondsSinceEpoch(map['startAt']),
      endAt: DateTime.fromMillisecondsSinceEpoch(map['endAt']),
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Medicine.fromJson(String source) =>
      Medicine.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Medicine(name: $name, pillDosage: $pillDosage, shape: $shape, color: $color, dose: $dose, programDays: $programDays, startAt: $startAt, endAt: $endAt, quantity: $quantity)';
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
        other.programDays == programDays &&
        other.startAt == startAt &&
        other.endAt == endAt &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        pillDosage.hashCode ^
        shape.hashCode ^
        color.hashCode ^
        dose.hashCode ^
        programDays.hashCode ^
        startAt.hashCode ^
        endAt.hashCode ^
        quantity.hashCode;
  }
}
