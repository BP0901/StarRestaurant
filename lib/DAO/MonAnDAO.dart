import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star_restaurant/Model/MonAn.dart';

class MonAnDAO {
  final CollectionReference conllectionMADXN =
      FirebaseFirestore.instance.collection('MonAnDaXacNhan');
  final CollectionReference conllectionMonAn =
      FirebaseFirestore.instance.collection('MonAn');
  final String? id;
  MonAnDAO({this.id});

  Future confirm(QueryDocumentSnapshot<Object?> doc, Function onSuccess,
      Function(String) onError) async {
    return await conllectionMADXN
        .doc(doc.id)
        .update({
          'status': 'cooking',
        })
        .then((value) => onSuccess())
        .catchError((onError) {
          onError("Xác nhận thất bại");
        });
  }

  Future cancel(QueryDocumentSnapshot<Object?> doc, Function onSuccess,
      Function(String) onError) async {
    return await conllectionMADXN
        .doc(doc.id)
        .update({
          'status': 'cancel',
        })
        .then((value) => onSuccess())
        .catchError((onError) {
          onError("Hủy thất bại");
        });
  }

  Future success(QueryDocumentSnapshot<Object?> doc, Function onSuccess,
      Function(String) onError) async {
    return await conllectionMADXN
        .doc(doc.id)
        .update({
          'status': 'done',
        })
        .then((value) => onSuccess())
        .catchError((onError) {
          onError("Xác nhận thất bại");
        });
  }

  Future add(MonAn monAn) {
    return conllectionMonAn.add({
      'name': monAn.name,
      'image': monAn.image,
      'price': monAn.price,
      'discount': monAn.discount,
      'type': monAn.type,
      'unit': monAn.unit
    }).then((value) {
      conllectionMonAn
          .doc(value.id)
          .set({"id": value.id}, SetOptions(merge: true));
      Fluttertoast.showToast(msg: "Thêm thành công!");
    }).catchError((onError) {
      print("err: " + onError.toString());
      Fluttertoast.showToast(msg: "Thêm thất bại!");
    }).whenComplete(() => {print("completed")});
  }

  Future update(MonAn monAn) {
    return conllectionMonAn
        .doc(monAn.id)
        .set({
          'name': monAn.name,
          'image': monAn.image,
          'price': monAn.price,
          'discount': monAn.discount,
          'type': monAn.type,
          'unit': monAn.unit
        })
        .then((value) => Fluttertoast.showToast(msg: "Cập Nhật thành công"))
        .catchError(
            (onError) => Fluttertoast.showToast(msg: onError.toString()))
        .whenComplete(() => {print("completed")});
  }

  Future delete(String id, Function onSuccess, Function(String) onfailure) {
    return conllectionMonAn.doc(id).delete().then((value) {
      onSuccess();
    }).catchError((onError) {
      print("err: " + onError.toString());
      onError("Thêm mới không thành công");
    }).whenComplete(() => {print("completed")});
  }
}
