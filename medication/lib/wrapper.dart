import 'package:flutter/material.dart';
import 'Screens/signIn_screen.dart';
import 'Screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Blocs/usage_bloc.dart';
import '../Blocs/usage_history_bloc.dart';
import '../Blocs/profile_bloc.dart';
import '../Blocs/medication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Services/notification_service.dart';
import '../Blocs/notification_bloc.dart';
import '../Database_classes/NotificationData.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final isSigned = Provider.of<User?>(context);
    if(isSigned == null) {
    return const SignInView();
    } else {
      String userId = isSigned.uid.toString();
      downloadData(context);
      setUpNotifications(context);
      return ProfileView(userId: userId);
    }
  }

  void downloadData (BuildContext context){
    User? user = FirebaseAuth.instance.currentUser;
    if(user == null) {
    } else {
      String userId = user.uid.toString();
      BlocProvider.of<ProfileBloc>(context).add(LoadProfiles(userId));
      BlocProvider.of<MedicationBloc>(context).add(LoadMedications(true));
      BlocProvider.of<MedicationBloc>(context).add(LoadMedications(false));
      BlocProvider.of<UsageBloc>(context).add(LoadUsagesById(userId));
      BlocProvider.of<UsageHistoryBloc>(context).add(LoadUsageHistoryById(userId));
    }
  }
  Future<void> setUpNotifications(BuildContext context) async {
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
      for(var not in notifications) {
        if(not.weekday == null){
          await NotificationService().scheduleDailyNotification(
            title: 'Czas na lek!',
            body: not.body,
            id: not.awNotId,
            hour: not.hour,
            minute: not.minute,
          );
        } else {
          await NotificationService().scheduleNotificationWeekday(
              title: 'Czas na lek!',
              body: not.body,
              id: not.awNotId,
              hour: not.hour,
              minute: not.minute,
              weekday: not.weekday!
          );
        }
      }
      NotificationService().showScheduledNotifications();
    }
  }
}
