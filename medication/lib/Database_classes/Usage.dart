import 'package:flutter/foundation.dart';

@immutable
class Usage {
  String usageId;
  String medicationId;
  String profileId;

  Usage({
    required this.usageId,
    required this.medicationId,
    required this.profileId,
  });

  Usage copyWith({
    String? usageId,
    String? medicationId,
    String? profileId,
  }) {
    return Usage(
      usageId : usageId ?? this.usageId,
      medicationId : medicationId ?? this.medicationId,
      profileId : profileId ?? this.profileId,
    );
  }
}