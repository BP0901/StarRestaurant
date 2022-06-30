import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_restaurant/Components/flash_message.dart';
import 'package:star_restaurant/Controller/WaiterController.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:star_restaurant/Screen/Waiter/Components/MenuBottonInTable.dart';

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
    WaiterController waiterController = WaiterController();
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
                              (index) => DataRow(
                                      onLongPress: () {
                                        _changeOrDelFood(context, snapshot,
                                            index, waiterController);
                                      },
                                      cells: <DataCell>[
                                        DataCell(
                                            Text(
                                              snapshot.data!.docs[index]
                                                  .get('name'),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ), onTap: () {
                                          _showFoodDetail(
                                              context, snapshot, index);
                                        }),
                                        DataCell(Text(
                                          snapshot.data!.docs[index]
                                              .get('amount')
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                        DataCell(Text(
                                          snapshot.data!.docs[index]
                                              .get('price')
                                              .toString()
                                              .toVND(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                        DataCell(Text(
                                          _getTotal(
                                              snapshot.data!.docs[index]
                                                  .get('amount'),
                                              snapshot.data!.docs[index]
                                                  .get('price')),
                                          style: const TextStyle(
                                              color: Colors.white),
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
      floatingActionButton:
          buildMenuButton(widget.tableFood, context, waiterController),
    );
  }

  Future<dynamic> _showFoodDetail(BuildContext context,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              elevation: 24,
              backgroundColor: kSupColor,
              title: Center(
                child: Text(
                  snapshot.data!.docs[index].get('name'),
                  style: const TextStyle(color: kPrimaryColor),
                ),
              ),
              content: SizedBox(
                height: 120,
                child: Column(children: [
                  Row(
                    children: [
                      const Text(
                        "Số lượng: ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        snapshot.data!.docs[index].get('amount').toString(),
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Giá: ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        snapshot.data!.docs[index].get('price').toString(),
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Trạng thái: ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        snapshot.data!.docs[index].get('status'),
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  ),
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
                          snapshot.data!.docs[index].get('note'),
                          style: const TextStyle(color: kPrimaryColor),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ));
  }

  Future<dynamic> _changeOrDelFood(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot>? snapshot,
      int index,
      WaiterController waiterController) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              elevation: 24,
              backgroundColor: kSupColor,
              title: Center(
                child: Text(
                  snapshot!.data!.docs[index].get('name'),
                  style: const TextStyle(color: kPrimaryColor),
                ),
              ),
              content: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                        onPressed: () {
                          int _amount =
                              snapshot.data!.docs[index].get('amount');
                          Navigator.pop(context);
                          _updateFoodAmount(context, snapshot, index, _amount,
                              waiterController);
                        },
                        child: const Text("Thây đổi số lượng")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                          _delConfirmFood(
                              context, waiterController, snapshot, index);
                        },
                        child: const Text("Xóa món ăn"))
                  ],
                ),
              ),
            ));
  }

  Future<dynamic> _updateFoodAmount(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      int index,
      int _amount,
      WaiterController waiterController) {
    return showModalBottomSheet(
        elevation: 10,
        backgroundColor: kSupColor,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => SizedBox(
                height: 170,
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Món: ",
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            snapshot.data!.docs[index].get('name'),
                            textScaleFactor: 1.5,
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Số lượng: ",
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_amount != 1) {
                                    _amount -= 1;
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_left_sharp,
                                color: Colors.white,
                              )),
                          Text(
                            "$_amount",
                            textScaleFactor: 1.5,
                            style: const TextStyle(color: Colors.white),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _amount += 1;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_right_sharp,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                            ),
                            onPressed: () {
                              waiterController.updateConfirmFood(
                                  snapshot.data!.docs[index],
                                  widget.tableFood!.id,
                                  _amount, () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: FlashMessageScreen(
                                        type: "Thông báo",
                                        content: "Cập nhật thành công!",
                                        color: Colors.green),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ),
                                );
                              }, (msg) {
                                Navigator.pop(context);
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
                            child: const Text(
                              "Cập nhật",
                              textScaleFactor: 1.5,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Future<dynamic> _delConfirmFood(
      BuildContext context,
      WaiterController waiterController,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      int index) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: kSupColor,
              content: const Text("Bạn có chắc muốn xóa!",
                  style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Không",
                      style: TextStyle(color: kPrimaryColor),
                    )),
                TextButton(
                    onPressed: () {
                      waiterController.deleteConfirmFoodinTable(
                          snapshot.data!.docs[index],
                          widget.tableFood!.get('id'), () {
                        Navigator.pop(context);
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
                    child: const Text(
                      "Có",
                      style: TextStyle(color: kPrimaryColor),
                    ))
              ],
            ));
  }

  Widget _headerPage(String idT) {
    bool hasData = false;
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
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("MonAnTamGoi/$idT/MonAnChoXacNhan")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),
                );
              } else {
                hasData = snapshot.data!.size == 0 ? false : true;
                return Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: hasData ? Colors.green : kPrimaryColor,
                            width: 2),
                      ),
                      onPressed: hasData
                          ? () => showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    backgroundColor: kSupColor,
                                    content: const Text(
                                      'Xác nhận gọi món',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Hủy'),
                                        child: const Text(
                                          'Hủy',
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          WaiterController waiterController =
                                              WaiterController();
                                          waiterController.confirmOrders(idT,
                                              () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: FlashMessageScreen(
                                                    type: "Thông báo",
                                                    content:
                                                        "Xác nhận thành công!",
                                                    color: Colors.green),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          }, (msg) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: FlashMessageScreen(
                                                    type: "Thông báo",
                                                    content: msg,
                                                    color: kPrimaryColor),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text(
                                          'Có',
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                        ),
                                      ),
                                    ],
                                  ))
                          : null,
                      child: Text(
                        "Xác nhận",
                        textScaleFactor: 2,
                        style: TextStyle(
                            color: hasData ? Colors.green : kPrimaryColor),
                      )),
                );
              }
            }),
      ],
    );
  }

  String _getTotal(amount, price) {
    int total = amount * price;
    return total.toString().toVND();
  }
}
