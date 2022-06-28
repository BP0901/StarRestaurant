import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:star_restaurant/Model/NhanVien.dart';

class BanAnDAO {
  final CollectionReference staffList =
      FirebaseFirestore.instance.collection('BanAn');
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  void createTable(String name, bool type,Function onSuccess,
      Function(String) onRegisterError) {
    staffList.add({
      'name': name,
      'type': type,
      'idUser':'',
      'isUsing':false,
    }).then((documentSnapshot) {
      FirebaseFirestore.instance
          .collection('BanAn')
          .doc(documentSnapshot.id)
          .update({
        'id': documentSnapshot.id,
      });
      print("Thêm mới thành công: ${documentSnapshot.id}");
      onSuccess();
    }).catchError((err) {
      print("err: " + err.toString());
      onRegisterError("SignUp fail, please try again");
    }).whenComplete(() {
      print("completed");
    });
  }

  void deleteTable(String id, Function onSuccess, Function(String) onfailure) {
    FirebaseFirestore.instance
        .collection('BanAn')
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
