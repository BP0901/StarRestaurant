import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_restaurant/DAO/NhanVienDAO.dart';
import 'package:star_restaurant/DAO/BanAnDAO.dart';
import '../DAO/FirebaseAuth.dart';

class ManagerController {
  NhanVienDAO nhanVienDAO = NhanVienDAO();
  BanAnDAO banAnDAO = BanAnDAO();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void addStaff(
      String name,
      int gender,
      DateTime birth,
      String role,
      bool disable,
      String username,
      Function onSuccess,
      Function(String) onfailure) async {
    String password = '123456';
    try {
      nhanVienDAO.createStaff(name, gender, birth, password, role, disable,
          username, onSuccess, onfailure);
    } catch (e) {}
  }

  void deleteStaff(
      String id, Function onSuccess, Function(String) onfailure) async {
    nhanVienDAO.deleteStaff(id, onSuccess, (p0) => null);
  }

  void deleteTable(
      String id, Function onSuccess, Function(String) onfailure) async {
    banAnDAO.deleteTable(id, onSuccess, (p0) => null);
  }

  void deleteFoot(
      String id, Function onSuccess, Function(String) onfailure) async {
    nhanVienDAO.deleteStaff(id, onSuccess, (p0) => null);
  }

  void addTable(String name, bool type, Function onSuccess,
      Function(String) onfailure) async {
    String password = '123456';
    try {
      banAnDAO.createTable(name, type, onSuccess, onfailure);
    } catch (e) {}
  }
}
