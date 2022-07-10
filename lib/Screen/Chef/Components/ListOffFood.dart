
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Util/Constants.dart';

class ListOffFood extends StatefulWidget {
  @override
  State<ListOffFood> createState() => _ListOffFood();
}

class _ListOffFood extends State<ListOffFood>{
  final Stream<QuerySnapshot> _banAnCateStream =
  FirebaseFirestore.instance.collection('BanAn').snapshots();
  final Stream<QuerySnapshot> _monAnDXNCateStream =
  FirebaseFirestore.instance.collection('MonAnDaXacNhan').snapshots();
  @override
  int _cateIndex = 0;
  List<String> lists=[];
  chooseCategory(chooseIndex) {
    _cateIndex = chooseIndex;
  }
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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
                // return Text('${lists.length},$name');
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) => buildCateItem(
                      index, snapshot.data?.docs[index]),
                );
              }
            }),
      ),
    );
  }

  buildCateItem(int index, QueryDocumentSnapshot<Object?>? document) {
    if (document != null) {
      return Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Container(
          decoration: BoxDecoration(
              color: kSecondaryColor, borderRadius: BorderRadius.circular(15)),
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: kDefaultPadding / 2),
                    child: Container(
                      decoration: const BoxDecoration(color: kSecondaryColor),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                document.id,
                                textScaleFactor: 1.5,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}