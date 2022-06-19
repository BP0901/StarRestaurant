import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_restaurant/DAO/BanAnDAO.dart';

class WaiterController {
  BanAnDAO banAnDAO = BanAnDAO();

  void showTableInfo(DocumentSnapshot? document, Function onSuccess,
      Function(String) onErrorChecked) {
    banAnDAO.checkIsUsingAndUser(document, onSuccess, onErrorChecked);
  }
}
