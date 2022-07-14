import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../Components/flash_message.dart';
import '../../../Util/Constants.dart';
import '../../../Controller/ManagerController.dart';

class EditMenu extends StatefulWidget {
  final DocumentSnapshot? food;
  const EditMenu({Key? key, required this.food}) : super(key: key);
  @override
  State<EditMenu> createState() => _editMenu();
}

class _editMenu extends State<EditMenu> {
  DocumentSnapshot? food;

  ManagerController controller = ManagerController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _nameEditingController = TextEditingController();
  final _priceEditingController = TextEditingController();
  final _discountEditingController = TextEditingController();
  String _type = 'hap';
  String _name = '';
  int _price = 0;
  String _image = '';
  String _unit = 'chai';
  String _fid = '';
  int _discount = 0;
  final List<DropdownMenuItem<String>> _dropDownLoaiMon = <String>[
    'hap',
    'Chiên',
    'Lẩu',
    'Khai vị',
    'Nướng',
    'Nước uống'
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: TextStyle(color: Colors.blue),
      ),
    );
  }).toList();
  final List<DropdownMenuItem<String>> _dropDownDonVi = <String>[
    'chai',
    'phần',
    'dĩa',
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: TextStyle(color: Colors.blue),
      ),
    );
  }).toList();
  @override
  void initState() {
    super.initState();
    food = widget.food;
    if (food != null) {
      _fid = food!.id;
      _name = food?.get('name');
      _type = food?.get('type');
      _price = food?.get('price');
      _unit = food?.get('unit');
      _discount = food?.get('discount');
      _image = food?.get('image');
      _nameEditingController.text = _name;
      // _priceEditingController.text = _username;
      // _dateEditingController.text=DateFormat.yMd().format(this._birth);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (food == null) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: kAppBarColor,
            title: const Text('Quản lý thực đơn'),
          ),
          key: _scaffoldKey,
          body: SafeArea(
            child: Container(
              color: kSupColor,
              padding:
                  EdgeInsets.only(right: 10, bottom: 20, left: 10, top: 10),
              child: Column(
                children: [
                  Text(
                    'THÊM MÓN ĂN',
                    style: TextStyle(
                        color: kSuccessColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 20)),
                  TextField(
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _nameEditingController,
                    onChanged: (text) {
                      this.setState(() {
                        _name =
                            text; //when state changed => build() rerun => reload widget
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Tên món ăn',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  TextField(
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _priceEditingController,
                    onChanged: (text) => setState(() {
                      _price = int.parse(
                          text); //when state changed => build() rerun => reload widget
                    }),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Giá tiền',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  TextField(
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _discountEditingController,
                    onChanged: (text) => setState(() {
                      _discount = int.parse(
                          text); //when state changed => build() rerun => reload widget
                    }),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Discount',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  ListTile(
                    title: const Text(
                      'Loại món ăn:',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: DropdownButton(
                      value: _type,
                      onChanged: (String? value) {
                        setState(() {
                          _type = value.toString();
                        });
                      },
                      items: _dropDownLoaiMon,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  ListTile(
                    title: const Text(
                      'Đơn vị tính:',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: DropdownButton(
                      value: _unit,
                      onChanged: (String? unit) {
                        setState(() {
                          _unit = unit.toString();
                        });
                      },
                      items: _dropDownDonVi,
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: kSupColor,
            padding: EdgeInsets.only(bottom: 10),
            child: MaterialButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              padding: EdgeInsets.all(10),
              height: 50,
              color: kSuccessColor,
              minWidth: double.infinity,
              onPressed: () {
                controller.addFood(
                    _name, _image, _price, _discount, _type, _unit, () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: FlashMessageScreen(
                          type: "Thông báo",
                          content: "Cập nhật thành công!",
                          color: Colors.green),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  );
                }, (msg) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: FlashMessageScreen(
                          type: "Thông báo",
                          content: msg,
                          color: kPrimaryColor),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  );
                });
              },
              child: Text(
                'Thêm mới',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: kAppBarColor,
            title: const Text('Quản lý thực đơn'),
          ),
          key: _scaffoldKey,
          body: SafeArea(
            child: Container(
              color: kSupColor,
              padding:
              EdgeInsets.only(right: 10, bottom: 20, left: 10, top: 10),
              child: Column(
                children: [
                  const Text(
                    'CHỈNH SỬA MÓN ĂN',
                    style: TextStyle(
                        color: kSuccessColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 20)),
                  TextField(
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _nameEditingController,
                    onChanged: (text) {
                      this.setState(() {
                        _name =
                            text; //when state changed => build() rerun => reload widget
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Tên món ăn',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  TextField(
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _priceEditingController,
                    onChanged: (text) => setState(() {
                      _price = int.parse(
                          text); //when state changed => build() rerun => reload widget
                    }),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Giá tiền',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  TextField(
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _discountEditingController,
                    onChanged: (text) => setState(() {
                      _discount = int.parse(
                          text); //when state changed => build() rerun => reload widget
                    }),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Discount',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  ListTile(
                    title: const Text(
                      'Loại món ăn:',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: DropdownButton(
                      value: _type,
                      onChanged: (String? value) {
                        setState(() {
                          _type = value.toString();
                        });
                      },
                      items: _dropDownLoaiMon,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  ListTile(
                    title: const Text(
                      'Đơn vị tính:',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: DropdownButton(
                      value: _unit,
                      onChanged: (String? unit) {
                        setState(() {
                          _unit = unit.toString();
                        });
                      },
                      items: _dropDownDonVi,
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: kSupColor,
            padding: EdgeInsets.only(bottom: 10),
            child: MaterialButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              padding: EdgeInsets.all(10),
              height: 50,
              color: kSuccessColor,
              minWidth: double.infinity,
              onPressed: () {
                controller.updateFood(_fid,
                    _name, _image, _price, _discount, _type, _unit, () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: FlashMessageScreen(
                          type: "Thông báo",
                          content: "Cập nhật thành công!",
                          color: Colors.green),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  );
                }, (msg) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: FlashMessageScreen(
                          type: "Thông báo",
                          content: msg,
                          color: kPrimaryColor),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  );
                });
              },
              child: Text(
                'Cập nhật',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ));
    }
  }
}
