import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star_restaurant/Controller/ChefController.dart';
import 'package:star_restaurant/Util/Constants.dart';
import 'package:star_restaurant/Components/flash_message.dart';

class ListOffFood extends StatefulWidget {
  @override
  State<ListOffFood> createState() => _ListOffFood();
}

class _ListOffFood extends State<ListOffFood> {
  final Stream<QuerySnapshot> _monAnDXNCateStream = FirebaseFirestore.instance
      .collection('MonAnDaXacNhan')
      .where("status", isEqualTo: 'cooking')
      .snapshots();
  final _banAnCollection = FirebaseFirestore.instance.collection('BanAn');
  ChefController controller = ChefController();
  String _table='';
  @override
  int _cateIndex = 0;
  List<String> lists = [];
  chooseCategory(chooseIndex) {
    _cateIndex = chooseIndex;
  }

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
            } else  {
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

  buildCateItem(int index, QueryDocumentSnapshot<Object?>? document){
    if (document != null) {
      _viewTable(document.get('idTable'));
      return Column(
        children: [
          Card(
            color: kWarninngColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.green.shade300,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () => _cookingSuccess(document),
              focusColor: kErrorColor,
              leading: CircleAvatar(
                child: Text('${document.get('amount')}'),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${document.get('name')}',
                    textScaleFactor: 1.25,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    '${_table}',
                    textScaleFactor: 0.8,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              trailing: Icon(
                Icons.update,
                color: Colors.red,
              ),
            ),
          ),
          const Divider(),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  _viewTable(String id) async {
    _table = await _banAnCollection
        .doc(id)
        .get()
        .then<String>((value) => value.get('name'));
    print(_table);
    // print(await _banAnCollection.doc(id).get().then<String>((value) => value.get('name')));
    return await _table;
  }

  _cookingSuccess(QueryDocumentSnapshot<Object?> document) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              elevation: 24,
              backgroundColor: kSupColor,
              title: Center(
                child: Text(
                  'Xác nhận hoàn thành ${document.get('name')}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              content: Container(
                height: 120,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: kPrimaryColor),
                          onPressed: () {
                            controller.successCooking(document.id, () {
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
                              Navigator.pop(context);
                            });
                          },
                          child: const Text("Hoàn thành")),
                    ),
                  ],
                ),
              ),
            ));
  }
}
