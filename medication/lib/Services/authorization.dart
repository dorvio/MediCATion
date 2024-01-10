import 'package:firebase_auth/firebase_auth.dart';
import 'package:medication/Services/notification_service.dart';

///class to autorize user in app
class AuthorizationService {
  final FirebaseAuth _authorization = FirebaseAuth.instance;

  Stream<User?> get user {
    return _authorization.authStateChanges();
  }

  ///function to sign in existing user using email and password
  Future signInEmail(String email, String password) async {
    try{
      UserCredential result =  await _authorization.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch(e){
      return null;
    }
  }

  ///function to register new user using email and password
  Future registerEmail(String email, String password) async {
    try{
      UserCredential result =  await _authorization.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    }catch(e){
      return null;
    }
  }

  ///function to sign out current user
  Future signOut() async {
    try{
      await _authorization.signOut();
      NotificationService().clearAllNotifications();
    } catch(e){
      return null;
    }
  }

}