import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:star_restaurant/Model/NhanVien.dart';

class NhanVienDAO {
  final CollectionReference staffConllection =
      FirebaseFirestore.instance.collection('NhanVien');
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  final String? id;
  NhanVienDAO({this.id});

  // List<NhanVien> nvListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docChanges.map((e) {);
  // }
  // Stream<List<NhanVien>> get nhanviens{
  //   return staffConllection.snapshots().map(nvListFromSnapshot);
  // }
  Stream<QuerySnapshot> get nhanviens {
    return staffConllection.snapshots();
  }

  void createStaff(
      NhanVien nhanVien, Function onSuccess, Function(String) onError) {
    String email = nhanVien.username + "@gmail.com";
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email, password: nhanVien.password)
        .then((user) {
      _createUser(
          FirebaseAuth.instance.currentUser!.uid, nhanVien, onSuccess, onError);
    }).catchError((err) {
      print("err: " + err.toString());
      _onSignUpErr(err.code, onError);
    });
  }

  _createUser(String userId, NhanVien nhanVien, Function onSuccess,
      Function(String) onRegisterError) {
    staffConllection.doc(userId).set({
      'id': userId,
      'name': nhanVien.name,
      'gender': nhanVien.gender,
      'username': nhanVien.username,
      'birth': nhanVien.birth,
      'role': nhanVien.role,
      'password': nhanVien.password,
      'disable': nhanVien.disable,
    }).then((value) {
      print("on value: SUCCESSED");
      onSuccess();
    }).catchError((err) {
      print("err: " + err.toString());
      onRegisterError("SignUp fail, please try again");
    }).whenComplete(() {
      print("completed");
    });
  }

  void _onSignUpErr(String code, Function(String) onRegisterError) {
    print(code);
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Invalid email");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        onRegisterError("Email has existed");
        break;
      case "ERROR_WEAK_PASSWORD":
        onRegisterError("The password is not strong enough");
        break;
      default:
        onRegisterError("SignUp fail, please try again");
        break;
    }
  }

  String getId() {
    NhanVien userRole = NhanVien.origin();
    staffConllection.doc(_fireBaseAuth.currentUser!.uid).get().then((value) {
      userRole = NhanVien.fromDocument(value);
      return userRole.id;
    });
    return 'idNone';
  }

  void deleteStaff(
      String id, Function onSuccess, Function(String) onfailure) async {
    NhanVien nhanVien = NhanVien.origin();
    await staffConllection
        .doc(id)
        .get()
        .then((value) => nhanVien = NhanVien.fromDocument(value));
    staffConllection.doc(id).delete().then((value) async {
      AuthCredential credential = EmailAuthProvider.credential(
          email: nhanVien.username + "@gmail.com", password: nhanVien.password);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      print("Xóa thành công!");
      onSuccess();
    }).catchError((onError) {
      print("err: " + onError.toString());
      onfailure("Có lỗi xẩy ra. Xin kiểm tra lại!");
    });
  }

  Future updateStaff(String id, String name, int gender, DateTime birth,
      String role, Function onSuccess, Function(String) onError) async {
    return await staffConllection
        .doc(id)
        .update({
          'name': name,
          'gender': gender,
          'birth': birth,
          'role': role,
        })
        .then((value) => onSuccess())
        .catchError((onError) {
          onError("Cập nhật thất bại");
        });
  }

  Future<NhanVien> getNhanVienById(
      String userId, Function(String) onError) async {
    NhanVien nhanVien = NhanVien.origin();
    await staffConllection.doc(userId).get().then((value) {
      if (!value.exists) {
        onError("Sign In Fail!");
      } else {
        nhanVien = NhanVien.fromDocument(value);
      }
    });
    return nhanVien;
  }
}
