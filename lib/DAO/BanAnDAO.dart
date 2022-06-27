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
          print(element.data());
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
      String note, Function onSuccess, Function(String) onfailure) {
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
          "name": food.get('name'),
          "note": note,
          "status": "new"
        })
        .then((value) => onSuccess())
        .catchError((onError) {
          print("err: " + onError.toString());
          onfailure("Có lỗi xẩy ra. Xin kiểm tra lại!");
        });
  }

  void addConfirmFoodtoNewTable(String idTable, DocumentSnapshot? food,
      int amount, String note, Function onSuccess, Function(String) onfailure) {
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
      "name": food.get('name'),
      "note": note,
      "status": "new"
    }).then((value) {
      _ref.doc(idTable).update({"isUsing": true, "idUser": _user!.uid}).then(
          (value) => onSuccess());
    }).catchError((onError) {
      print("err: " + onError.toString());
      onfailure("Có lỗi xẩy ra. Xin kiểm tra lại!");
    });
  }

  void deleteConfirmFoodinTable(DocumentSnapshot? foodConfirm, String idTable,
      Function onSuccess, Function(String) onfailure) {
    FirebaseFirestore.instance
        .collection('MonAnTamGoi')
        .doc(idTable)
        .collection("MonAnChoXacNhan")
        .doc(foodConfirm!.id)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('MonAnTamGoi')
          .doc(idTable)
          .collection("MonAnChoXacNhan")
          .get()
          .then((confirmFood) {
        if (confirmFood.size == 0) {
          FirebaseFirestore.instance
              .collection("MonAnDaXacNhan/$idTable/DaXacNhan")
              .get()
              .then((confirmedFood) {
            if (confirmedFood.size == 0) {
              _ref.doc(idTable).update({"isUsing": false, "idUser": ""});
            }
          });
        }
      });
      onSuccess();
    }).catchError((onError) {
      print("err: " + onError.toString());
      onfailure("Có lỗi xẩy ra. Xin kiểm tra lại!");
    });
  }

  void updateAmountConfirmFoodinTable(
      QueryDocumentSnapshot? foodConfirm,
      String idTable,
      int amount,
      Function onSuccess,
      Function(String) onfailure) {
    FirebaseFirestore.instance
        .collection('MonAnTamGoi')
        .doc(idTable)
        .collection("MonAnChoXacNhan")
        .doc(foodConfirm!.id)
        .update({"amount": amount})
        .then((value) => onSuccess())
        .catchError((onError) {
          onfailure("Thây đổi số lượng thất bại");
        });
  }

  void deleteOrderedFoodinTable(QueryDocumentSnapshot? foodOrdered, idTable,
      Function onSuccess, Function(String) onfailure) {
    FirebaseFirestore.instance
        .collection("MonAnDaXacNhan/$idTable/DaXacNhan")
        .doc(foodOrdered!.id)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection("MonAnDaXacNhan/$idTable/DaXacNhan")
          .get()
          .then(
        (foodOrderedData) {
          if (foodOrderedData.size == 0) {
            FirebaseFirestore.instance
                .collection('MonAnTamGoi')
                .doc(idTable)
                .collection("MonAnChoXacNhan")
                .get()
                .then((foodConfirm) {
              if (foodConfirm.size == 0) {
                _ref.doc(idTable).update({"isUsing": false, "idUser": ""});
              }
            });
          }
        },
      );
      onSuccess();
    }).catchError((onError) {
      print("err: " + onError.toString());
      onfailure("Có lỗi xẩy ra. Xin kiểm tra lại!");
    });
  }

  void updateOrderedFoodinTable(
      QueryDocumentSnapshot? foodOrdered,
      String idTable,
      int amount,
      Function onSuccess,
      Function(String) onfailure) {
    FirebaseFirestore.instance
        .collection("MonAnDaXacNhan/$idTable/DaXacNhan")
        .doc(foodOrdered!.id)
        .update({"amount": amount})
        .then((value) => onSuccess())
        .catchError((onError) {
          onfailure("Thây đổi số lượng thất bại");
        });
  }
}
