import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/LoaiMonAn.dart';

class LoaiMonAnDAO {
  final _ref = FirebaseFirestore.instance.collection("LoaiMonAn");
  Future<List<LoaiMonAn>> getLisstCates() async {
    List<LoaiMonAn> list = [];
    await _ref.get().then((value) => value.docs.forEach((element) {
          list.add(LoaiMonAn.fromDocument(element));
        }));
    return list;
  }

  void addLoaiMonAn(LoaiMonAn loaiMonAn) {
    _ref.add({'name': loaiMonAn.name, 'image': loaiMonAn.image}).then((value) {
      _ref.doc(value.id).set({'id': value.id}, SetOptions(merge: true));
      Fluttertoast.showToast(msg: "Thêm thành công");
    }).catchError((onError) => Fluttertoast.showToast(msg: onError.toString()));
  }

  Future<LoaiMonAn> getLoaiMonAnByID(String type) async {
    LoaiMonAn loaiMonAn = LoaiMonAn.origin();
    await _ref
        .where('name', isEqualTo: type)
        .get()
        .then((value) => value.docs.forEach((element) {
              loaiMonAn = LoaiMonAn.fromDocument(element);
            }));
    return loaiMonAn;
  }

  delCate(LoaiMonAn loaiMonAn) => _ref
      .doc(loaiMonAn.id)
      .delete()
      .then((value) => Fluttertoast.showToast(msg: "Xóa thành công"))
      .catchError((onError) => Fluttertoast.showToast(msg: onError.toString()));

  update(LoaiMonAn loaiMonAn) => _ref
      .doc(loaiMonAn.id)
      .update({'name': loaiMonAn.name, 'image': loaiMonAn.image})
      .then((value) => Fluttertoast.showToast(msg: "Cập nhật thành công"))
      .catchError((onError) => Fluttertoast.showToast(msg: onError.toString()));

  Future<LoaiMonAn> getLoaiMAbyID(String type) async {
    LoaiMonAn loaiMonAn = LoaiMonAn.origin();
    await _ref
        .doc(type)
        .get()
        .then((value) => loaiMonAn = LoaiMonAn.fromDocument(value));
    return loaiMonAn;
  }
}
