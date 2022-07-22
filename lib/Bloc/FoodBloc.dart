import 'dart:async';

import 'package:star_restaurant/Controller/ManagerController.dart';

class FoodBloc {
  final ManagerController _managerController = ManagerController();

  final StreamController _discountController = StreamController();
  final StreamController _nameController = StreamController();
  final StreamController _priceController = StreamController();
  final StreamController _unitController = StreamController();

  Stream get discountStream => _discountController.stream;
  Stream get nameStream => _nameController.stream;
  Stream get priceStream => _priceController.stream;
  Stream get unitStream => _unitController.stream;

  bool isAddOrEditFoodValid(
      String discount, String name, String price, String unit) {
    if (name == "" || name.isEmpty) {
      _nameController.sink.addError("Nhập tên món ăn");
      return false;
    }
    _nameController.sink.add("");

    if (price == "" || price.isEmpty) {
      _priceController.sink.addError("Nhập giá món ăn");
      return false;
    }

    var intPrice = int.tryParse(price);
    if (intPrice == null) {
      _priceController.sink.addError("Không phải số");
      return false;
    } else if (intPrice < 0) {
      _priceController.sink.addError("Giá không được nhỏ hơn 0");
      return false;
    }
    _priceController.add("");

    var intDiscount = int.tryParse(discount);
    if (intDiscount == null) {
      _discountController.sink.addError("Không phải số");
      return false;
    } else if (intDiscount < 0) {
      _discountController.sink.addError("Giá không được nhỏ hơn 0");
      return false;
    } else if (intDiscount > intPrice) {
      _discountController.sink.addError("Giá giảm lớn hơn giá gốc");
      return false;
    }
    _discountController.add("");

    if (unit == "" || unit.isEmpty) {
      _unitController.sink.addError("Nhập đơn vị tính");
      return false;
    }
    _unitController.sink.add("");

    return true;
  }

  void dispose() {
    _discountController.close();
    _nameController.close();
    _priceController.close();
    _unitController.close();
  }
}
