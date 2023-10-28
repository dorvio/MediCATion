import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Blocks/profile_bloc.dart';
import 'package:medication/Blocks/type_bloc.dart';
import 'package:medication/Blocks/medication_bloc.dart';
import 'package:medication/Blocks/usage_bloc.dart';
import 'firebase_options.dart';
import 'Services/firestore_service.dart';
import 'Screens/profile_screen.dart';
import 'Screens/signIn_screen.dart';

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
          //BlocProvider(
          //  create: (context) =>   AuthenticationBloc(AuthenticationRepositoryImpl())
          //   ..add(AuthenticationStarted()),
          // ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(FirestoreService()),
          ),
          BlocProvider<TypeBloc>(
            create: (context) => TypeBloc(FirestoreService()),
          ),
          BlocProvider<MedicationBloc>(
            create: (context) => MedicationBloc(FirestoreService()),
          ),
          BlocProvider<UsageBloc>(
            create: (context) => UsageBloc(FirestoreService()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blueAccent
              )
          ),
          home: const SignInView(),
        )
    );
  }
}