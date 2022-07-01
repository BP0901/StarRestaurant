import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:star_restaurant/Components/flash_message.dart';
import 'package:star_restaurant/Controller/WaiterController.dart';
import 'package:star_restaurant/Screen/Waiter/OrderFoodActivity.dart';

import '../../../Util/Constants.dart';

buildMenuButton(DocumentSnapshot? tableFood, BuildContext context,
    WaiterController waiterController) {
  bool isUsingTable = tableFood!.get('isUsing');
  return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("BanAn")
          .doc(tableFood.id)
          .snapshots(),
      builder: (context, snapshot) {
        bool isPaying = false;
        if (snapshot.hasData) {
          isPaying = snapshot.data!.get("isPaying");
        }
        return SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: kPrimaryColor,
          overlayColor: Colors.black,
          overlayOpacity: .4,
          children: [
            SpeedDialChild(
              visible: !isPaying,
              child: const FaIcon(FontAwesomeIcons.plus),
              label: "Thêm món",
              onTap: () => Get.to(OrderFoodActivity(tableFood: tableFood)),
            ),
            SpeedDialChild(
              visible: isUsingTable,
              child: const FaIcon(FontAwesomeIcons.arrowRightArrowLeft),
              label: "Chuyển bàn",
              onTap: () {
                _changeToNewTable(context, tableFood, waiterController);
              },
            ),
            SpeedDialChild(
              child: const FaIcon(FontAwesomeIcons.arrowsLeftRightToLine),
              label: "Ghép bàn",
            ),
          ],
        );
      });
}

Future<dynamic> _changeToNewTable(BuildContext context,
    DocumentSnapshot<Object?> tableFood, WaiterController waiterController) {
  return showDialog(
    context: context,
    builder: (listAvailableTableDialog) => AlertDialog(
      elevation: 24,
      backgroundColor: kSupColor,
      title: const Center(
        child: Text(
          "Chọn bàn muốn chuyển đến",
          style: TextStyle(color: kPrimaryColor),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("BanAn")
                  .where('isUsing', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    ),
                  );
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (confirmDialogContext) => AlertDialog(
                                elevation: 24,
                                backgroundColor: kSupColor,
                                title: const Center(
                                  child: Text(
                                    "Bạn có chắc chuyển bàn",
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                ),
                                content: SizedBox(
                                  height: 60,
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Từ: ",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          tableFood.get('name'),
                                          textScaleFactor: 1.5,
                                          style: const TextStyle(
                                              color: kPrimaryColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Đến: ",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          snapshot.data?.docs[index]
                                              .get('name'),
                                          textScaleFactor: 1.5,
                                          style: const TextStyle(
                                              color: kPrimaryColor),
                                        ),
                                      ],
                                    )
                                  ]),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                        confirmDialogContext, 'Hủy'),
                                    child: const Text(
                                      'Hủy',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(listAvailableTableDialog);
                                      waiterController.changeToNewTable(
                                          tableFood.get('id'),
                                          snapshot.data?.docs[index].get('id'),
                                          () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: FlashMessageScreen(
                                                type: "Thông báo",
                                                content:
                                                    "Chuyển bàn thành công!",
                                                color: Colors.green),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                          ),
                                        );
                                        Navigator.pop(confirmDialogContext);
                                      }, (msg) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                                        Navigator.pop(confirmDialogContext);
                                      });
                                    },
                                    child: const Text(
                                      'Có',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Container(
                              color: kSecondaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data?.docs[index].get('name'),
                                  textScaleFactor: 2,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
              }),
        ),
      ),
    ),
  );
}
