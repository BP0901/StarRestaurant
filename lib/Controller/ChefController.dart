import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_restaurant/DAO/MonAnDAO.dart';

class ChefController {
  MonAnDAO monAnDAO = MonAnDAO();
  confirmCooking(String id, Function onSuccess, Function(String) onfailure) {
    monAnDAO.confirm(id, onSuccess, onfailure);
  }

  cancelCooking(String id, Function onSuccess, Function(String) onfailure) {
    monAnDAO.cancel(id, onSuccess, onfailure);
  }
  successCooking(String id, Function onSuccess, Function(String) onfailure) {
    monAnDAO.success(id, onSuccess, onfailure);
  }
}
