import 'package:flutter/foundation.dart';

@immutable
class Usage {
  String usageId;
  String profileId;
  String medicationName;
  List <dynamic> administration;
  List <dynamic> hour;
  String restrictions;
  List <dynamic> conflict;
  String probiotic;
  String userId;


  Usage({
    required this.usageId,
    required this.medicationName,
    required this.profileId,
    required this.administration,
    required this.hour,
    required this.restrictions,
    required this.conflict,
    required this.probiotic,
    required this.userId,
  });

  Usage copyWith({
    String? usageId,
    String? medicationName,
    String? profileId,
    List <dynamic>? administration,
    List <dynamic>? hour,
    String? restrictions,
    List <dynamic>? conflict,
    String? probiotic,
    String? userId,
  }) {
    return Usage(
      usageId : usageId ?? this.usageId,
      medicationName : medicationName ?? this.medicationName,
      profileId : profileId ?? this.profileId,
      administration : administration ?? this.administration,
      hour : hour ?? this.hour,
      restrictions : restrictions ?? this.restrictions,
      conflict : conflict ?? this.conflict,
      probiotic : probiotic ?? this.probiotic,
      userId : userId ?? this.userId,
    );
  }
}