import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:star_restaurant/Components/flash_message.dart';
import 'package:star_restaurant/Controller/WaiterController.dart';
import 'package:star_restaurant/Screen/Waiter/Components/TableFood.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:star_restaurant/Screen/Waiter/OrderFoodActivity.dart';

import '../../../Util/Constants.dart';

class OrderFoodConfirm extends StatefulWidget {
  final DocumentSnapshot? tableFood;
  const OrderFoodConfirm({Key? key, required this.tableFood}) : super(key: key);

  @override
  State<OrderFoodConfirm> createState() => _OrderFoodConfirmState();
}

class _OrderFoodConfirmState extends State<OrderFoodConfirm> {
  DocumentSnapshot? _tableFood;

  @override
  void initState() {
    super.initState();
    _tableFood = widget.tableFood;
  }

  @override
  Widget build(BuildContext context) {
    var _idT = _tableFood!.get('id');
    return Scaffold(
      body: Material(
        child: Expanded(
          child: Container(
            color: kSupColor,
            child: Column(children: [
              _headerPage(_idT),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("MonAnTamGoi/$_idT/MonAnChoXacNhan")
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
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Món ăn',
                                textScaleFactor: 1.5,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'SL',
                                textScaleFactor: 1.5,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Giá',
                                textScaleFactor: 1.5,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Tổng',
                                textScaleFactor: 1.5,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                              snapshot.data!.size,
                              (index) => DataRow(cells: <DataCell>[
                                    DataCell(Text(
                                      snapshot.data!.docs[index].get('name'),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                    DataCell(Text(
                                      snapshot.data!.docs[index]
                                          .get('amount')
                                          .toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                    DataCell(Text(
                                      snapshot.data!.docs[index]
                                          .get('price')
                                          .toString()
                                          .toVND(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                    DataCell(Text(
                                      _getTotal(
                                          snapshot.data!.docs[index]
                                              .get('amount'),
                                          snapshot.data!.docs[index]
                                              .get('price')),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                  ])),
                        ),
                      );
                    }
                  }),
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () => Get.to(OrderFoodActivity(tableFood: widget.tableFood)),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _headerPage(String idT) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Text(
            _tableFood!.get('name'),
            textScaleFactor: 2,
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 10),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: kPrimaryColor, width: 2),
              ),
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Xác nhận gọi món'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Hủy'),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              WaiterController waiterController =
                                  WaiterController();
                              waiterController.confirmOrders(idT, () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: FlashMessageScreen(
                                        type: "Thông báo",
                                        content: "Xác nhận thành công?",
                                        color: Colors.green),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ),
                                );
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
                            child: const Text('OK'),
                          ),
                        ],
                      )),
              child: const Text(
                "Xác nhận",
                textScaleFactor: 2,
                style: TextStyle(color: kPrimaryColor),
              )),
        )
      ],
    );
  }

  String _getTotal(amount, price) {
    int total = amount * price;
    return total.toString().toVND();
  }
}
