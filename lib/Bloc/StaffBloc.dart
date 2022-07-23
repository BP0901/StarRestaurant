import 'dart:async';

class StaffBloc {
  final StreamController _nameController = StreamController();
  final StreamController _usernameController = StreamController();
  final StreamController _passController = StreamController();

  Stream get nameStream => _nameController.stream;
  Stream get usernameStream => _usernameController.stream;
  Stream get passStream => _passController.stream;

  bool isValid(String name, String username, String pass) {
    if (name == "" || name.isEmpty) {
      _nameController.sink.addError("Nhập tên nhân viên");
      return false;
    }
    _nameController.sink.add("");

    if (username == "" || username.isEmpty) {
      _usernameController.sink.addError("Nhập tên đăng nhập");
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

  bool isNameValid(String name) {
    if (name == "" || name.isEmpty) {
      _nameController.sink.addError("Nhập tên nhân viên");
      return false;
    }
    _nameController.sink.add("");

    return true;
  }
}
