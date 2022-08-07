import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HoaDonDAO {
  final _refHoaDon = FirebaseFirestore.instance.collection("HoaDon");
  final _refBanDangSuDung =
      FirebaseFirestore.instance.collection("BanDangSuDung");
  final _refMonAnDaGoi =
      FirebaseFirestore.instance.collection("MonAnDaXacNhan");
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<void> confirmPayTheBill(DocumentSnapshot? bill, Function onSuccess,
      Function(String) onfailure) async {
    String idTable = bill!.get("idTable");
    await _refHoaDon
        .doc(bill.id)
        .update({"status": "paid", "idCashier": _user!.uid}).catchError(
            (onError) => onfailure("Có lỗi. Xin kiểm tra lại!"));

    await _refBanDangSuDung
        .doc(idTable)
        .get()
        .then((value) {
          if (value.get("isMerging") != "") {
            FirebaseFirestore.instance
                .collection("BanDangGhep")
                .doc(value.get("isMerging"))
                .get()
                .then((value) {
              List listIdTables = value.data()!.values.toList();
              listIdTables.forEach((idT) {
                _refBanDangSuDung
                    .doc(idT)
                    .update({"idUser": "", "isPaying": false, "isMerging": ""});
                _refMonAnDaGoi
                    .where("idTable", isEqualTo: idT)
                    .get()
                    .then((foods) => foods.docs.forEach((food) {
                          _refMonAnDaGoi.doc(food.id).delete();
                        }));
              });
            });
          } else {
            _refBanDangSuDung
                .doc(idTable)
                .update({"idUser": "", "isPaying": false, "isMerging": ""});
            _refMonAnDaGoi
                .where("idTable", isEqualTo: idTable)
                .get()
                .then((foods) => foods.docs.forEach((food) {
                      _refMonAnDaGoi.doc(food.id).delete();
                    }));
          }
        })
        .catchError((onError) => onfailure("Có lỗi. Xin kiểm tra lại!"))
        .whenComplete(() => onSuccess());
  }
}
