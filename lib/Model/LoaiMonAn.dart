import 'package:cloud_firestore/cloud_firestore.dart';

class LoaiMonAn {
  late String id;
  late String name;
  late String image;

  LoaiMonAn.origin() {
    id = "";
    name = "";
    image = "";
  }

  LoaiMonAn({required this.id, required this.name, required this.image});

  factory LoaiMonAn.fromDocument(DocumentSnapshot doc) {
    String name = "";
    String image = "";
    try {
      name = doc.get('name');
    } catch (e) {}
    try {
      image = doc.get('image');
    } catch (e) {}
    return LoaiMonAn(id: doc.id, name: name, image: image);
  }

  @override
  String toString() {
    // TODO: implement toString
    return name;
  }
}
