import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_restaurant/DAO/LoaiMonAnDAO.dart';
import 'package:star_restaurant/DAO/MonAnDAO.dart';
import 'package:star_restaurant/DAO/NhanVienDAO.dart';
import 'package:star_restaurant/DAO/BanAnDAO.dart';
import 'package:star_restaurant/Model/LoaiMonAn.dart';
import 'package:star_restaurant/Model/MonAn.dart';
import '../DAO/FirebaseAuth.dart';

class ManagerController {
  NhanVienDAO nhanVienDAO = NhanVienDAO();
  BanAnDAO banAnDAO = BanAnDAO();
  MonAnDAO monAnDAO = MonAnDAO();
  LoaiMonAnDAO loaiMonAnDAO = LoaiMonAnDAO();
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
    nhanVienDAO.deleteStaff(id, onSuccess, onfailure);
  }

  void deleteTable(
      String id, Function onSuccess, Function(String) onfailure) async {
    banAnDAO.deleteTable(id, onSuccess, onfailure);
  }

  void deleteFood(
      String id, Function onSuccess, Function(String) onfailure) async {
    monAnDAO.delete(id, onSuccess, onfailure);
  }

  void addTable(String name, bool type, Function onSuccess,
      Function(String) onfailure) async {
    String password = '123456';
    try {
      banAnDAO.createTable(name, type, onSuccess, onfailure);
    } catch (e) {}
  }

  void updateStaff(String id, String name, int gender, DateTime birth,
      String role, Function onSuccess, Function(String) onfailure) {
    nhanVienDAO.updateStaff(
        id, name, gender, birth, role, onSuccess, onfailure);
  }

  void addFood(
      MonAn monAn, Function onSuccess, Function(String) onfailure) async {
    LoaiMonAn loaiMonAn = await loaiMonAnDAO.getLoaiMonAnByID(monAn.type);
    monAn.type = loaiMonAn.id;
    try {
      monAnDAO.add(monAn, onSuccess, onfailure);
    } catch (e) {}
  }

  void updateFood(
      String id,
      String name,
      String image,
      int price,
      int discount,
      String type,
      String unit,
      Function onSuccess,
      Function(String) onfailure) async {
    monAnDAO.update(
        id, name, image, price, discount, type, unit, onSuccess, onfailure);
  }

  Future<List<LoaiMonAn>> getListCates() async => loaiMonAnDAO.getLisstCates();
}
