import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  void createStaff(NhanVien nhanVien) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: nhanVien.username, password: nhanVien.password)
        .then((user) {
      _createUser(FirebaseAuth.instance.currentUser!.uid, nhanVien);
    }).catchError((err) {
      print("err: " + err.toString());
      _onSignUpErr(err.code);
    });
  }

  _createUser(String userId, NhanVien nhanVien) {
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
      Fluttertoast.showToast(msg: "Thành công");
    }).catchError((err) {
      print("err: " + err.toString());
      Fluttertoast.showToast(msg: "SignUp fail, please try again");
    }).whenComplete(() {
      print("completed");
    });
  }

  void _onSignUpErr(String code) {
    print(code);
    switch (code) {
      case "invalid-email":
        Fluttertoast.showToast(msg: "Tên đăng nhập không hợp lệ");
        break;
      case "email-already-in-use":
        Fluttertoast.showToast(msg: "Tên đăng nhập đã tồn tại");
        break;
      case "weak-password":
        Fluttertoast.showToast(msg: "The password is not strong enough");
        break;
      default:
        Fluttertoast.showToast(msg: "SignUp fail, please try again");
        break;
    }
  }

  void disableStaff(
      String id, Function onSuccess, Function(String) onfailure) async {
    NhanVien nhanVien = NhanVien.origin();
    await staffConllection
        .doc(id)
        .get()
        .then((value) => nhanVien = NhanVien.fromDocument(value));
    staffConllection
        .doc(id)
        .update({'disable': !nhanVien.disable})
        .then((value) => onSuccess())
        .catchError((onError) {
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
