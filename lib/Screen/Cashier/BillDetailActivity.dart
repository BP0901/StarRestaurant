import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:star_restaurant/Components/flash_message.dart';
import 'package:star_restaurant/Controller/CashierController.dart';
import 'package:star_restaurant/Screen/Cashier/Components/Bill.dart';
import 'package:star_restaurant/Util/Constants.dart';

class BillDetailActivity extends StatefulWidget {
  final DocumentSnapshot? bill;
  final String tableName;
  const BillDetailActivity(
      {Key? key, required this.bill, required this.tableName})
      : super(key: key);

  @override
  State<BillDetailActivity> createState() => _BillDetailActivityState();
}

class _BillDetailActivityState extends State<BillDetailActivity> {
  final CashierController _cashierController = CashierController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: kSupColor,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("ChiTietHoaDon")
                .where("idBill", isEqualTo: widget.bill!.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),
                );
              } else {
                return SafeArea(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            widget.tableName,
                            textScaleFactor: 2,
                            style: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: kPrimaryColor, width: 2),
                              ),
                              child: const Text(
                                "Xác nhận",
                                textScaleFactor: 2,
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                          backgroundColor: kSupColor,
                                          content: const Text(
                                            'Xác nhận đã thanh toán',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'Hủy'),
                                              child: const Text(
                                                'Hủy',
                                                style: TextStyle(
                                                    color: kPrimaryColor),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                _cashierController
                                                    .confirmPayTheBill(
                                                        widget.bill, () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: FlashMessageScreen(
                                                          type: "Thông báo",
                                                          content:
                                                              "Xác nhận thành công!",
                                                          color: Colors.green),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                    ),
                                                  );
                                                }, (msg) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content:
                                                          FlashMessageScreen(
                                                              type: "Thông báo",
                                                              content: msg,
                                                              color:
                                                                  kPrimaryColor),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                    ),
                                                  );
                                                });
                                              },
                                              child: const Text(
                                                'Có',
                                                style: TextStyle(
                                                    color: kPrimaryColor),
                                              ),
                                            ),
                                          ])),
                            ),
                            IconButton(
                                onPressed: () => Get.to(BillPrint(
                                      bill: widget.bill,
                                      tableName: widget.tableName,
                                      billDetail: snapshot,
                                    )),
                                icon: const FaIcon(
                                  FontAwesomeIcons.print,
                                  color: kPrimaryColor,
                                )),
                          ],
                        ),
                      ],
                    ),
                    _billDetail(snapshot),
                  ],
                ));
              }
            }),
      ),
    );
  }

  SingleChildScrollView _billDetail(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text(
                'Món ăn',
                textScaleFactor: 1.5,
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'SL',
                textScaleFactor: 1.5,
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Giá',
                textScaleFactor: 1.5,
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Tổng',
                textScaleFactor: 1.5,
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: List<DataRow>.generate(
              snapshot.data!.size,
              (index) => DataRow(
                    cells: <DataCell>[
                      DataCell(StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("MonAn")
                              .doc(snapshot.data!.docs[index].get('idFood'))
                              .snapshots(),
                          builder: (context, food) {
                            return Text(
                              food.data?.get("name") ?? "Lỗi",
                              style: const TextStyle(color: Colors.white),
                            );
                          })),
                      DataCell(Text(
                        snapshot.data!.docs[index].get('amount').toString(),
                        style: const TextStyle(color: Colors.white),
                      )),
                      DataCell(Text(
                        snapshot.data!.docs[index]
                            .get('price')
                            .toString()
                            .toVND(),
                        style: const TextStyle(color: Colors.white),
                      )),
                      DataCell(Text(
                        _getTotal(snapshot.data!.docs[index].get('amount'),
                            snapshot.data!.docs[index].get('price')),
                        style: const TextStyle(color: Colors.white),
                      )),
                    ],
                  )),
        ));
  }

  String _getTotal(amount, price) {
    int total = amount * price;
    return total.toString().toVND();
  }
}
