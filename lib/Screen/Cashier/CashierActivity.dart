import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:get/get.dart';
import 'package:star_restaurant/Screen/Cashier/BillDetailActivity.dart';

import '../../Util/Constants.dart';

class CashierActivity extends StatelessWidget {
  const CashierActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _unpaidBill = FirebaseFirestore.instance
        .collection('HoaDon')
        .where("status", isEqualTo: "unpaid")
        .snapshots();
    return Scaffold(
      body: Material(
        color: kSecondaryColor,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                      child: Text(
                    "Yêu cầu thanh toán",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _unpaidBill,
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
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 12, 0, 12),
                                    child: StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('BanAn')
                                            .doc(snapshot.data!.docs[index]
                                                .get("idTable"))
                                            .snapshots(),
                                        builder: (context, table) {
                                          String tableName =
                                              table.data?.get("name") ?? "Lỗi";
                                          int total = 0;

                                          return GestureDetector(
                                            onTap: (() => Get.to(
                                                BillDetailActivity(
                                                    bill: snapshot
                                                        .data!.docs[index],
                                                    tableName: tableName))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 0, 10),
                                                  child: Text(
                                                    tableName,
                                                    textScaleFactor: 1.5,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 10, 10),
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        .get("total")
                                                        .toString()
                                                        .toVND(),
                                                    textScaleFactor: 1.5,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  )),
                                ],
                              );
                            });
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//  Expanded(
//               child: ListView.builder(
//                 itemCount: 50,
//                 itemBuilder: (context, index) {
//                   return InkWell(
//                     onTap: () =>
//                         Get.to(PayInformationTable(name: "Bàn số $index")),
//                     child: Row(
//                       children: [
//                         Expanded(
//                             child: Padding(
//                           padding: const EdgeInsets.fromLTRB(10, 12, 0, 12),
//                           child: Text(
//                             "bàn số $index",
//                             style: const TextStyle(
//                                 color: Colors.white, fontSize: 15),
//                           ),
//                         )),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
