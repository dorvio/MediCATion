import 'package:flutter/material.dart';
import 'Screens/signIn_screen.dart';
import 'Screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Blocs/usage_bloc.dart';
import '../Blocs/profile_bloc.dart';
import '../Blocs/medication_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    }
  }
}
