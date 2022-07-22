import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:star_restaurant/Components/flash_message.dart';
import 'package:star_restaurant/Controller/ManagerController.dart';
import 'package:star_restaurant/Screen/Manager/MenuScreen/EditMenuAxtivity.dart';
import 'package:star_restaurant/Util/Constants.dart';

Widget buildFoodItem(BuildContext context, int index,
    DocumentSnapshot? document, String? value) {
  if (value == null) {
    if (document != null) {
      return GestureDetector(
        onLongPress: () => _deleteFood(context, document),
        onTap: () => _infoFood(context, document),
        onDoubleTap: () => Get.to(EditMenu(food: document)),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            // color: (index) % 2 == 0 ? Colors.blueAccent : Colors.indigoAccent,
            color: kSecondaryColor,
            elevation: 10,
            //this lesson will customize this ListItem, using Column and Row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.network(
                      document.get('image'),
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${document.get('name')}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red[400]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Đơn vị: ${document.get('unit')}',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Price: ${document.get('price')}',
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white)),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                              )
                            ],
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );
    } else {
      return const SizedBox.shrink();
    }
  } else {
    if (document != null &&
        document.get('name').toString().toLowerCase().contains(value)) {
      return GestureDetector(
        onLongPress: () {
          _deleteFood(context, document);
        },
        onTap: () {
          _infoFood(context, document);
          // _infoStaff(context, document.id, _name, _role, _gender, _locker,
          //     formatBirth.format(_birth), _username, document);
        },
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            // color: (index) % 2 == 0 ? Colors.blueAccent : Colors.indigoAccent,
            color: kSecondaryColor,
            elevation: 10,
            //this lesson will customize this ListItem, using Column and Row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.network(
                      document.get('image'),
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${document.get('name')}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red[400]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Đơn vị: ${document.get('unit')}',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Price: ${document.get('price')}',
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white)),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                              )
                            ],
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

_infoFood(BuildContext context, DocumentSnapshot<Object?>? document) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            elevation: 24,
            backgroundColor: kSupColor,
            title: Center(
              child: Text(
                document!.get('name'),
                style: const TextStyle(color: kPrimaryColor),
              ),
            ),
            content: SizedBox(
              height: 120,
              child: Column(children: [
                Row(
                  children: [
                    const Text(
                      "ID: ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      document.get('id').toString(),
                      style: const TextStyle(color: kPrimaryColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Giá: ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      document.get('price').toString(),
                      style: const TextStyle(color: kPrimaryColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Loại: ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      document.get('type'),
                      style: const TextStyle(color: kPrimaryColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Đơn vị: ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      document.get('unit'),
                      style: const TextStyle(color: kPrimaryColor),
                    ),
                  ],
                ),
              ]),
            ),
          ));
}

void _deleteFood(BuildContext context, DocumentSnapshot? document) {
  ManagerController controller = ManagerController();
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: kSupColor,
            title: const Text(
              'Xác nhận xóa',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Bạn có muốn xóa ${document!.get('name')}',
              style: const TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: kPrimaryColor),
                  )),
              FlatButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: kPrimaryColor),
                  ))
            ],
          )).then((value) {
    if (value != null) {
      if (value == 'OK') {
        controller.deleteFood(document!.id, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: FlashMessageScreen(
                  type: "Thông báo",
                  content: "Xóa thành công!",
                  color: Colors.green),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
        }, (msg) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: FlashMessageScreen(
                  type: "Thông báo", content: msg, color: kPrimaryColor),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
          Navigator.pop(context);
        });
      } else {}
    }
  });
}
