import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star_restaurant/Controller/LoaiMonAnController.dart';
import 'package:star_restaurant/Model/LoaiMonAn.dart';

import '../../../Components/flash_message.dart';
import '../../../Util/Constants.dart';
import '../components/DrawerMGTM.dart';

class CategoriesActivity extends StatefulWidget {
  const CategoriesActivity({Key? key}) : super(key: key);

  @override
  State<CategoriesActivity> createState() => _CategoriesActivityState();
}

class _CategoriesActivityState extends State<CategoriesActivity> {
  final LoaiMonAnConroller _loaiMonAnConroller = LoaiMonAnConroller();
  final _cateStream =
      FirebaseFirestore.instance.collection("LoaiMonAn").snapshots();
  bool isLoading = false;
  File? imageFile;
  String imageUrl = "";
  String imageName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: const Text('Quản lý loại món ăn'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _onButtonShowModalSheet(LoaiMonAn.origin(), false),
          )
        ],
      ),
      drawer: const DrawerMGTM(),
      body: Material(
          color: kSupColor,
          child: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
                stream: _cateStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kPrimaryColor),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          LoaiMonAn loaiMonAn = LoaiMonAn.fromDocument(
                              snapshot.data!.docs[index]);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onLongPress: () => _delCategory(loaiMonAn),
                              onDoubleTap: () =>
                                  _onButtonShowModalSheet(loaiMonAn, true),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Image.network(
                                              snapshot.data!.docs[index]
                                                  .get('image'),
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]
                                                .get('name'),
                                            textScaleFactor: 1.5,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }),
          )),
    );
  }

  void _onButtonShowModalSheet(LoaiMonAn loaiMonAn, bool isEdit) {
    var _contentController = TextEditingController();
    bool isLoading = false;
    File? imageFile;
    String imageUrl = isEdit ? loaiMonAn.image : "";
    String imageName = "";
    _contentController.text = isEdit ? loaiMonAn.name : "";

    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
                  backgroundColor: kSupColor,
                  scrollable: true,
                  content: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        )
                      : SizedBox(
                          height: 150,
                          child: Column(children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Tên',
                                  labelStyle: TextStyle(color: Colors.white),
                                  focusColor: Colors.white,
                                ),
                                controller: _contentController,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Hình ảnh: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    imageName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        ImagePicker imagePicker = ImagePicker();
                                        PickedFile? pickedFile;
                                        var status =
                                            await Permission.storage.status;
                                        if (status.isGranted) {
                                          // ignore: deprecated_member_use
                                          pickedFile =
                                              await imagePicker.getImage(
                                                  source: ImageSource.gallery);
                                          if (pickedFile != null) {
                                            imageFile = File(pickedFile.path);

                                            if (imageFile != null) {
                                              setDialogState(() {
                                                isLoading = true;
                                              });
                                            }
                                          }
                                        } else {
                                          await Permission.storage.request();
                                        }
                                        String fileName = DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString();
                                        Reference reference = FirebaseStorage
                                            .instance
                                            .ref()
                                            .child(fileName);
                                        UploadTask uploadTask =
                                            reference.putFile(imageFile!);

                                        try {
                                          TaskSnapshot snapshot =
                                              await uploadTask;
                                          imageUrl = await snapshot.ref
                                              .getDownloadURL();
                                          setDialogState(() {
                                            imageName = fileName;
                                            isLoading = false;
                                          });
                                        } on FirebaseException catch (e) {
                                          setDialogState(() {
                                            isLoading = false;
                                          });
                                          Fluttertoast.showToast(
                                              msg: e.message ?? e.toString());
                                        }
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.image,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                          ]),
                        ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Hủy'),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                    TextButton(
                      onPressed: isEdit
                          ? () {
                              loaiMonAn.name = _contentController.text;
                              loaiMonAn.image = imageUrl;
                              _loaiMonAnConroller.updateLoaiMA(loaiMonAn);
                              Navigator.pop(context);
                            }
                          : () {
                              LoaiMonAn loaiMA = LoaiMonAn(
                                  id: "",
                                  name: _contentController.text,
                                  image: imageUrl);
                              _loaiMonAnConroller.addLoaiMonAn(loaiMA);
                              Navigator.pop(context);
                            },
                      child: Text(
                        isEdit ? "Cập nhật" : 'Thêm',
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ],
                )));
  }

  _delCategory(LoaiMonAn loaiMonAn) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: kSupColor,
              title: Text(
                "Bạn chắc muốn xóa ${loaiMonAn.name}",
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _loaiMonAnConroller.delCate(loaiMonAn);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Xóa',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ],
            ));
  }
}
