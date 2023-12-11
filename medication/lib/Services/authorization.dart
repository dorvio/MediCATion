import 'package:firebase_auth/firebase_auth.dart';
import 'package:medication/Services/notification_service.dart';

class AuthorizationService {
  final FirebaseAuth _authorization = FirebaseAuth.instance;

  Stream<User?> get user {
    return _authorization.authStateChanges();
  }

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
      NotificationService().clearAllNotifications();
    } catch(e){
      return null;
    }
  }

}