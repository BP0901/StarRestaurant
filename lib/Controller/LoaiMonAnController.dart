import 'package:star_restaurant/DAO/LoaiMonAnDAO.dart';
import 'package:star_restaurant/Model/LoaiMonAn.dart';

class LoaiMonAnConroller {
  final LoaiMonAnDAO _loaiMonAnDAO = LoaiMonAnDAO();
  void addLoaiMonAn(LoaiMonAn loaiMonAn) {
    _loaiMonAnDAO.addLoaiMonAn(loaiMonAn);
  }

  void delCate(LoaiMonAn loaiMonAn) => _loaiMonAnDAO.delCate(loaiMonAn);

  void updateLoaiMA(LoaiMonAn loaiMonAn) => _loaiMonAnDAO.update(loaiMonAn);

  Future<LoaiMonAn> getLoaiMAbyID(String type) async =>
      _loaiMonAnDAO.getLoaiMAbyID(type);
}
