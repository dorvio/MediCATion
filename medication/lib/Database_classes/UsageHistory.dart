import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class UsageHistory {
  String usageHistoryId;
  String usageId;
  Timestamp date;
  String profileId;
  String userId;


  UsageHistory({
    required this.usageHistoryId,
    required this.usageId,
    required this.date,
    required this.profileId,
    required this.userId,
  });

  UsageHistory copyWith({
    String? usageHistoryId,
    String? usageId,
    Timestamp? date,
    String? profileId,
    String? userId,
  }) {
    return UsageHistory(
      usageHistoryId : usageHistoryId ?? this.usageHistoryId,
      usageId : usageId ?? this.usageId,
      date : date ?? this.date,
      profileId : profileId ?? this.profileId,
      userId : userId ?? this.userId,
    );
  }
}