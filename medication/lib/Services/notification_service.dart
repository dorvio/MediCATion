import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService{
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings(
        '@drawable/pill');

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid
    );
    await notificationsPlugin.initialize(
        initializationSettings, onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {});
  }

  notificationDetails(int id) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            'channelId$id', 'channelName$id', importance: Importance.max)
    );
  }

  Future scheduleDailyNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledNotificationDateTime
  }) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(id),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
            .absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future scheduleWeeklyNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledNotificationDateTime
  }) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(id),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
            .absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> clearNotifications(int id) async {
    await notificationsPlugin.cancel(id);
  }

  Future<void> clearAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  Future<void> showScheduledNotifications() async {
    List<dynamic> scheduled = await notificationsPlugin.pendingNotificationRequests();
    if (scheduled.isEmpty) {
      print('No scheduled notifications');
    } else {
      print('There are scheduled notifications');
      for (PendingNotificationRequest el in scheduled) {
        print(el.id);
        print(el.body);
      }
    }
  }

  Future<List<int>> getScheduledNotificationIds() async {
    List<int> ids = [];
    List<dynamic> scheduled = await await notificationsPlugin.pendingNotificationRequests();
    if (scheduled.isNotEmpty) {
      for (PendingNotificationRequest el in scheduled) {
        ids.add(el.id!);
      }
    }
    return ids;
  }

  DateTime findNextDayOfWeek(int targetDay) {
    DateTime today = DateTime.now();
    int daysUntilNextDayOfWeek = (targetDay - today.weekday + 7) % 7;
    DateTime nextDayOfWeek = today.add(Duration(days: daysUntilNextDayOfWeek));
    return nextDayOfWeek;
  }

}