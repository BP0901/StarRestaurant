import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:star_restaurant/DAO/ImageUpload.dart';
import 'package:star_restaurant/DAO/LoaiMonAnDAO.dart';
import 'package:star_restaurant/DAO/MonAnDAO.dart';
import 'package:star_restaurant/DAO/NhanVienDAO.dart';
import 'package:star_restaurant/DAO/BanAnDAO.dart';
import 'package:star_restaurant/Model/LoaiMonAn.dart';
import 'package:star_restaurant/Model/MonAn.dart';
import 'package:star_restaurant/Model/NhanVien.dart';

class ManagerController {
  ImageUpload imageUpload = ImageUpload();
  NhanVienDAO nhanVienDAO = NhanVienDAO();
  BanAnDAO banAnDAO = BanAnDAO();
  MonAnDAO monAnDAO = MonAnDAO();
  LoaiMonAnDAO loaiMonAnDAO = LoaiMonAnDAO();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void addStaff(NhanVien nhanVien) async {
    nhanVien.username = nhanVien.username + "@gmail.com";
    nhanVienDAO.createStaff(nhanVien);
  }

  void disableStaff(
      String id, Function onSuccess, Function(String) onfailure) async {
    nhanVienDAO.disableStaff(id, onSuccess, onfailure);
  }

  void deleteTable(
      String id, Function onSuccess, Function(String) onfailure) async {
    int foodInTable = await monAnDAO.foodInTable(id);
    if (foodInTable == 0) {
      banAnDAO.deleteTable(id, onSuccess, onfailure);
    } else {
      onfailure("Bàn hiện tại đang có món ăn. Không thể xóa!");
    }
  }

  void deleteFood(
      String id, Function onSuccess, Function(String) onfailure) async {
    bool check = await monAnDAO.isFoodOrdering(id);
    if (check) {
      onfailure("Món ăn hiện đang được chọn. Không thể xóa!");
    } else {
      monAnDAO.delete(id, onSuccess, onfailure);
    }
  }

  void addTable(String name, bool type) async =>
      banAnDAO.createTable(name, type);

  void updateStaff(String id, String name, int gender, DateTime birth,
      String role, Function onSuccess, Function(String) onfailure) {
    nhanVienDAO.updateStaff(
        id, name, gender, birth, role, onSuccess, onfailure);
  }

  void addFood(MonAn monAn, File? imageFile, String imageName) async {
    LoaiMonAn loaiMonAn = await loaiMonAnDAO.getLoaiMonAnByID(monAn.type);
    monAn.type = loaiMonAn.id;
    String imageUrl = await imageUpload.uploadFile(imageFile, imageName);
    monAn.image = imageUrl;
    monAnDAO.add(monAn);
  }

  void updateFood(MonAn monAn, File? imageFile, String imageName) async {
    LoaiMonAn loaiMonAn = await loaiMonAnDAO.getLoaiMonAnByID(monAn.type);
    monAn.type = loaiMonAn.id;
    if (monAn.image == "") {
      String imageUrl = await imageUpload.uploadFile(imageFile, imageName);
      monAn.image = imageUrl;
    }
    monAnDAO.update(monAn);
  }

  Future<List<LoaiMonAn>> getListCates() async => loaiMonAnDAO.getLisstCates();

  void setSoldOutStatus(String idFood, bool isSoldOut) =>
      monAnDAO.setSoldOutStatus(idFood, isSoldOut);
}
