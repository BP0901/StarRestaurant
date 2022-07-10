import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star_restaurant/Model/MonAnDaGoi.dart';

import '../../../Util/Constants.dart';

class ListNewFood extends StatefulWidget {
  const ListNewFood({Key? key}) : super(key: key);
  @override
  State<ListNewFood> createState() => _ListNewFood();
}

class _ListNewFood extends State<ListNewFood> {
  final Stream<QuerySnapshot> _monAnDXNCateStream = FirebaseFirestore.instance
      .collection('MonAnDaXacNhan')
      .where("status", isEqualTo: "new")
      .snapshots();
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
      return ListTile(
        hoverColor: kPrimaryColor,
        leading: CircleAvatar(
          child: Text('$index'),
        ),
        title: Text(
          '${document.get('name')}',
          textScaleFactor: 1.25,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(
          Icons.new_label,
          color: kSuccessColor,
          size: 30,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
