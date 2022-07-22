import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star_restaurant/Bloc/FoodBloc.dart';
import 'package:star_restaurant/Model/MonAn.dart';
import '../../../Model/LoaiMonAn.dart';
import '../../../Util/Constants.dart';
import '../../../Controller/ManagerController.dart';

class EditMenu extends StatefulWidget {
  final DocumentSnapshot? food;
  const EditMenu({Key? key, required this.food}) : super(key: key);
  @override
  State<EditMenu> createState() => _editMenu();
}

class _editMenu extends State<EditMenu> {
  final FoodBloc _foodBloc = FoodBloc();
  String imageName = "";
  String imageUrl = "";
  DocumentSnapshot? food;
  File? imageFile;
  late Future<List<LoaiMonAn>> listCates;
  ManagerController controller = ManagerController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameEditingController = TextEditingController();
  final _priceEditingController = TextEditingController();
  final _discountEditingController = TextEditingController();
  final _unitEditingController = TextEditingController();
  String _type = 'Hấp';
  String _name = '';
  int _price = 0;
  String _unit = '';
  String _fid = '';
  int _discount = 0;
  @override
  void initState() {
    _type = 'Hấp';
    super.initState();
    listCates = controller.getListCates();
    food = widget.food;
    if (food != null) {
      _fid = food!.id;
      _name = food?.get('name');
      _price = food?.get('price');
      _unit = food?.get('unit');
      _discount = food?.get('discount');
      imageUrl = food?.get('image');
      _nameEditingController.text = _name;
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
              padding: const EdgeInsets.only(
                  right: 10, bottom: 20, left: 10, top: 10),
              child: Column(
                children: [
                  const Text(
                    'THÊM MÓN ĂN',
                    style: TextStyle(
                        color: kSuccessColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  StreamBuilder(
                      stream: _foodBloc.nameStream,
                      builder: (context, snapshot) {
                        return TextField(
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          controller: _nameEditingController,
                          decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: 'Tên món ăn',
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  StreamBuilder(
                      stream: _foodBloc.priceStream,
                      builder: (context, snapshot) {
                        return TextField(
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          controller: _priceEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: 'Giá tiền',
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  StreamBuilder(
                      stream: _foodBloc.discountStream,
                      builder: (context, snapshot) {
                        return TextField(
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          controller: _discountEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: 'Giá sau giảm',
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  StreamBuilder(
                      stream: _foodBloc.unitStream,
                      builder: (context, snapshot) {
                        return TextField(
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          controller: _unitEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: 'Đơn vị tính:',
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(11, 0, 11, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Loại món ăn:',
                          style: TextStyle(color: Colors.white),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("LoaiMonAn")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kPrimaryColor),
                                  ),
                                );
                              } else {
                                List<String> list = [];
                                snapshot.data!.docs.forEach(
                                    (element) => list.add(element.get('name')));
                                return DropdownButton(
                                  style: const TextStyle(color: Colors.white),
                                  dropdownColor: kSecondaryColor,
                                  value: _type,
                                  onChanged: (value) =>
                                      setState(() => _type = value.toString()),
                                  items: list
                                      .map((cate) => DropdownMenuItem<String>(
                                            child: Text(cate),
                                            value: cate,
                                          ))
                                      .toList(),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(11, 0, 11, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Hình ảnh: ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          imageName,
                          style: const TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          onPressed: getImage,
                          icon: const FaIcon(
                            FontAwesomeIcons.image,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: kSupColor,
            padding: const EdgeInsets.only(bottom: 10),
            child: MaterialButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              padding: const EdgeInsets.all(10),
              height: 50,
              color: kPrimaryColor,
              minWidth: double.infinity,
              onPressed: () => addFood(),
              child: const Text(
                'Thêm mới',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ));
    } else {
      _unitEditingController.text = _unit.toString();
      _priceEditingController.text = _price.toString();
      _discountEditingController.text = _discount.toString();
      return Scaffold(
          appBar: AppBar(
            backgroundColor: kAppBarColor,
            title: const Text('Quản lý thực đơn'),
          ),
          key: _scaffoldKey,
          body: SafeArea(
            child: Container(
              color: kSupColor,
              padding: const EdgeInsets.only(
                  right: 10, bottom: 20, left: 10, top: 10),
              child: Column(
                children: [
                  const Text(
                    'CHỈNH SỬA MÓN ĂN',
                    style: TextStyle(
                        color: kSuccessColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  TextField(
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _nameEditingController,
                    onChanged: (text) {
                      setState(() {
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
                      labelText: 'Giá sau giảm',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(11, 0, 11, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Loại món ăn:',
                          style: TextStyle(color: Colors.white),
                        ),
                        FutureBuilder<List<LoaiMonAn>>(
                            future: listCates,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DropdownButton(
                                  value: _type,
                                  onChanged: (value) =>
                                      setState(() => _type = value.toString()),
                                  items: snapshot.data!
                                      .map((cate) => DropdownMenuItem<String>(
                                            child: Text(cate.name),
                                            value: cate.name,
                                          ))
                                      .toList(),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  TextField(
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _unitEditingController,
                    onChanged: (unit) => setState(() {
                      _unit = unit
                          .toString(); //when state changed => build() rerun => reload widget
                    }),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Đơn vị tính:',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: kSupColor,
            padding: const EdgeInsets.only(bottom: 10),
            child: MaterialButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              padding: const EdgeInsets.all(10),
              height: 50,
              color: kSuccessColor,
              minWidth: double.infinity,
              onPressed: () {
                MonAn monAn = MonAn(
                    _fid, _name, imageUrl, _price, _unit, _discount, _type);
                controller.updateFood(monAn);
              },
              child: const Text(
                'Cập nhật',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ));
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;
    var status = await Permission.storage.status;
    if (status.isGranted) {
      // ignore: deprecated_member_use
      pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        setState(() {
          imageName = fileName;
        });
      }
    } else {
      await Permission.storage.request();
    }
  }

  addFood() {
    String discount = _discountEditingController.text.trim();
    String name = _nameEditingController.text.trim();
    String price = _priceEditingController.text.trim();
    String unit = _unitEditingController.text.trim();
    var isValid = _foodBloc.isAddOrEditFoodValid(discount, name, price, unit);
    if (isValid) {
      if (imageName == "") {
        Fluttertoast.showToast(msg: "Chọn hình ảnh cho món ăn");
        return;
      }
      MonAn monAn = MonAn(
          "", name, "", int.parse(price), unit, int.parse(discount), _type);
      controller.addFood(monAn, imageFile, imageName);
      Navigator.pop(context);
    }
  }
}
