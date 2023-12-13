import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medication/wrapper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Blocs/usage_bloc.dart';
import '../Blocs/usage_history_bloc.dart';
import '../Blocs/profile_bloc.dart';
import '../Blocs/medication_bloc.dart';
import '../Blocs/notification_bloc.dart';
import '../Database_classes/NotificationData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medication/Services/notification_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  bool noInternet = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    checkInternetConnection();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Wrapper()));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'mediCATion',
              style: GoogleFonts.tiltNeon(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 174, 199, 255),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              'assets/medication.png',
              scale: 2,
            ),
            Visibility(
                visible: noInternet,
                child: Text(
                  'Brak połączenia z internetem.\nDane nie zostaną odświeżone.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  void downloadData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {} else {
      String userId = user.uid.toString();
      BlocProvider.of<ProfileBloc>(context).add(LoadProfiles(userId));
      BlocProvider.of<MedicationBloc>(context).add(LoadMedications(true));
      BlocProvider.of<MedicationBloc>(context).add(LoadMedications(false));
      BlocProvider.of<UsageBloc>(context).add(LoadUsagesById(userId));
      BlocProvider.of<UsageHistoryBloc>(context).add(
          LoadUsageHistoryById(userId));
    }
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        noInternet = true;
      });
    } else {
      setState(() {
        noInternet = false;
      });
      clearFirestoreCache();
      downloadData();
      setUpNotifications();
    }
  }

  Future<void> clearFirestoreCache() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.clearPersistence();
  }

  Future<void> setUpNotifications() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {} else {
      String userId = user.uid.toString();
      BlocProvider.of<NotificationBloc>(context).add(LoadNotifications(userId));
      List<NotificationData> notifications = [];
      await for (final state in BlocProvider
          .of<NotificationBloc>(context)
          .stream) {
        if (state is NotificationLoaded) {
          notifications = state.notifications;
          break;
        }
      }
      NotificationService().showScheduledNotifications();
      NotificationService().clearAllNotifications();
      DateTime now = DateTime.now();
      for(var not in notifications) {
        if(not.weekday == null){
          DateTime time = DateTime(now.year, now.month, now.day, not.hour, not.minute);
          await NotificationService().scheduleDailyNotification(
            title: 'Czas na lek!',
            body: not.body,
            id: not.awNotId,
            scheduledNotificationDateTime: time,
          );
        } else {
          DateTime time = NotificationService().findNextDayOfWeek(not.weekday!);
          await NotificationService().scheduleWeeklyNotification(
            title: 'Czas na lek!',
            body: not.body,
            id: not.awNotId,
            scheduledNotificationDateTime: time,
          );
        }
      }
      NotificationService().showScheduledNotifications();
    }
  }
}

