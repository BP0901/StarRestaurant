import 'package:cloud_firestore/cloud_firestore.dart';

class BanAn {
  late String id;
  late String name;
  late bool type;

  BanAn.origin() {
    id = "";
    name = "";
    type = false;
  }

  BanAn({required this.id, required this.name, required this.type});

  factory BanAn.fromDocument(DocumentSnapshot doc) {
    String name = "";

    bool type = false;

    try {
      name = doc.get('name');
    } catch (e) {}

    try {
      type = doc.get('type');
    } catch (e) {}
    return BanAn(id: doc.id, name: name, type: type);
  }

  @override
  String toString() {
    return name;
  }
}
