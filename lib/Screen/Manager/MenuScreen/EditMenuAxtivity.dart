import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star_restaurant/Model/MonAn.dart';
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
  bool isLoading = false;
  String imageName = "";
  String imageUrl = "";
  DocumentSnapshot? food;
  File? imageFile;
  ManagerController controller = ManagerController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameEditingController = TextEditingController();
  final _priceEditingController = TextEditingController();
  final _discountEditingController = TextEditingController();
  String _type = 'hap';
  String _name = '';
  int _price = 0;
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
        style: const TextStyle(color: Colors.blue),
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
        style: const TextStyle(color: Colors.blue),
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
      imageUrl = food?.get('image');
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
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),
                )
              : SafeArea(
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
                            labelText: 'Discount',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 10)),
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
                        const Padding(padding: EdgeInsets.only(bottom: 10)),
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
                        Row(
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
              onPressed: () {
                MonAn monAn =
                    MonAn("", _name, imageUrl, _price, _unit, _discount, _type);
                controller.addFood(monAn, () {
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
              child: const Text(
                'Thêm mới',
                style: TextStyle(color: Colors.white),
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
                      labelText: 'Discount',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
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
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
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
                controller.updateFood(
                    _fid, _name, imageUrl, _price, _discount, _type, _unit, () {
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

        if (imageFile != null) {
          setState(() {
            isLoading = true;
          });
          uploadFile();
        }
      }
    } else {
      await Permission.storage.request();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile!);

    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }
}
