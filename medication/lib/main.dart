import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Blocs/profile_bloc.dart';
import 'package:medication/Blocs/medication_bloc.dart';
import 'package:medication/Blocs/usage_bloc.dart';
import 'package:medication/Blocs/usage_history_bloc.dart';
import 'package:medication/Blocs/notification_bloc.dart';
import 'package:medication/Screens/splash_screen.dart';
import 'firebase_options.dart';
import 'Services/firestore_service.dart';
import 'Services/notification_service.dart';
import 'package:provider/provider.dart';
import 'Services/authorization.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //NotificationService.initNotification();
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );
  //NotificationService.initNotification();
  await _requestNotificationPermissions();
  initializeDateFormatting('pl_PL', null).then((_) => runApp(MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(FirestoreService()),
          ),
          BlocProvider<MedicationBloc>(
            create: (context) => MedicationBloc(FirestoreService()),
          ),
          BlocProvider<UsageBloc>(
            create: (context) => UsageBloc(FirestoreService()),
          ),
          BlocProvider<UsageHistoryBloc>(
            create: (context) => UsageHistoryBloc(FirestoreService()),
          ),
          BlocProvider<NotificationBloc>(
            create: (context) => NotificationBloc(FirestoreService()),
          ),
          StreamProvider.value(value: AuthorizationService().user, initialData: null),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blueAccent
              )
          ),
          home: const SplashView(),
          navigatorKey: navigatorKey,
        )
    );
  }
}
Future<void> _requestNotificationPermissions() async {
  final PermissionStatus status = await Permission.notification.request();
  if (status != PermissionStatus.granted) {
    print('Uprawnienia do powiadomień nie zostały udzielone.');
  }
}