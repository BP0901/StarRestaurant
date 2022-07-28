import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:star_restaurant/Components/flash_message.dart';
import 'package:star_restaurant/Controller/WaiterController.dart';
import 'package:star_restaurant/Model/MonAnDaGoi.dart';
import 'package:star_restaurant/Screen/Waiter/Components/MenuButtonInTable.dart';
import 'package:intl/intl.dart';

import '../../../Util/Constants.dart';

class FoodOrdered extends StatefulWidget {
  final DocumentSnapshot? tableFood;
  const FoodOrdered({Key? key, required this.tableFood}) : super(key: key);

  @override
  State<FoodOrdered> createState() => _FoodOrderedState();
}

class _FoodOrderedState extends State<FoodOrdered> {
  DocumentSnapshot? _tableFood;
  late Future<List<DocumentSnapshot<Map<String, dynamic>>>> listFoods;

  @override
  void initState() {
    _tableFood = widget.tableFood;
    listFoods = _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _idT = _tableFood!.id;
    WaiterController waiterController = WaiterController();
    return Scaffold(
      body: Material(
        child: Container(
          color: kSupColor,
          child: Column(children: [
            _headerPage(_tableFood),
            FutureBuilder<List<DocumentSnapshot>>(
                future: listFoods,
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
                        rows: _dataTable(context, waiterController, snapshot),
                      ),
                    );
                  }
                }),
          ]),
        ),
      ),
      floatingActionButton:
          buildMenuButton(widget.tableFood, context, waiterController),
    );
  }

  Future<dynamic> _showFoodDetail(
      BuildContext context, MonAnDaGoi monAn, int index) {
    DateTime orderTime = monAn.orderTime.toDate();
    String formattedDate = DateFormat('dd-MM-yyyy – kk:mm').format(orderTime);
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              elevation: 24,
              backgroundColor: kSupColor,
              title: Center(
                child: Text(
                  monAn.name,
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
                        monAn.amount.toString(),
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
                        monAn.price.toString().toVND(),
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Giờ: ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        formattedDate,
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
                        monAn.status,
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
                          monAn.note,
                          style: const TextStyle(color: kPrimaryColor),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ));
  }

  Widget _headerPage(DocumentSnapshot? tableFood) {
    String idT = tableFood!.id;
    bool hasData = false;
    return StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('BanAn').doc(idT).snapshots(),
        builder: (context, banan) {
          if (!banan.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    banan.data!.get('name'),
                    textScaleFactor: 2,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("MonAnDaXacNhan")
                        .where("idTable", isEqualTo: idT)
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
                        hasData = snapshot.data!.size == 0
                            ? false
                            : tableFood.get("isPaying")
                                ? false
                                : true;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10, top: 10),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color:
                                        hasData ? Colors.green : kPrimaryColor,
                                    width: 2),
                              ),
                              onPressed: hasData
                                  ? () => showDialog(
                                      context: context,
                                      builder: (ConfirmDialogContext) =>
                                          AlertDialog(
                                            backgroundColor: kSupColor,
                                            title: const Text(
                                              'Yêu cầu thanh toán?',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Hủy'),
                                                child: const Text(
                                                  'Hủy',
                                                  style: TextStyle(
                                                      color: kPrimaryColor),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  WaiterController
                                                      waiterController =
                                                      WaiterController();
                                                  waiterController.payTheBill(
                                                      idT, listFoods, () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: FlashMessageScreen(
                                                            type: "Thông báo",
                                                            content:
                                                                "Gửi yêu cầu thanh toán thành công",
                                                            color:
                                                                Colors.green),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                      ),
                                                    );
                                                  }, (msg) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content:
                                                            FlashMessageScreen(
                                                                type:
                                                                    "Thông báo",
                                                                content: msg,
                                                                color:
                                                                    kPrimaryColor),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                      ),
                                                    );
                                                  });
                                                  Navigator.pop(
                                                      ConfirmDialogContext);
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      color: kPrimaryColor),
                                                ),
                                              ),
                                            ],
                                          ))
                                  : null,
                              child: Text(
                                "Thanh Toán",
                                textScaleFactor: 2,
                                style: TextStyle(
                                    color:
                                        hasData ? Colors.green : kPrimaryColor),
                              )),
                        );
                      }
                    }),
              ],
            );
          }
        });
  }

  String _getTotal(amount, price) {
    int total = amount * price;
    return total.toString().toVND();
  }

  Future<dynamic> _changeOrDelFood(BuildContext context, MonAnDaGoi monAn,
      int index, WaiterController waiterController) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              elevation: 24,
              backgroundColor: kSupColor,
              title: Center(
                child: Text(
                  monAn.name,
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
                          int _amount = monAn.amount;
                          Navigator.pop(context);
                          _updateFoodAmount(
                              context, monAn, index, _amount, waiterController);
                        },
                        child: const Text("Thây đổi số lượng")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                          _delOrderedFood(
                              context, waiterController, monAn, index);
                        },
                        child: const Text("Xóa món ăn"))
                  ],
                ),
              ),
            ));
  }

  Future<dynamic> _delOrderedFood(BuildContext context,
      WaiterController waiterController, MonAnDaGoi monAn, int index) {
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
                      waiterController.deleteOrderedFoodinTable(
                          monAn, widget.tableFood!.get('id'), () {
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

  Future<dynamic> _updateFoodAmount(BuildContext context, MonAnDaGoi monAn,
      int index, int _amount, WaiterController waiterController) {
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
                            monAn.name,
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
                              waiterController.updateOrderedFoodAmount(
                                  monAn, widget.tableFood!.id, _amount, () {
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

  _dataTable(BuildContext context, WaiterController waiterController,
      AsyncSnapshot<List<DocumentSnapshot<Object?>>> listFoods) {
    return List<DataRow>.generate(listFoods.data!.length, (index) {
      MonAnDaGoi monAn = MonAnDaGoi.fromDocument(listFoods.data![index]);
      return DataRow(
          onLongPress: () =>
              _changeOrDelFood(context, monAn, index, waiterController),
          cells: <DataCell>[
            DataCell(
              Text(
                monAn.name,
                style: TextStyle(
                    color: monAn.status == "new"
                        ? Colors.white
                        : monAn.status == "cooking"
                            ? kPrimaryColor
                            : monAn.status == "done"
                                ? Colors.green
                                : Colors.blue),
              ),
              onTap: () => _showFoodDetail(context, monAn, index),
              onLongPress: () =>
                  _changeOrDelFood(context, monAn, index, waiterController),
            ),
            DataCell(Text(
              monAn.amount.toString(),
              style: const TextStyle(color: Colors.white),
            )),
            DataCell(Text(
              monAn.price.toString().toVND(),
              style: const TextStyle(color: Colors.white),
            )),
            DataCell(Text(
              _getTotal(monAn.amount, monAn.price),
              style: const TextStyle(color: Colors.white),
            )),
          ]);
    });
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> _getData() async {
    late Future<List<DocumentSnapshot<Map<String, dynamic>>>> list;
    WaiterController waiterController = WaiterController();
    bool isMerging = await waiterController.isMergingTable(_tableFood!.id);
    if (isMerging) {
      list = waiterController.getAllFoodinTables(_tableFood!.id);
    } else {
      list = waiterController.getAllFood(_tableFood!.id);
    }
    return list;
  }
}
