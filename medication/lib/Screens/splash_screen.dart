import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medication/wrapper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      body: const Column(
        children: [
          Icon(
            Icons.image,
            color: Color.fromARGB(255, 174, 199, 255),
          ),
          Text(
            //'',//isConnected ? '' : "Brak połączenia. Dane nie zostaną załadowane",
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


}
Future<void> checkInternetConnection() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    print("No internet bro");
  } else {
    print("Yo got the net");
    // await firestore.terminate();
    await firestore.clearPersistence();
    await firestore.enablePersistence();
  }
}
