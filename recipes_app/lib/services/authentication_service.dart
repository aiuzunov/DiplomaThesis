import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  loginWithEmail({required String email, required String password}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  signUpWithEmail({required String email, required String password}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}
