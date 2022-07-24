import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:star_restaurant/Components/flash_message.dart';
import 'package:star_restaurant/Controller/WaiterController.dart';
import 'package:star_restaurant/Model/BanAn.dart';
import 'package:star_restaurant/Screen/Waiter/OrderFoodActivity.dart';

import '../../../Util/Constants.dart';

buildMenuButton(DocumentSnapshot? tableFood, BuildContext context,
    WaiterController waiterController) {
  bool isUsingTable = tableFood!.get('idUser') == "" ? false : true;
  return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("BanDangSuDung")
          .doc(tableFood.id)
          .snapshots(),
      builder: (context, snapshot) {
        bool isMerging = false;
        bool isPaying = false;
        if (snapshot.hasData) {
          isPaying = snapshot.data!.get("isPaying");
          isMerging = snapshot.data!.get("isMerging");
        }
        if (isPaying) {
          isUsingTable = false;
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
              onTap: () =>
                  _changeToNewTable(context, tableFood, waiterController),
            ),
            SpeedDialChild(
              child: const FaIcon(FontAwesomeIcons.arrowsLeftRightToLine),
              label: "Ghép bàn",
              // onTap: () async {
              //   Map<int, Map<BanAn, bool>> listBanAn;
              //   listBanAn = await getData(tableFood);
              //   mergeTables(context, listBanAn);
              // },
            ),
            SpeedDialChild(
              visible: isMerging,
              child: const FaIcon(FontAwesomeIcons.info),
              label: "Thông tin ghép bàn",
              // onTap: () => _showTableMergedInfo(context, tableFood)
            ),
          ],
        );
      });
}

Future<dynamic> mergeTables(
    BuildContext context, Map<int, Map<BanAn, bool>> listBanAn) {
  return showDialog(
      context: context,
      builder: (tableInfoDialog) => AlertDialog(
              backgroundColor: kSupColor,
              title: const Center(
                child: Text(
                  'Chọn các bàn cần ghép:',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("BanAn")
                        .where('isMerging', isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        );
                      } else {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setInnerState) {
                          return ListView.builder(
                              itemCount: listBanAn.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setInnerState(() {
                                      bool select = false;
                                      listBanAn[index]!.forEach((key, value) {
                                        select = !value;
                                        listBanAn[index]![key] = select;
                                      });
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        kDefaultPadding / 2),
                                    child: Container(
                                      color: listBanAn[index]!
                                              .values
                                              .contains(true)
                                          ? kPrimaryColor
                                          : null,
                                      child: Text(
                                        listBanAn[index]!.keys.toString(),
                                        textScaleFactor: 1.5,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        });
                      }
                    }),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    WaiterController waiterController = WaiterController();
                    waiterController.mergeTables(listBanAn, () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: FlashMessageScreen(
                              type: "Thông báo",
                              content: "Ghép thành công!",
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
                              type: "Thông báo",
                              content: msg,
                              color: Colors.green),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      );
                    });
                    Navigator.pop(tableInfoDialog);
                  },
                  child: const Text(
                    'Ghép bàn',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(tableInfoDialog, 'Hủy'),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ]));
}

