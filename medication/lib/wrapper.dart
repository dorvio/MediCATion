import 'package:flutter/material.dart';
import 'Screens/signIn_screen.dart';
import 'Screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final isSigned = Provider.of<User?>(context);
    if(isSigned == null) {
    return const SignInView();
    } else {
      return ProfileView(userId: isSigned.uid.toString());
    }


  }
}
