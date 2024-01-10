import 'package:flutter/foundation.dart';


///class to store data about medication
@immutable
class Medication {
  String medicationId;
  String medication;
  String type;
  String description;
  bool forAnimal;

  Medication({
    required this.medicationId,
    required this.medication,
    required this.type,
    required this.description,
    required this.forAnimal,
  });

  Medication copyWith({
    String? medicationId,
    String? medication,
    String? type,
    String? description,
    bool? forAnimal,
  }) {
    return Medication(
      medicationId : medicationId ?? this.medicationId,
      medication : medication ?? this.medication,
      type : type ?? this.type,
      description : description ?? this.description,
      forAnimal : forAnimal ?? this.forAnimal,
    );
  }
}