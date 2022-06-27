import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:star_restaurant/Model/NhanVien.dart';

class NhanVienDAO {
  final CollectionReference staffList =
      FirebaseFirestore.instance.collection('NhanVien');
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  void createStaff(
      String name,
      int gender,
      DateTime birth,
      String password,
      String role,
      bool disable,
      String username,
      Function onSuccess,
      Function(String) onRegisterError) {
    staffList.add({
      'name': name,
      'gender': gender,
      'username': username,
      'birth': birth,
      'role': role,
      'password':password,
      'disable': disable
    }).then((documentSnapshot) {
      FirebaseFirestore.instance.collection('NhanVien').doc(documentSnapshot.id).update({
      'id': documentSnapshot.id,});
      print("Thêm mới thành công: ${documentSnapshot.id}");
      onSuccess();
    }).catchError((err) {
      print("err: " + err.toString());
      onRegisterError("SignUp fail, please try again");
    }).whenComplete(() {
      print("completed");
    });
  }
  String getId() {
    NhanVien userRole = NhanVien.origin();
    FirebaseFirestore.instance
        .collection('NhanVien')
        .doc(_fireBaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      userRole = NhanVien.fromDocument(value);
      return userRole.id;
    });
    return 'idNone';
  }
  void deleteStaff(String id,
      Function onSuccess, Function(String) onfailure) {
    FirebaseFirestore.instance
        .collection('NhanVien')
        .doc(id)
        .delete()
        .then((value) {
      print("Xóa thành công!");
      onSuccess();
    }).catchError((onError) {
      print("err: " + onError.toString());
      onfailure("Có lỗi xẩy ra. Xin kiểm tra lại!");
    });
  }
}
