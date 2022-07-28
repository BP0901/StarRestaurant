import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:star_restaurant/Components/flash_message.dart';
import 'package:star_restaurant/Controller/WaiterController.dart';
import 'package:star_restaurant/Screen/Waiter/TableInfomationActivity.dart';
import 'package:star_restaurant/Util/Constants.dart';

class TableFood extends StatefulWidget {
  const TableFood({Key? key}) : super(key: key);

  @override
  State<TableFood> createState() => _TableFoodState();
}

class _TableFoodState extends State<TableFood> {
  WaiterController waiterController = WaiterController();
  final Stream<QuerySnapshot> _tableStream =
      FirebaseFirestore.instance.collection('BanDangSuDung').snapshots();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: kSupColor,
        child: StreamBuilder<QuerySnapshot>(
            stream: _tableStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  itemBuilder: (context, index) =>
                      _buildTableRow(index, snapshot.data?.docs[index]),
                );
              }
            }),
      ),
    );
  }

  Widget _buildTableRow(int index, DocumentSnapshot? document) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("BanAn")
            .doc(document!.id)
            .snapshots(),
        builder: (context, banan) {
          if (!banan.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                waiterController.showTableInfo(document, () {
                  Get.to(TableInfomationActivity(tableFood: document));
                }, (msg) {
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
              child: document.get('idUser') != ""
                  ? _navailableTableRow(document, banan.data!.get('name'))
                  : _availableTableRow(document, banan.data!.get('name')),
            );
          }
        });
  }

  Padding _availableTableRow(DocumentSnapshot? document, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(color: kSecondaryColor),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                textScaleFactor: 1.5,
                style: const TextStyle(color: Colors.white),
              ),
              const Text(
                "(Trống)",
                textScaleFactor: 1.5,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _navailableTableRow(DocumentSnapshot? document, String name) {
    Color rowColor =
        document!.get('idUser') == FirebaseAuth.instance.currentUser!.uid
            ? Colors.green
            : kPrimaryColor;
    String isMerging = document.get('isMerging');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: rowColor),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                textScaleFactor: 1.5,
                style: const TextStyle(color: Colors.white),
              ),
              isMerging.isEmpty
                  ? const Text(
                      "",
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.white),
                    )
                  : const Text(
                      "Đang ghép",
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.white),
                    ),
              const Text(
                "(Có người)",
                textScaleFactor: 1.5,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
