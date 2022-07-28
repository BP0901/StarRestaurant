import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:star_restaurant/DAO/BanAnDAO.dart';
import 'package:star_restaurant/DAO/MonAnDAO.dart';
import 'package:star_restaurant/Model/BanAn.dart';
import 'package:star_restaurant/Model/MonAnDaGoi.dart';

class WaiterController {
  BanAnDAO banAnDAO = BanAnDAO();
  MonAnDAO monAnDAO = MonAnDAO();
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
      String idT,
      Future<List<DocumentSnapshot<Map<String, dynamic>>>> listFoods,
      Function onSuccess,
      Function(String) onfailure) async {
    bool isPaying = await banAnDAO.isPayingTable(idT);
    if (isPaying) {
      onfailure("Bàn đã gửi yêu cầu thanh toán!");
      return;
    }
    List<DocumentSnapshot<Map<String, dynamic>>> list = await listFoods;
    banAnDAO.payTheBill(idT, list, onSuccess, onfailure);
  }

  Future<void> mergeTables(
      DocumentSnapshot? curTable,
      Map<DocumentSnapshot?, bool> listBanAn,
      Function onSuccess,
      Function(String) onfailure) async {
    List<DocumentSnapshot?> listCheckedBanAn = [];
    // Lọc các table true(đã chọn)
    listBanAn.forEach((key, value) {
      if (value == true) {
        listCheckedBanAn.add(key);
      }
    });
    // Map dữ liệu để lưu xuống firebase
    Map<String, dynamic> listTableToSave = <String, dynamic>{};
    await Future.forEach(listCheckedBanAn, (DocumentSnapshot? element) async {
      BanAn banAn = await banAnDAO.getBanAnbyID(element!.id);
      listTableToSave.addAll({banAn.name: element.id});
    });
    String isMerging = curTable!.get('isMerging');
    //ghép bàn ăn mới
    if (isMerging.isEmpty) {
      banAnDAO.setNewMergeTables(listTableToSave);
    } else {
      //Ghép thêm bàn ăn
      listTableToSave.removeWhere((key, value) => value == curTable.id);
      banAnDAO.setMergeTables(listTableToSave, isMerging);
    }
  }

  Future<bool> isMergingTable(String idTable) =>
      banAnDAO.isMergingTable(idTable);

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getAllFoodinTables(
      String idTable) async {
    List<DocumentSnapshot<Map<String, dynamic>>> listFoods = [];
    //Lấy đường dẫn tới danh sách bàn ghép
    String idMerged = await banAnDAO.getRefMergeredTable(idTable);
    //Lấy id các bàn đã ghép
    List<dynamic> listIdTables = await banAnDAO.getMergeTables(idMerged);
    //Lấy các món ăn theo danh sách id bàn
    listFoods = await monAnDAO.getAllFoodInTables(listIdTables);
    return listFoods;
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getAllFood(
          String idTable) async =>
      await monAnDAO.getAllFoodbyIdTable(idTable);

  Future<String> getTableName(String idTable) async =>
      banAnDAO.getTableName(idTable);

  //Xóa bàn ăn đã ghép
  Future<void> delMergedTable(
      String idMerged, String nameTable, idTable) async {
    banAnDAO.delMergedTable(idMerged, nameTable, idTable);
    banAnDAO.unuseTable(idTable);
  }
}
