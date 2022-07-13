import 'package:cloud_firestore/cloud_firestore.dart';

class MonAnDAO {
  final CollectionReference conllectionMADXN =
      FirebaseFirestore.instance.collection('MonAnDaXacNhan');
  final CollectionReference conllectionMonAn =
      FirebaseFirestore.instance.collection('MonAn');
  final String? id;
  MonAnDAO({this.id});
  Future confirm(
      String id, Function onSuccess, Function(String) onError) async {
    return await conllectionMADXN
        .doc(id)
        .update({
          'status': 'cooking',
        })
        .then((value) => onSuccess())
        .catchError((onError) {
          onError("Xác nhận thất bại");
        });
  }

  Future cancel(String id, Function onSuccess, Function(String) onError) async {
    return await conllectionMADXN
        .doc(id)
        .update({
          'status': 'cancel',
        })
        .then((value) => onSuccess())
        .catchError((onError) {
          onError("Hủy thất bại");
        });
  }

  Future success(
      String id, Function onSuccess, Function(String) onError) async {
    return await conllectionMADXN
        .doc(id)
        .update({
          'status': 'cuccess',
        })
        .then((value) => onSuccess())
        .catchError((onError) {
          onError("Xác nhận thất bại");
        });
  }

  Future add(String name, String image, int price, int discount, String type,
      String unit, Function onSuccess, Function(String) onfailure) {

    return conllectionMonAn.add({
      'name': name,
      'image': image,
      'price': price,
      'discount': discount,
    }).then((value) {
      conllectionMonAn.doc(value.id).update({'id': value.id,
      'type':FirebaseFirestore.instance
          .collection('LoaiMonAn')
          .where("name", isEqualTo: 'Nước uống')
          .get()
          .then((loais) => {
      loais.docs.forEach((loai) {

      })
      })
      });

      onSuccess();
    }).catchError((onError) {
      print("err: " + onError.toString());
      onError("Thêm mới không thành công");
    }).whenComplete(() => {print("completed")});
  }

  Future update(
      String id,
      String name,
      String image,
      int price,
      int discount,
      String type,
      String unit,
      Function onSuccess,
      Function(String) onfailure) {
    return conllectionMonAn
        .doc(id)
        .set({
          'name': name,
          'image': image,
          'price': price,
          'discount': discount,
          'type': type
        })
        .then((value) {})
        .catchError((onError) {
          print("err: " + onError.toString());
          onError("Thêm mới không thành công");
        })
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
