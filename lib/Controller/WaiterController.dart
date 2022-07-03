import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:star_restaurant/DAO/BanAnDAO.dart';

class WaiterController {
  BanAnDAO banAnDAO = BanAnDAO();

  void showTableInfo(DocumentSnapshot? document, Function onSuccess,
      Function(String) onErrorChecked) {
    banAnDAO.checkIsUsingAndUser(document, onSuccess, onErrorChecked);
  }

  void confirmOrders(
      String idT, Function onSuccess, Function(String) onfailure) {
    banAnDAO.confirmOrders(idT, onSuccess, onfailure);
  }

  void orderFood(DocumentSnapshot? tableFood, DocumentSnapshot? food,
      int amount, String note, Function onSuccess, Function(String) onfailure) {
    if (tableFood!.get('isUsing')) {
      if (FirebaseAuth.instance.currentUser!.uid == tableFood.get('idUser')) {
        banAnDAO.addConfirmFood(
            tableFood.get("id"), food, amount, note, onSuccess, onfailure);
      } else {
        onfailure("Bàn này đã có người phục vụ!");
      }
    } else {
      banAnDAO.addConfirmFoodtoNewTable(
          tableFood.get("id"), food, amount, note, onSuccess, onfailure);
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

  void deleteOrderedFoodinTable(QueryDocumentSnapshot? foodOrdered, idTable,
      Function onSuccess, Function(String) onfailure) {
    if (foodOrdered!.get('status') == "cooking") {
      onfailure("Món đang được làm. Không thể xóa!");
      return;
    }
    if (foodOrdered.get('status') == "done") {
      onfailure("Món đã làm xong. Không thể xóa!");
      return;
    }
    if (foodOrdered.get('status') == "new") {
      banAnDAO.deleteOrderedFoodinTable(
          foodOrdered, idTable, onSuccess, onfailure);
    }
  }

  void updateOrderedFoodAmount(
      QueryDocumentSnapshot? foodOrdered,
      String idTable,
      int amount,
      Function onSuccess,
      Function(String) onfailure) {
    if (foodOrdered!.get('status') == "cooking") {
      onfailure("Món đang được làm. Không thể thây đổi!");
      return;
    }
    if (foodOrdered.get('status') == "done") {
      onfailure("Món đã làm xong. Không thây đổi!");
      return;
    }
    if (foodOrdered.get('status') == "new") {
      banAnDAO.updateOrderedFoodinTable(
          foodOrdered, idTable, amount, onSuccess, onfailure);
    }
  }

  void changeToNewTable(String fromTableId, String toTableId,
      Function onSuccess, Function(String) onfailure) {
    banAnDAO.changeTable(fromTableId, toTableId, onSuccess, onfailure);
  }

  void payTheBill(String idT, Function onSuccess, Function(String) onfailure) {
    banAnDAO.payTheBill(idT, onSuccess, onfailure);
  }
}
