import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:star_restaurant/DAO/BanAnDAO.dart';
import 'package:star_restaurant/Model/BanAn.dart';
import 'package:star_restaurant/Model/MonAnDaGoi.dart';

class WaiterController {
  BanAnDAO banAnDAO = BanAnDAO();
  final User? _user = FirebaseAuth.instance.currentUser;

  void showTableInfo(DocumentSnapshot? document, Function onSuccess,
      Function(String) onErrorChecked) {
    if (document!.get('idUser') == "") {
      onSuccess();
      return;
    }
    bool checkCurrentUser = document.get('idUser') == _user!.uid ? true : false;
    if (checkCurrentUser) {
      onSuccess();
    } else {
      onErrorChecked('Bàn này không được phép xem!');
    }
  }

  void confirmOrders(
      String idT, Function onSuccess, Function(String) onfailure) {
    banAnDAO.confirmOrders(idT, onSuccess, onfailure);
  }

  void orderFood(DocumentSnapshot? tableFood, DocumentSnapshot? food,
      int amount, String note, Function onSuccess, Function(String) onfailure) {
    bool isUsing = tableFood!.get('idUser') == "" ? false : true;
    if (isUsing) {
      if (FirebaseAuth.instance.currentUser!.uid == tableFood.get('idUser')) {
        banAnDAO.addConfirmFood(
            tableFood.id, food, amount, note, onSuccess, onfailure);
      } else {
        onfailure("Bàn này đã có người phục vụ!");
      }
    } else {
      banAnDAO.addConfirmFoodtoNewTable(
          tableFood.id, food, amount, note, onSuccess, onfailure);
    }
  }

  void deleteConfirmFoodinTable(DocumentSnapshot? foodConfirm, String tableId,
      Function onSuccess, Function(String) onfailure) {
    banAnDAO.deleteConfirmFoodinTable(
        foodConfirm, tableId, onSuccess, onfailure);
  }

  void updateConfirmFood(QueryDocumentSnapshot? foodConfirm, String tableId,
      int amount, Function onSuccess, Function(String) onfailure) {
    banAnDAO.updateAmountConfirmFoodinTable(
        foodConfirm, tableId, amount, onSuccess, onfailure);
  }

  void deleteOrderedFoodinTable(MonAnDaGoi foodOrdered, idTable,
      Function onSuccess, Function(String) onfailure) {
    if (foodOrdered.status == "cooking") {
      onfailure("Món đang được làm. Không thể xóa!");
      return;
    }
    if (foodOrdered.status == "done") {
      onfailure("Món đã làm xong. Không thể xóa!");
      return;
    }
    if (foodOrdered.status == "new") {
      banAnDAO.deleteOrderedFoodinTable(
          foodOrdered, idTable, onSuccess, onfailure);
    }
  }

  void updateOrderedFoodAmount(MonAnDaGoi monAn, String idTable, int amount,
      Function onSuccess, Function(String) onfailure) {
    if (monAn.status == "cooking") {
      onfailure("Món đang được làm. Không thể thây đổi!");
      return;
    }
    if (monAn.status == "done") {
      onfailure("Món đã làm xong. Không thây đổi!");
      return;
    }
    if (monAn.status == "new") {
      banAnDAO.updateOrderedFoodinTable(
          monAn, idTable, amount, onSuccess, onfailure);
    }
  }

  void changeToNewTable(String fromTableId, String toTableId,
      Function onSuccess, Function(String) onfailure) {
    banAnDAO.changeTable(fromTableId, toTableId, onSuccess, onfailure);
  }

  Future<void> payTheBill(
      String idT, Function onSuccess, Function(String) onfailure) async {
    bool isPaying = await banAnDAO.isPayingTable(idT);
    if (isPaying) {
      onfailure("Bàn đã gửi yêu cầu thanh toán!");
      return;
    }
    banAnDAO.payTheBill(idT, onSuccess, onfailure);
  }

  void mergeTables(Map<int, Map<BanAn, bool>> listBanAn, Function onSuccess,
      Function(String) onfailure) {
    List<BanAn> listCheckedBanAn = [];
    // Lọc các table true(đã chọn)
    listBanAn.forEach((key, value) {
      if (value.containsValue(true)) {
        listCheckedBanAn.add(value.keys.first);
      }
    });
    // MAp dữ liệu để lưu xuống firebase
    Map<String, String> listTableToSave = Map<String, String>();
    listCheckedBanAn.forEach((element) {
      listTableToSave.addAll({element.name: element.id});
    });
    // banAnDAO.mergeTables(listTableToSave, onSuccess, onfailure);
  }
}
