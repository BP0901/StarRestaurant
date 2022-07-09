import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HoaDonDAO {
  final _refHoaDon = FirebaseFirestore.instance.collection("HoaDon");
  final _refBanAn = FirebaseFirestore.instance.collection("BanAn");
  final _refMonAnDaGoi =
      FirebaseFirestore.instance.collection("MonAnDaXacNhan");
  final _refChiTietHoaDon =
      FirebaseFirestore.instance.collection("ChiTietHoaDon ");
  final User? _user = FirebaseAuth.instance.currentUser;

  void confirmPayTheBill(
      DocumentSnapshot? bill, Function onSuccess, Function(String) onfailure) {
    String idTable = bill!.get("idTable");
    _refHoaDon
        .doc(bill.id)
        .update({"status": "paid", "idCashier": _user!.uid})
        .then((value) {
          _refBanAn.doc(idTable).update({
            "idUser": "",
            "isPaying": false,
            "isUsing": false,
          });
          _refMonAnDaGoi
              .where("idTable", isEqualTo: idTable)
              .get()
              .then((foods) => foods.docs.forEach((food) {
                    _refMonAnDaGoi.doc(food.id).delete();
                  }));
        })
        .whenComplete(() => onSuccess())
        .catchError((onError) {
          print("err: " + onError.toString());
          onfailure("Có lỗi xẩy ra. Xin kiểm tra lại!");
        });
  }
}
