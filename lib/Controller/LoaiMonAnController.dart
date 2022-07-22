import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:star_restaurant/DAO/ImageUpload.dart';
import 'package:star_restaurant/DAO/LoaiMonAnDAO.dart';
import 'package:star_restaurant/DAO/MonAnDAO.dart';
import 'package:star_restaurant/Model/LoaiMonAn.dart';

class LoaiMonAnConroller {
  final MonAnDAO _monAnDAO = MonAnDAO();
  final LoaiMonAnDAO _loaiMonAnDAO = LoaiMonAnDAO();
  final ImageUpload _imageUpload = ImageUpload();
  Future<void> addLoaiMonAn(
      LoaiMonAn loaiMonAn, File? imageFile, String imageName) async {
    String imageUrl = await _imageUpload.uploadFile(imageFile, imageName);
    loaiMonAn.image = imageUrl;
    _loaiMonAnDAO.addLoaiMonAn(loaiMonAn);
  }

  Future<void> delCate(LoaiMonAn loaiMonAn) async {
    int checkFoodInCate = await _monAnDAO.checkSizeFoodByCate(loaiMonAn.id);
    if (checkFoodInCate == 0) {
      _loaiMonAnDAO.delCate(loaiMonAn);
      return;
    }
    Fluttertoast.showToast(msg: "Không thể xóa vì có món ăn trong danh mục");
  }

  Future<void> updateLoaiMA(
      LoaiMonAn loaiMonAn, File? imageFile, String imageName) async {
    if (imageFile == "" || imageName.isEmpty) {
      _loaiMonAnDAO.update(loaiMonAn);
    } else {
      String imageUrl = await _imageUpload.uploadFile(imageFile, imageName);
      loaiMonAn.image = imageUrl;
      _loaiMonAnDAO.update(loaiMonAn);
    }
  }

  Future<LoaiMonAn> getLoaiMAbyID(String type) async =>
      _loaiMonAnDAO.getLoaiMAbyID(type);
}
