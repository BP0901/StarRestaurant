import 'dart:async';

import 'package:star_restaurant/Controller/LoginController.dart';

class AuthBloc {
  final _loginController = LoginController();

  final StreamController _usernameController = StreamController();
  final StreamController _passController = StreamController();

  Stream get usernameStream => _usernameController.stream;
  Stream get passStream => _passController.stream;

  bool isLoginValid(String username, String pass) {
    if (username == "" || username.isEmpty) {
      _usernameController.sink.addError("Nhập username");
      return false;
    }

    _usernameController.sink.add("");

    if (pass == "" || pass.length < 6) {
      _passController.sink.addError("Mật khẩu phải trên 5 ký tự");
      return false;
    }
    _passController.sink.add("");

    return true;
  }

  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    _loginController.signIn(email, pass, onSuccess, onSignInError);
  }

  void dispose() {
    _usernameController.close();
    _passController.close();
  }

  
}
