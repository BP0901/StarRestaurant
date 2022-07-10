import 'package:cloud_firestore/cloud_firestore.dart';

class MonAnDaGoi {
  late String idFood;
  late String name;
  late int amount;
  late DateTime orderTime;
  late String note;
  late int price;
  late String status;

  MonAnDaGoi.origin() {
    idFood = "";
    name = "";
    amount = 0;
    orderTime = DateTime.now();
    note = "";
    price = 0;
    status = "";
  }
  MonAnDaGoi(
      {required this.idFood,
      required this.name,
      required this.amount,
      required this.orderTime,
      required this.note,
      required this.price,
      required this.status});

  factory MonAnDaGoi.fromDocument(DocumentSnapshot doc) {
    String idFood = "";
    String name = "";
    int amount = 0;
    DateTime orderTime = DateTime.now();
    String note = "";
    int price = 0;
    String status = "";
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
      price = doc.get('price');
    } catch (e) {}
    try {
      status = doc.get('status');
    } catch (e) {}
    return MonAnDaGoi(
        idFood: idFood,
        name: name,
        amount: amount,
        orderTime: orderTime,
        note: note,
        price: price,
        status: status);
  }

  @override
  String toString() {

    return this.name;
  }
}
