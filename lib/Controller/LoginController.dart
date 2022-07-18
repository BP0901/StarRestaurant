import 'package:firebase_auth/firebase_auth.dart';
import 'package:star_restaurant/DAO/FirebaseAuth.dart';
import 'package:star_restaurant/DAO/NhanVienDAO.dart';
import 'package:star_restaurant/Model/NhanVien.dart';

class LoginController {
  final FirAuth _firAuth = FirAuth();
  final NhanVienDAO _nhanVienDAO = NhanVienDAO();
  Future<void> signIn(String email, String pass, Function(String) onSuccess,
      Function(String msg) onSignInError) async {
    email = email + "@gmail.com";
    bool checkLogin = await _firAuth.signIn(email, pass, onSignInError);
    if (checkLogin) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      NhanVien nhanVien =
          await _nhanVienDAO.getNhanVienById(userId, onSignInError);
      onSuccess(nhanVien.role);
    }
  }
}
