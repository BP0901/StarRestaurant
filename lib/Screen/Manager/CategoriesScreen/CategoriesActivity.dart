import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Util/Constants.dart';
import '../components/DrawerMGTM.dart';

class CategoriesActivity extends StatefulWidget {
  const CategoriesActivity({Key? key}) : super(key: key);

  @override
  State<CategoriesActivity> createState() => _CategoriesActivityState();
}

class _CategoriesActivityState extends State<CategoriesActivity> {
  final _cateStream =
      FirebaseFirestore.instance.collection("LoaiMonAn").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: const Text('Quản lý loại món ăn'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
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
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
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
                            ));
                  }
                }),
          )),
    );
  }
}
