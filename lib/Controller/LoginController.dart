import 'package:star_restaurant/DAO/FirebaseAuth.dart';

class LoginController {
  final FirAuth _firAuth = FirAuth();
  void signIn(String email, String pass, Function onSuccess,
      Function(String msg) onSignInError) {
    email = email + "@gmail.com";
    _firAuth.signIn(email, pass, onSuccess, onSignInError);
  }
}
