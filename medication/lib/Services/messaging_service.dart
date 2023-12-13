import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medication/main.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  navigatorKey.currentState?.pushNamed('/notification');
}

void handleMessage(RemoteMessage? message) {
  navigatorKey.currentState?.pushNamed('/notification');
}

class MessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
    'androidChanelId',
    'androidChanel',
    description: 'Channel for notifications',
    importance: Importance.defaultImportance,
  );

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/pill');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(settings);

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }


  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token:    $fCMToken');
    //TODO adding tokens to database

    initLocalNotifications();

    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessage.listen((message){
      final notification = message.notification;
      if(notification == null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/pill'
          )
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

}