import 'package:cloud_firestore/cloud_firestore.dart';

class BanAn {
  late String id;
  late String idUser;
  late bool isMerging;
  late bool isPaying;
  late bool isUsing;
  late String name;
  late bool type;

  BanAn.origin() {
    id = "";
    idUser = "";
    isMerging = false;
    name = "";
    isPaying = false;
    isUsing = false;
    type = false;
  }

  BanAn(
      {required this.id,
      required this.idUser,
      required this.isMerging,
      required this.name,
      required this.isPaying,
      required this.isUsing,
      required this.type});

  factory BanAn.fromDocument(DocumentSnapshot doc) {
    String idUser = "";
    bool isMerging = false;
    String name = "";
    bool isPaying = false;
    bool isUsing = false;
    bool type = false;
    try {
      idUser = doc.get('idUser');
    } catch (e) {}
    try {
      isMerging = doc.get('isMerging');
    } catch (e) {}
    try {
      name = doc.get('name');
    } catch (e) {}
    try {
      isPaying = doc.get('isPaying');
    } catch (e) {}
    try {
      isUsing = doc.get('isUsing');
    } catch (e) {}
    try {
      type = doc.get('type');
    } catch (e) {}
    return BanAn(
        id: doc.id,
        idUser: idUser,
        isMerging: isMerging,
        name: name,
        isPaying: isPaying,
        isUsing: isUsing,
        type: type);
  }

  @override
  String toString() {
    return name;
  }
}
