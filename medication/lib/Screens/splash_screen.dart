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
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  bool isConnected = false;
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    checkInternetConnection();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Wrapper()));
    });
  }
  @override
  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          Image.asset(
            'assets/medication.png',
          ),
          const Text(
            '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  void downloadData (){
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

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
    } else {
      clearFirestoreCache();
      downloadData();
    }
  }
}

Future<void> clearFirestoreCache() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  await firestore.clearPersistence();
}

