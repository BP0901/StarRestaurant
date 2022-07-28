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

buildMenuButton(DocumentSnapshot? currentTableFood, BuildContext context,
    WaiterController waiterController) {
  bool isUsingTable = currentTableFood!.get('idUser') == "" ? false : true;
  return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("BanDangSuDung")
          .doc(currentTableFood.id)
          .snapshots(),
      builder: (context, snapshot) {
        bool isMerging = false;
        bool isPaying = false;
        if (snapshot.hasData) {
          isPaying = snapshot.data!.get("isPaying");
          if (snapshot.data!.get("isMerging") != "") {
            isMerging = true;
          }
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
              onTap: () =>
                  Get.to(OrderFoodActivity(tableFood: currentTableFood)),
            ),
            SpeedDialChild(
              visible: isUsingTable,
              child: const FaIcon(FontAwesomeIcons.arrowRightArrowLeft),
              label: "Chuyển bàn",
              onTap: () => _changeToNewTable(
                  context, currentTableFood, waiterController),
            ),
            SpeedDialChild(
              child: const FaIcon(FontAwesomeIcons.arrowsLeftRightToLine),
              label: "Ghép bàn",
              onTap: () async {
                mergeTables(context, currentTableFood);
              },
            ),
            SpeedDialChild(
              visible: isMerging,
              child: const FaIcon(FontAwesomeIcons.info),
              label: "Thông tin ghép bàn",
              // onTap: () => _showTableMergedInfo(context, currentTableFood)
            ),
          ],
        );
      });
}

Future<dynamic> mergeTables(
    BuildContext context, DocumentSnapshot? currentTableFood) async {
  Map<DocumentSnapshot?, bool> listAvailable = <DocumentSnapshot?, bool>{};
  listAvailable = await _getData(currentTableFood);
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
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setInnerState) {
                  return ListView.builder(
                      itemCount: listAvailable.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot? key =
                            listAvailable.keys.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            setInnerState(() {
                              if (key!.id != currentTableFood!.id) {
                                if (listAvailable[key] == true) {
                                  listAvailable[key] = false;
                                } else {
                                  listAvailable[key] = true;
                                }
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(kDefaultPadding / 2),
                            child: Container(
                              color: listAvailable[key] == true
                                  ? kPrimaryColor
                                  : null,
                              child: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('BanAn')
                                      .doc(key!.id)
                                      .snapshots(),
                                  builder: (context, banan) {
                                    if (!banan.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  kPrimaryColor),
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        banan.data!.get('name'),
                                        textScaleFactor: 1.5,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      );
                                    }
                                  }),
                            ),
                          ),
                        );
                      });
                }),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(tableInfoDialog, 'Hủy'),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    WaiterController waiterController = WaiterController();
                    waiterController
                        .mergeTables(currentTableFood, listAvailable, () {
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
              ]));
}

Future<Map<DocumentSnapshot?, bool>> _getData(
    DocumentSnapshot? currentTableFood) async {
  Map<DocumentSnapshot?, bool> list = <DocumentSnapshot?, bool>{};
  await FirebaseFirestore.instance
      .collection('BanDangSuDung')
      .get()
      .then((listbanan) => listbanan.docs.forEach((banan) {
            if (banan.id == currentTableFood!.id) {
              list.addAll({banan: true});
            } else if (banan.get('isMerging') == "") {
              list.addAll({banan: false});
            }
          }));
  return list;
}

Future<dynamic> _showTableMergedInfo(
    BuildContext context, DocumentSnapshot currentTableFood) async {
  String tablenames = await getTableNames(currentTableFood.id);
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

Future<dynamic> _changeToNewTable(
    BuildContext context,
    DocumentSnapshot<Object?> currentTableFood,
    WaiterController waiterController) {
  print(currentTableFood.id);
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
                                // if (banan.data!.get('id') == currentTableFood.id) {
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
                                                  currentTableFood.id,
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
