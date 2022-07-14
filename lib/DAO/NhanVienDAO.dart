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
  Stream<QuerySnapshot> get nhanviens{
    return staffConllection.snapshots();
  }

  void createStaff(
      String name,
      int gender,
      DateTime birth,
      String password,
      String role,
      bool disable,
      String username,
      Function onSuccess,
      Function(String) onError) {
    staffConllection.add({
      'name': name,
      'gender': gender,
      'username': username,
      'birth': birth,
      'role': role,
      'password': password,
      'disable': disable
    }).then((documentSnapshot) {
      staffConllection
          .doc(documentSnapshot.id)
          .update({
        'id': documentSnapshot.id,
      });
      print("Thêm mới thành công: ${documentSnapshot.id}");
      onSuccess();
    }).catchError((err) {
      print("err: " + err.toString());
      onError("SignUp fail, please try again");
    }).whenComplete(() {
      print("completed");
    });
  }

  String getId() {
    NhanVien userRole = NhanVien.origin();
    staffConllection
        .doc(_fireBaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      userRole = NhanVien.fromDocument(value);
      return userRole.id;
    });
    return 'idNone';
  }

  void deleteStaff(String id, Function onSuccess, Function(String) onfailure) {
    staffConllection
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

  Future updateStaff(String id, String name, int gender, DateTime birth,
      String role, Function onSuccess, Function(String) onError)async {
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
}
