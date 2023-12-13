import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medication/Screens/new_medication_screen.dart';
import 'package:medication/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService{
  
  static Future<void> initNotification() async {
    await AwesomeNotifications().initialize(
        '@drawable/pill',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'my_chanel',
          channelName: 'My channel',
          channelDescription: 'Notification channel for medication',
          importance: NotificationImportance.High,
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'my_channel_group',
              channelGroupName: 'My group')
        ],
        debug: true
    );

    await AwesomeNotifications().isNotificationAllowed().then(
        (isAllowed) async {
          if(!isAllowed){
            await AwesomeNotifications().requestPermissionToSendNotifications();
          }
        }
    );
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }
  //method to detect when user taps on notification or action button
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    print('atcReceived');
    //TODO change
  }
  //method to detect when new notification or schelude is created
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    print('notCreated: ${receivedNotification.body}');
    //TODO change
  }
  //method to detect where new notification is diplayed
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    print('noDisplayed: ${receivedNotification.body}');
    //TODO change
  }
  //method to detect if user dissmised notification
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    print('actDismiss');
    //TODO change
    final payload = receivedAction.payload ?? {};
    if(payload["navigate"] == "true"){
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => NewMedicationView(animal: false)),
      );
    }
  }

  Future<void> scheduleDailyNotification({
    required final String title,
    required final String body,
    required final int id,
    final String? summary,
    required final int hour,
    required final int minute
}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'my_chanel',
        title: title,
        body: body,
        actionType: ActionType.Default,
        notificationLayout: NotificationLayout.Default,
        summary: summary,
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
  }

  Future<void> scheduleNotificationWeekday({
    required final String title,
    required final String body,
    required final int id,
    final String? summary,
    required final int hour,
    required final int minute,
    required final int weekday
}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'my_channel',
        title: title,
        body: body,
        actionType: ActionType.Default,
        notificationLayout: NotificationLayout.Default,
        summary: summary,
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        weekday: weekday,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
  }

  Future<void> clearNotifications(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  Future<void> clearAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  Future<void> showScheduledNotifications() async {
    List<dynamic> scheduled = await AwesomeNotifications()
        .listScheduledNotifications();
    if (scheduled.isEmpty) {
      print('No scheduled notifications');
    } else {
      print('There are scheduled notifications');
      for (NotificationModel el in scheduled) {
        print(el.content!.id);
        print(el.schedule!);
      }
    }
  }

  Future<List<int>> getScheduledNotificationIds() async {
    List<int> ids = [];
    List<dynamic> scheduled = await AwesomeNotifications()
        .listScheduledNotifications();
    if (scheduled.isNotEmpty) {
      for (NotificationModel el in scheduled) {
        ids.add(el.content!.id!);
      }
    }
    return ids;
  }

}