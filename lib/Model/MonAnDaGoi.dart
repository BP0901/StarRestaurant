import 'package:cloud_firestore/cloud_firestore.dart';

class MonAnDaGoi {
  late String id;
  late String idTable;
  late String idFood;
  late String name;
  late int amount;
  late Timestamp orderTime;
  late String note;
  late int price;
  late String status;

  MonAnDaGoi.origin() {
    id = "";
    idTable = "";
    idFood = "";
    name = "";
    amount = 0;
    orderTime = Timestamp.now();
    note = "";
    status = "";
    price = 0;
  }

  MonAnDaGoi(
      {required this.id,
      required this.idTable,
      required this.idFood,
      required this.name,
      required this.amount,
      required this.orderTime,
      required this.note,
      required this.status,
      required this.price});

  factory MonAnDaGoi.fromDocument(DocumentSnapshot doc) {
    String idTable = "";
    String idFood = "";
    String name = "";
    int amount = 0;
    Timestamp orderTime = Timestamp.now();
    String note = "";
    String status = "";
    int price = 0;
    try {
      idTable = doc.get('idTable');
    } catch (e) {}
    try {
      idFood = doc.get('idFood');
    } catch (e) {}
    try {
      name = doc.get('name');
    } catch (e) {}
    try {
      amount = doc.get('amount');
    } catch (e) {}
    try {
      orderTime = doc.get('orderTime');
    } catch (e) {}
    try {
      note = doc.get('note');
    } catch (e) {}
    try {
      status = doc.get('status');
    } catch (e) {}
    try {
      price = doc.get('price');
    } catch (e) {}
    return MonAnDaGoi(
        id: doc.id,
        idTable: idTable,
        idFood: idFood,
        name: name,
        amount: amount,
        orderTime: orderTime,
        note: note,
        status: status,
        price: price);
  }

  @override
  String toString() {
    return "Tên" + name;
  }
}