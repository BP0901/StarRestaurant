import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BanAnDAO {
  final User? _user = FirebaseAuth.instance.currentUser;
  final _ref = FirebaseFirestore.instance.collection('BanAn');

  void checkIsUsingAndUser(DocumentSnapshot? document, Function onSuccess,
      Function(String) onErrorChecked) {
    if (!document!.get('isUsing')) {
      onSuccess();
    } else {
      bool checkCurrentUser =
          document.get('idUser') == _user!.uid ? true : false;
      if (checkCurrentUser) {
        onSuccess();
      } else {
        onErrorChecked('Bàn này không được phép xem!');
      }
    }
  }

  void confirmOrders(
      String idT, Function onSuccess, Function(String) onfailure) {
    FirebaseFirestore.instance
        .collection("MonAnTamGoi/$idT/MonAnChoXacNhan")
        .get()
        .then((value) {
      if (value.size != 0) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection("MonAnDaXacNhan/$idT/DaXacNhan")
              .doc()
              .set(element.data());
          FirebaseFirestore.instance
              .collection("MonAnTamGoi/$idT/MonAnChoXacNhan")
              .doc(element.id)
              .delete();
        });
        onSuccess();
      } else {
        onfailure("Lỗi: Thêm món ăn trước khi xác nhận");
      }
    });
  }

  void addConfirmFood(String idTable, DocumentSnapshot? food, int amount,
      Function onSuccess, Function(String) onfailure) {
    int price =
        food!.get('discount') == 0 ? food.get('price') : food.get('discount');

    FirebaseFirestore.instance
        .collection('MonAnTamGoi')
        .doc(idTable)
        .collection("MonAnChoXacNhan")
        .doc()
        .set({
          "amount": amount,
          "idFood": food.get('id'),
          "price": price,
          "name": food.get('name')
        })
        .then((value) => onSuccess())
        .catchError((onError) {
          print("err: " + onError.toString());
          onfailure("Có lỗi xẩy ra. Xin kiểm tra lại!");
        });
  }

  void addConfirmFoodtoNewTable(String idTable, DocumentSnapshot? food,
      int amount, Function onSuccess, Function(String) onfailure) {
    int price =
        food!.get('discount') == 0 ? food.get('price') : food.get('discount');

    FirebaseFirestore.instance
        .collection('MonAnTamGoi')
        .doc(idTable)
        .collection("MonAnChoXacNhan")
        .doc()
        .set({
      "amount": amount,
      "idFood": food.get('id'),
      "price": price,
      "name": food.get('name')
    }).then((value) {
      _ref.doc(idTable).update({"isUsing": true, "idUser": _user!.uid}).then(
          (value) => onSuccess());
    }).catchError((onError) {
      print("err: " + onError.toString());
      onfailure("Có lỗi xẩy ra. Xin kiểm tra lại!");
    });
  }
}
