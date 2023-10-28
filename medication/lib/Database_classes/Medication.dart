import 'package:flutter/foundation.dart';

@immutable
class Medication {
  String medicationId;
  String medication;
  int type;
  String description;

  Medication({
    required this.medicationId,
    required this.medication,
    required this.type,
    required this.description,
  });

  Medication copyWith({
    String? medicationId,
    String? medication,
    int? type,
    String? description,
  }) {
    return Medication(
      medicationId : medicationId ?? this.medicationId,
      medication : medication ?? this.medication,
      type : type ?? this.type,
      description : description ?? this.description,
    );
  }
}