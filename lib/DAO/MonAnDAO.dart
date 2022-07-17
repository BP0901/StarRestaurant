import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future add(MonAn monAn, Function onSuccess, Function(String) onfailure) {
    print(monAn.type);
    return conllectionMonAn.add({
      'name': monAn.name,
      'image': monAn.image,
      'price': monAn.price,
      'discount': monAn.discount,
      'type': monAn.type
    }).then((value) {
      conllectionMonAn
          .doc(value.id)
          .set({"id": value.id}, SetOptions(merge: true));
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
