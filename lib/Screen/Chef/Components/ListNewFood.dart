import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_restaurant/Components/flash_message.dart';
import 'package:star_restaurant/Controller/ChefController.dart';

import '../../../Util/Constants.dart';

class ListNewFood extends StatefulWidget {
  const ListNewFood({Key? key}) : super(key: key);
  @override
  State<ListNewFood> createState() => _ListNewFood();
}

class _ListNewFood extends State<ListNewFood> {
  final Stream<QuerySnapshot> _monAnDXNCateStream = FirebaseFirestore.instance
      .collection('MonAnDaXacNhan')
      .where("status", isEqualTo: 'new')
      .snapshots();
  ChefController controller = ChefController();
  int _cateIndex = 0;
  List<String> lists = [];
  chooseCategory(chooseIndex) {
    _cateIndex = chooseIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kSupColor,
      child: StreamBuilder<QuerySnapshot>(
          stream: _monAnDXNCateStream,
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
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    return buildCateItem(index, snapshot.data?.docs[index]);
                  });
            }
          }),
    );
  }

  buildCateItem(int index, QueryDocumentSnapshot<Object?>? document) {
    if (document != null) {
      return Column(
        children: [
          Card(
            color: kSecondaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.green.shade300,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () => _cookingConfirmation(document),
              focusColor: kErrorColor,
              leading: CircleAvatar(
                child: Text('${document.get('amount')}'),
              ),
              title: Text(
                '${document.get('name')}',
                textScaleFactor: 1.25,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: _icons(document),
            ),
          ),
          const Divider(),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  _icons(QueryDocumentSnapshot<Object?> document) {
    if (document.get('note') != '') {
      return IconButton(
        icon: const Icon(Icons.speaker_notes, size: 30),
        onPressed: () => _infoNote(document),
        color: kWarninngColor,
      );
    }
  }

  _infoNote(QueryDocumentSnapshot<Object?> document) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              elevation: 24,
              backgroundColor: kSupColor,
              title: Center(
                child: Text(
                  document.get('name'),
                  style: const TextStyle(color: kPrimaryColor),
                ),
              ),
              content: SizedBox(
                height: 120,
                child: Column(children: [
                  Row(
                    children: const [
                      Text(
                        "Ghi chú: ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          document.get('note'),
                          style: const TextStyle(color: kWarninngColor),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ));
  }

  _cookingConfirmation(QueryDocumentSnapshot<Object?> document) {
    return showDialog(
        context: context,
        builder: (confirmDialog) => AlertDialog(
              elevation: 24,
              backgroundColor: kSupColor,
              title: Center(
                child: Text(
                  'Xác nhận nấu món ${document.get('name')}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              content: SizedBox(
                height: 120,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: kPrimaryColor),
                          onPressed: () {
                            controller.confirmCooking(document, () {}, (msg) {
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
                            Navigator.pop(confirmDialog);
                          },
                          child: const Text("Nấu ăn")),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5, right: 5)),
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: kPrimaryColor),
                            onPressed: () {
                              controller.cancelCooking(document, () {
                                Navigator.pop(context);
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
                            child: const Text("Không nấu")))
                  ],
                ),
              ),
            ));
  }
}
