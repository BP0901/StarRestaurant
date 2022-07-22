import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_restaurant/DAO/HoaDonDAO.dart';

class CashierController {
  final HoaDonDAO _hoaDonDAO = HoaDonDAO();
  void confirmPayTheBill(
      DocumentSnapshot? bill, Function onSuccess, Function(String) onfailure) {
    _hoaDonDAO.confirmPayTheBill(bill, onSuccess, onfailure);
  }
}
