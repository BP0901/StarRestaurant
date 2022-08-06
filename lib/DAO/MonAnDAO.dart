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
        .delete()
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
      'isSoldOut': false,
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
        }, SetOptions(merge: true))
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

  Future<int> checkSizeFoodByCate(String idCate) async {
    int size = 0;
    await conllectionMonAn
        .where("type", isEqualTo: idCate)
        .get()
        .then((value) => size = value.size);
    return size;
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getAllFoodInTables(
      List listIdTables) async {
    List<DocumentSnapshot<Map<String, dynamic>>> list = [];
    await Future.forEach(
        listIdTables,
        (dynamic idTable) => conllectionMADXN
            .where('idTable', isEqualTo: idTable)
            .get()
            .then((foods) =>
                foods.docs.forEach((dynamic food) => list.add(food))));
    return list;
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getAllFoodbyIdTable(
      String idTable) async {
    List<DocumentSnapshot<Map<String, dynamic>>> list = [];
    await conllectionMADXN
        .where('idTable', isEqualTo: idTable)
        .get()
        .then((foods) => foods.docs.forEach((dynamic food) => list.add(food)))
        .catchError((onError) => print(onError));
    return list;
  }

  Future<int> foodInTable(idTable) async {
    int hasFood = 0;
    await conllectionMADXN
        .where('idTable', isEqualTo: idTable)
        .get()
        .then((foods) => hasFood = foods.size);
    if (hasFood == 0) {
      await FirebaseFirestore.instance
          .collection('MonAnTamGoi')
          .where('idTable', isEqualTo: idTable)
          .get()
          .then((foods) => hasFood = foods.size);
    }
    return hasFood;
  }

  //Kiểm tra món có đang được gọi
  Future<bool> isFoodOrdering(String id) async {
    bool isOrdering = false;
    await conllectionMADXN.where("idFood", isEqualTo: id).get().then((value) {
      if (value.size > 0) isOrdering = true;
    });
    await FirebaseFirestore.instance
        .collection('MonAnTamGoi')
        .where("idFood", isEqualTo: id)
        .get()
        .then((value) {
      if (value.size > 0) isOrdering = true;
    });
    return isOrdering;
  }

  setSoldOutStatus(String idFood, bool isSoldOut) {
    conllectionMonAn
        .doc(idFood)
        .update({'isSoldOut': isSoldOut})
        .catchError((onError) =>
            Fluttertoast.showToast(msg: "Có lỗi xin kiểm tra lại!"))
        .whenComplete(() => Fluttertoast.showToast(msg: "Thành công!"));
  }
}
