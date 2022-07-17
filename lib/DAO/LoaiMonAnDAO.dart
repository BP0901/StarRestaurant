import 'package:cloud_firestore/cloud_firestore.dart';

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
}
