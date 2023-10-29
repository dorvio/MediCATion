import 'package:flutter/foundation.dart';

@immutable
class Usage {
  String usageId;
  String medicationId;
  String profileId;
  String medicationName;

  Usage({
    required this.usageId,
    required this.medicationId,
    required this.medicationName,
    required this.profileId,
  });

  Usage copyWith({
    String? usageId,
    String? medicationId,
    String? medicationName,
    String? profileId,
  }) {
    return Usage(
      usageId : usageId ?? this.usageId,
      medicationId : medicationId ?? this.medicationId,
      medicationName : medicationName ?? this.medicationName,
      profileId : profileId ?? this.profileId,
    );
  }
}