Future<Map<int, Map<BanAn, bool>>> getData(DocumentSnapshot? tableFood) async {
  Map<int, Map<BanAn, bool>> list = Map<int, Map<BanAn, bool>>();
  List<dynamic> listTable = [];
  if (tableFood!.get("isMerging")) {
    int index = 0;
    await FirebaseFirestore.instance
        .collection("BanDangGhep")
        .where(tableFood.get('name'), isEqualTo: tableFood.id)
        .get()
        .then((value) => value.docs.forEach((element) {
              listTable = element.data().values.toList();
            }));
    await FirebaseFirestore.instance
        .collection("BanAn")
        .get()
        .then((banan) => banan.docs.forEach((element) {
              BanAn banAn = BanAn.fromDocument(element);
              if (listTable.contains(banAn.id)) {
                list.addAll({
                  index++: {banAn: true}
                });
              } else {
                if (banAn.isMerging) {
                  if (banAn.isUsing) {
                    if (banAn.idUser ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      list.addAll({
                        index++: {banAn: true}
                      });
                    }
                  }
                } else {
                  list.addAll({
                    index++: {banAn: false}
                  });
                }
              }
            }));
  } else {
    int index = 0;
    await FirebaseFirestore.instance
        .collection("BanAn")
        .get()
        .then((banan) => banan.docs.forEach((element) {
              BanAn banAn = BanAn.fromDocument(element);
              if (banAn.id == tableFood.id) {
                list.addAll({
                  index++: {banAn: true}
                });
              } else if (banAn.isMerging) {
                if (banAn.isUsing) {
                  if (banAn.idUser == FirebaseAuth.instance.currentUser!.uid) {
                    list.addAll({
                      index++: {banAn: true}
                    });
                  }
                } else {
                  list.addAll({
                    index++: {banAn: false}
                  });
                }
              } else {
                list.addAll({
                  index++: {banAn: false}
                });
              }
            }));
  }

  return list;
}

Future<dynamic> _showTableMergedInfo(
    BuildContext context, DocumentSnapshot tableFood) async {
  String tablenames = await getTableNames(tableFood.id);
  return showDialog(
      context: context,
      builder: (tableInfoDialog) => AlertDialog(
              backgroundColor: kSupColor,
              title: const Text(
                'Các bàn đang ghép:',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                tablenames,
                style: const TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(tableInfoDialog, 'Hủy'),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ]));
}

Future<String> getTableNames(String idTable) async {
  StringBuffer names = StringBuffer();
  List<dynamic> listTableNames = [];
  await FirebaseFirestore.instance
      .collection("BanDangGhep")
      .get()
      .then((tables) {
    tables.docs.forEach((table) {
      if (table.data().values.contains(idTable)) {
        listTableNames = table.data().keys.toList();
      }
    });
  });
  listTableNames.forEach((element) async {
    String name = "";
    names.write(element);
    names.write("  ");
  });

  return names.toString();
}

Future<dynamic> _changeToNewTable(BuildContext context,
    DocumentSnapshot<Object?> tableFood, WaiterController waiterController) {
  print(tableFood.id);
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
                  .collection("BanDangSuDung")
                  .where('idUser', isEqualTo: "")
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
                        return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('BanAn')
                                .doc(snapshot.data?.docs[index].id)
                                .snapshots(),
                            builder: (context, banan) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kPrimaryColor),
                                  ),
                                );
                              } else {
                                String name = "";
                                // if (banan.data!.get('id') == tableFood.id) {
                                //   name = banan.data!.get('name');
                                // }
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (confirmDialogContext) =>
                                          AlertDialog(
                                        elevation: 24,
                                        backgroundColor: kSupColor,
                                        title: const Center(
                                          child: Text(
                                            "Bạn có chắc chuyển bàn",
                                            style:
                                                TextStyle(color: kPrimaryColor),
                                          ),
                                        ),
                                        content: SizedBox(
                                          height: 60,
                                          child: Column(children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Chuyển đến: ",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  banan.data!.get('name'),
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
                                              style: TextStyle(
                                                  color: kPrimaryColor),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  listAvailableTableDialog);
                                              waiterController.changeToNewTable(
                                                  tableFood.id,
                                                  banan.data!.get('id'), () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: FlashMessageScreen(
                                                        type: "Thông báo",
                                                        content:
                                                            "Chuyển bàn thành công!",
                                                        color: Colors.green),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                  ),
                                                );
                                                Navigator.pop(
                                                    confirmDialogContext);
                                              }, (msg) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: FlashMessageScreen(
                                                        type: "Thông báo",
                                                        content: msg,
                                                        color: kPrimaryColor),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                  ),
                                                );
                                                Navigator.pop(
                                                    confirmDialogContext);
                                              });
                                            },
                                            child: const Text(
                                              'Có',
                                              style: TextStyle(
                                                  color: kPrimaryColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Container(
                                      color: kSecondaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          banan.data!.get('name'),
                                          textScaleFactor: 2,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            });
                      });
                }
              }),
        ),
      ),
    ),
  );
}
