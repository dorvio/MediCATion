import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Blocs/profile_bloc.dart';
import 'package:medication/Blocs/medication_bloc.dart';
import 'package:medication/Blocs/usage_bloc.dart';
import 'package:medication/Screens/splash_screen.dart';
import 'firebase_options.dart';
import 'Services/firestore_service.dart';
import 'package:medication/Screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'Services/authorization.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
        )
    );
  }
}