import 'dart:convert';

class HealthData {
  final HeartData heartData;
  final TempData tempData;
  HealthData({
    required this.heartData,
    required this.tempData,
  });

  HealthData copyWith({
    HeartData? heartData,
    TempData? tepmData,
  }) {
    return HealthData(
      heartData: heartData ?? this.heartData,
      tempData: tepmData ?? tempData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'heartData': heartData.toMap(),
      'tempData': tempData.toMap(),
    };
  }

  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      heartData: HeartData.fromMap(map['heartData']),
      tempData: TempData.fromMap(map['tempData']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthData.fromJson(String source) =>
      HealthData.fromMap(json.decode(source));

  @override
  String toString() => 'HealthData(heartData: $heartData, tempData: $tempData)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HealthData &&
        other.heartData == heartData &&
        other.tempData == tempData;
  }

  @override
  int get hashCode => heartData.hashCode ^ tempData.hashCode;
}

class HeartData {
  final String last;
  final String lowest;
  final String highest;
  HeartData({
    required this.last,
    required this.lowest,
    required this.highest,
  });

  HeartData copyWith({
    String? last,
    String? lowest,
    String? highest,
  }) {
    return HeartData(
      last: last ?? this.last,
      lowest: lowest ?? this.lowest,
      highest: highest ?? this.highest,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'last': last,
      'lowest': lowest,
      'highest': highest,
    };
  }

  factory HeartData.fromMap(Map<String, dynamic> map) {
    return HeartData(
      last: map['last'] ?? '',
      lowest: map['lowest'] ?? '',
      highest: map['highest'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HeartData.fromJson(String source) =>
      HeartData.fromMap(json.decode(source));

  @override
  String toString() =>
      'HeartData(last: $last, lowest: $lowest, highest: $highest)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HeartData &&
        other.last == last &&
        other.lowest == lowest &&
        other.highest == highest;
  }

  @override
  int get hashCode => last.hashCode ^ lowest.hashCode ^ highest.hashCode;
}

class TempData {
  final String temp;
  final String status;
  TempData({
    required this.temp,
    required this.status,
  });

  TempData copyWith({
    String? temp,
    String? status,
  }) {
    return TempData(
      temp: temp ?? this.temp,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temp': temp,
      'status': status,
    };
  }

  factory TempData.fromMap(Map<String, dynamic> map) {
    return TempData(
      temp: map['temp'] ?? '',
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TempData.fromJson(String source) =>
      TempData.fromMap(json.decode(source));

  @override
  String toString() => 'TempData(temp: $temp, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TempData && other.temp == temp && other.status == status;
  }

  @override
  int get hashCode => temp.hashCode ^ status.hashCode;
}
