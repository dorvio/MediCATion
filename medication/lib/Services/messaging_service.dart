import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medication/main.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  navigatorKey.currentState?.pushNamed('/notification');
}
Future<void> onMessageOpenedApp(RemoteMessage message) async {
  navigatorKey.currentState?.pushNamed('/notification');
}


class FirebaseMess {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token:    $fCMToken');
    //TODO adding tokens to database
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
  }

}