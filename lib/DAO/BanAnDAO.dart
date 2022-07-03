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
    Timestamp orderTime = Timestamp.fromDate(DateTime.now());
    FirebaseFirestore.instance
        .collection('MonAnTamGoi')
        .doc(idTable)
        .collection("MonAnChoXacNhan")
        .doc()
        .set({
          "orderTime": orderTime,
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
    Timestamp orderTime = Timestamp.fromDate(DateTime.now());
    FirebaseFirestore.instance
        .collection('MonAnTamGoi')
        .doc(idTable)
        .collection("MonAnChoXacNhan")
        .doc()
        .set({
      "orderTime": orderTime,
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

  void changeTable(String fromTableId, String toTableId, Function onSuccess,
      Function(String) onfailure) {
    // Duyệt món ăn từ bàn hiện tại
    FirebaseFirestore.instance
        .collection("MonAnDaXacNhan/$fromTableId/DaXacNhan")
        .get()
        .then((value) {
      value.docs.forEach((orderedFood) {
        // Thêm món ăn vào bàn mới
        FirebaseFirestore.instance
            .collection("MonAnDaXacNhan/$toTableId/DaXacNhan")
            .add(orderedFood.data());
        // Xóa món ăn bàn hiện tại
        FirebaseFirestore.instance
            .collection("MonAnDaXacNhan/$fromTableId/DaXacNhan")
            .doc(orderedFood.id)
            .delete();
      });
    }).whenComplete(() {
      // Cập nhật user phục vụ bàn ăn
      _ref.doc(fromTableId).update({"isUsing": false, "idUser": ""});
      _ref.doc(toTableId).update({"isUsing": true, "idUser": _user!.uid});
      onSuccess();
    }).catchError((err) {
      print("err: " + err.toString());
      // onfailure("Chuyển bàn thất bại!");
    });
  }

  void payTheBill(String idT, Function onSuccess, Function(String) onfailure) {
    // Tạo hóa đơn mới
    Timestamp payTime = Timestamp.fromDate(DateTime.now());
    FirebaseFirestore.instance.collection("HoaDon").add({
      "date": payTime,
      "total": 0,
      "idWaiter": _user!.uid,
      "idCashier": "",
      "status": "unpaid"
    }).then((bill) {
      // Duyệt món ăn đã gọi để thêm vào Chi tiết hóa đơn
      FirebaseFirestore.instance
          .collection("MonAnDaXacNhan/$idT/DaXacNhan")
          .get()
          .then((orderedFood) {
        int total = 0; // tổng tiền các món ăn
        orderedFood.docs.forEach((food) {
          // Kiểm tra nếu món đã có thì cập nhật số lượng hoặc thêm mới
          FirebaseFirestore.instance
              .collection("ChiTietHoaDon")
              .where("idBill", isEqualTo: bill.id)
              .get()
              .then((value) {
            print(value.size);
            if (value.size == 0) {
              // Thêm mới

              FirebaseFirestore.instance.collection("ChiTietHoaDon").add({
                "idBill": bill.id,
                "idFood": food.get('idFood'),
                "amount": food.get('amount'),
                "price": food.get('price')
              });
            } else {
              int amount = value.docs[0].get('amount') + food.get('amount');
              // Cập nhật lại số lượng

              FirebaseFirestore.instance
                  .collection("ChiTietHoaDon")
                  .doc(value.docs[0].id)
                  .update({"amount": amount});
            }
          });
        });
      });
    }).whenComplete(() {
      // Chuyển trạng thái bàn thành đang thanh toán

      _ref.doc(idT).update({"isPaying": true});
    });
  }
}
