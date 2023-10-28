import 'package:firebase_auth/firebase_auth.dart';

class AuthorizationService {
  final FirebaseAuth _authorization = FirebaseAuth.instance;

  Future signInEmail(String email, String password) async {
    try{
      UserCredential result =  await _authorization.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch(e){
      return null;
    }
  }

  Future registerEmail(String email, String password) async {
    try{
      UserCredential result =  await _authorization.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    }catch(e){
      return null;
    }
  }

  Future signOut() async {
    try{
      await _authorization.signOut();
    } catch(e){
      return null;
    }
  }

}