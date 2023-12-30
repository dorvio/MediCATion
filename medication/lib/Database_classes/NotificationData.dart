import 'package:flutter/foundation.dart';

@immutable
class NotificationData {
  String notificationId;
  int locNotId;
  String userId;
  String body;
  int hour;
  int minute;
  int? weekday;


  NotificationData({
    required this.notificationId,
    required this.locNotId,
    required this.userId,
    required this.body,
    required this.hour,
    required this.minute,
    required this.weekday,
  });

  NotificationData copyWith({
    String? notificationId,
    int? awNotId,
    String? userId,
    String? body,
    int? hour,
    int? minute,
    int? weekday,
  }) {
    return NotificationData(
      notificationId : notificationId ?? this.notificationId,
      locNotId : awNotId ?? this.locNotId,
      userId : userId ?? this.userId,
      body : body ?? this.body,
      hour : hour ?? this.hour,
      minute : minute ?? this.minute,
      weekday : weekday,
    );
  }
}
