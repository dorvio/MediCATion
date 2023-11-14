import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medication/wrapper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Blocs/usage_bloc.dart';
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
    checkInternetConnection(context);
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
      body: const Column(
        children: [
          Icon(
            Icons.image,
            color: Color.fromARGB(255, 174, 199, 255),
          ),
          Text(
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
}

Future<void> clearFirestoreCache() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  await firestore.clearPersistence();
}
void downloadData (BuildContext context){
  final isSigned = Provider.of<User?>(context);
  if(isSigned == null) {
  } else {
    String userId = isSigned.uid.toString();
    BlocProvider.of<ProfileBloc>(context).add(LoadProfiles(userId));
    //TODO add fetching only users usages
    BlocProvider.of<UsageBloc>(context).add(LoadUsages());
    BlocProvider.of<MedicationBloc>(context).add(LoadMedications(true));
    BlocProvider.of<MedicationBloc>(context).add(LoadMedications(false));
  }


}
Future<void> checkInternetConnection(BuildContext context) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
  } else {
    clearFirestoreCache();
    downloadData(context);
  }
}