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

  //Xác nhận đặt món
  void confirmOrders(
      String idT, Function onSuccess, Function(String) onfailure) {
    FirebaseFirestore.instance
        .collection("MonAnTamGoi")
        .where("idTable", isEqualTo: idT)
        .get()
        .then((value) {
      if (value.size != 0) {
        value.docs.forEach((element) {
          print(element.data());
          FirebaseFirestore.instance
              .collection("MonAnDaXacNhan")
              .doc()
              .set(element.data());
          FirebaseFirestore.instance
              .collection("MonAnTamGoi")
              .doc(element.id)
              .delete();
        });
        onSuccess();
      } else {
        onfailure("Lỗi: Thêm món ăn trước khi xác nhận");
      }
    });
  }

  // Thêm món ăn khi gọi món
  void addConfirmFood(String idTable, DocumentSnapshot? food, int amount,
      String note, Function onSuccess, Function(String) onfailure) {
    int price =
        food!.get('discount') == 0 ? food.get('price') : food.get('discount');
    Timestamp orderTime = Timestamp.fromDate(DateTime.now());
    FirebaseFirestore.instance
        .collection('MonAnTamGoi')
        .doc()
        .set({
          "idTable": idTable,
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

  // Thêm món ăn khi gọi món vào bàn chưa có người
  void addConfirmFoodtoNewTable(String idTable, DocumentSnapshot? food,
      int amount, String note, Function onSuccess, Function(String) onfailure) {
    int price =
        food!.get('discount') == 0 ? food.get('price') : food.get('discount');
    Timestamp orderTime = Timestamp.fromDate(DateTime.now());
    FirebaseFirestore.instance.collection('MonAnTamGoi').doc().set({
      "idTable": idTable,
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
        .doc(foodConfirm!.id)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('MonAnTamGoi')
          .where("idTable", isEqualTo: idTable)
          .get()
          .then((confirmFood) {
        if (confirmFood.size == 0) {
          FirebaseFirestore.instance
              .collection("MonAnDaXacNhan")
              .where("idTable", isEqualTo: idTable)
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
        .collection("MonAnDaXacNhan")
        .doc(foodOrdered!.id)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection("MonAnDaXacNhan")
          .where("idTable", isEqualTo: idTable)
          .get()
          .then(
        (foodOrderedData) {
          if (foodOrderedData.size == 0) {
            FirebaseFirestore.instance
                .collection('MonAnTamGoi')
                .where("idTable", isEqualTo: idTable)
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
        .collection("MonAnDaXacNhan")
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
        .collection("MonAnDaXacNhan")
        .where("idTable", isEqualTo: fromTableId)
        .get()
        .then((value) {
      value.docs.forEach((orderedFood) {
        // Thây đổi id bàn ăn
        FirebaseFirestore.instance
            .collection("MonAnDaXacNhan")
            .doc(orderedFood.id)
            .update({"idTable": toTableId});
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
      "idTable": idT,
      "total": 0,
      "idWaiter": _user!.uid,
      "idCashier": "",
      "status": "unpaid"
    }).then((bill) {
      // Duyệt món ăn đã gọi để thêm vào Chi tiết hóa đơn
      List<Map<String, dynamic>> list = [];
      FirebaseFirestore.instance
          .collection("MonAnDaXacNhan")
          .where("idTable", isEqualTo: idT)
          .get()
          .then((orderedFood) {
        orderedFood.docs.forEach((food) {
          list.add(food.data());
        });

        List<Map<String, dynamic>> checkedList = []; // list món ăn đã duyệt
        // Duyệt qua từng món ăn đã gọi
        for (int i = 0; i < list.length; i++) {
          bool flag = false; // biến kiểm tra món ăn trùng nhau
          checkedList.forEach((element) {
            if (element["idFood"] == list[i]["idFood"]) {
              flag = true;
            }
          });
          if (flag) {
            // nếu đã có món ăn trong checkedList
            continue;
          } else {
            // nếu chưa có món ăn trong checkedList
            List<Map<String, dynamic>> temp = [];
            temp.add(list[i]); // thêm mới vào món ăn mới đầu tiên
            for (int j = i + 1; j < list.length; j++) {
              // kiểm tra thêm vào tất cả các món ăn giống nhau
              if (list[i]["idFood"] == list[j]["idFood"]) {
                temp.add(list[j]);
              }
            }
            // rút về 1 món với tổng số lượng
            Map<String, dynamic> temp1 = temp[0];
            dynamic amount = 0;
            temp.forEach((food) {
              amount += food["amount"];
            });
            temp1["amount"] = amount;
            checkedList
                .add(temp1); // Thêm món đã cập nhật số lượng vào checkedList
          }
        }
        dynamic total = 0;
        checkedList.forEach((check) {
          //Duyệt checkedList để lưu vào ChiTietHoaDon và tổng tiền cảu bill
          total += check['amount'] * check['price'];
          FirebaseFirestore.instance.collection("ChiTietHoaDon").add({
            "idBill": bill.id,
            "foodName": check["name"],
            "idFood": check['idFood'],
            "amount": check['amount'],
            "price": check['price']
          });
        });
        FirebaseFirestore.instance
            .collection("HoaDon")
            .doc(bill.id)
            .update({"total": total});
      });
    }).whenComplete(() {
      // Xóa các món ăn trong danh sách tạm gọi
      FirebaseFirestore.instance
          .collection('MonAnTamGoi')
          .where("idTable", isEqualTo: idT)
          .get()
          .then((foodConfirm) {
        foodConfirm.docs.forEach((food) => FirebaseFirestore.instance
            .collection('MonAnTamGoi')
            .doc(food.id)
            .delete());
      });

      // Chuyển trạng thái bàn thành đang thanh toán
      _ref.doc(idT).update({"isPaying": true});
      onSuccess();
    }).catchError((onError) {
      print("err: " + onError.toString());
      onfailure("Có lỗi xẩy ra. Xin kiểm tra lại!");
    });
  }
}
