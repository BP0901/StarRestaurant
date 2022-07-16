import 'package:firebase_auth/firebase_auth.dart';

class FirAuth {
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;

  Future<bool> signIn(String email, String pass,
      Function(String) onSignInError) async {
    bool  checkLogin = false;
    await _fireBaseAuth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) {
      checkLogin = true;
    }).catchError((err) {
      // ignore: avoid_print
      print("err: " + err.toString());
      onSignInError("Sign-In fail, please try again");
    });
    return checkLogin;
  }

  Future<void> signOut() async {
    print("signOut");
    return _fireBaseAuth.signOut();
  }
}
