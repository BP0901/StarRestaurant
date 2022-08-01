import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star_restaurant/Util/Constants.dart';
import '../../../Components/flash_message.dart';
import '../components/DrawerMGTM.dart';
import '../../../Util/Constants.dart';
import '../../../Model/BanAn.dart';
import '../../../Controller/ManagerController.dart';

class TablePage extends StatefulWidget {
  const TablePage({Key? key}) : super(key: key);

  @override
  State<TablePage> createState() => _TablePage();
}

class _TablePage extends State<TablePage> {
  ManagerController controller = ManagerController();
  final _contentController = TextEditingController();
  final _amountController = TextEditingController();
  final Stream<QuerySnapshot> _tableCateStream =
      FirebaseFirestore.instance.collection('BanAn').snapshots();
  String _name = '';
  int _radioVal = 0;
  final double _slider2Val = 50.0;
  //define states
  BanAn _table = BanAn.origin();
  final List<BanAn> _tables = List<BanAn>.empty();

  void _insertTransaction() {
    //You must validate information first
    if (_table.name.isEmpty) {
      return;
    }
    _tables.add(_table);
    _table = BanAn.origin();
    _contentController.text = '';
    _amountController.text = '';
  }

  void _onButtonShowModalSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              height: 270,
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Name'),
                        controller: _contentController,
                      )),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 20),
                    child: StatefulBuilder(builder: (context, innerSetState) {
                      return Row(
                        children: [
                          const Text(
                            'Loại bàn: ',
                            style: TextStyle(color: Colors.black),
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: 0,
                                  groupValue: _radioVal,
                                  onChanged: (int? value) =>
                                      innerSetState(() => _radioVal = value!)),
                              const Text(
                                'Thường',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: 1,
                                  groupValue: _radioVal,
                                  onChanged: (int? value) =>
                                      innerSetState(() => _radioVal = value!)),
                              const Text(
                                'Vip',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                            child: SizedBox(
                          child: RaisedButton(
                              color: Colors.teal,
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              onPressed: () {
                                _name = _contentController.text.trim();
                                if (_name.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Nhập tên bàn ăn!");
                                  return;
                                }
                                controller.addTable(
                                    _name, _radioVal != 1 ? false : true);
                              }),
                          height: 50,
                        )),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Expanded(
                            child: SizedBox(
                          child: RaisedButton(
                            color: Colors.pinkAccent,
                            child: const Text(
                              'Cancel',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            onPressed: () {
                              print('Press cancel');
                              Navigator.of(context).pop();
                            },
                          ),
                          height: 50,
                        ))
                      ],
                    ),
                  ),
                  //ok button
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          title: const Text('Quản lý bàn ăn'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _onButtonShowModalSheet(),
            )
          ],
        ),
        drawer: const DrawerMGTM(),
        body: SafeArea(
          child: Material(
            child: Container(
              color: kSupColor,
              child: StreamBuilder<QuerySnapshot>(
                  stream: _tableCateStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(kPrimaryColor),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) =>
                            _listTableItem(index, snapshot.data?.docs[index]),
                      );
                    }
                  }),
            ),
          ),
        ));
  }

  Widget _listTableItem(int index, DocumentSnapshot? document) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: kSecondaryColor,
                  title: const Text(
                    'Xác nhận xóa',
                    style: TextStyle(
                      color: kPrimaryColor,
                    ),
                  ),
                  content: Text(
                    'Bạn có muốn xóa ${document?.get('name')}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.pop(context, 'Không'),
                        child: const Text(
                          'Không',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                    FlatButton(
                        onPressed: () => Navigator.pop(context, 'Có'),
                        child: const Text(
                          'Có',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ))
                  ],
                )).then((value) {
          if (value != null) {
            if (value == 'Có') {
              controller.deleteTable(document?.get('id'), () {
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
              });
            }
          }
        });
      },
      onTap: () => {
        // _onButtonShowModalSheet(_name,_username,_role,document)
      },
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: kSecondaryColor,
          elevation: 10,
          //this lesson will customize this ListItem, using Column and Row
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    '${document?.get('name')}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                ],
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                        'Loại bàn: ${document?.get('type') != false ? 'Vip' : 'Thường'}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white,
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                  )
                ],
              ))
            ],
          )),
    );
    // if (document != null) {
    //   if (document?.get('type') == true) {
    //     return _tableVip(document);
    //   } else {
    //     return _tableBasic(document);
    //   }
    // } else {
    //   return const SizedBox.shrink();
    // }
  }
}
