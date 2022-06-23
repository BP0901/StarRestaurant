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

  void orderFood(DocumentSnapshot? tableFood, DocumentSnapshot? food, int amount,
      Function onSuccess, Function(String) onfailure) {
    if (tableFood!.get('isUsing')) {
      if (FirebaseAuth.instance.currentUser!.uid == tableFood.get('idUser')) {
        banAnDAO.addConfirmFood(tableFood.get("id"),food,amount, onSuccess, onfailure);
      } else {
        onfailure("Bàn này đã có người phục vụ!");
      }
    } else {
      banAnDAO.addConfirmFoodtoNewTable(tableFood.get("id"),food,amount, onSuccess, onfailure);
    }
  }
}
