import 'package:cloud_firestore/cloud_firestore.dart';

class NhanVien {
  late String id;
  late String name;
  late int gender;
  late DateTime birth;
  late String username;
  late String password;
  late String role;
  late bool disable;

  NhanVien.origin() {
    id = "";
    name = "";
    gender = 0;
    birth = DateTime.now();
    username = "";
    password = "";
    role = "";
    disable = false;
  }
  NhanVien(
      {required this.id,
      required this.name,
      required this.gender,
      required this.birth,
      required this.username,
      required this.password,
      required this.role,
      required this.disable});

  factory NhanVien.fromDocument(DocumentSnapshot doc) {
    String id = "";
    String name = "";
    int gender = 0;
    DateTime birth = DateTime.now();
    String username = "";
    String password = "";
    String role = "";
    bool disable = false;
    try {
      id = doc.get('id');
    } catch (e) {}
    try {
      name = doc.get('name');
    } catch (e) {}
    try {
      gender = doc.get('gender');
    } catch (e) {}
    try {
      birth = doc.get('birth');
    } catch (e) {}
    try {
      username = doc.get('username');
    } catch (e) {}
    try {
      password = doc.get('password');
    } catch (e) {}
    try {
      role = doc.get('role');
    } catch (e) {}
    try {
      disable = doc.get('disable');
    } catch (e) {}
    return NhanVien(
        id: doc.id,
        name: name,
        gender: gender,
        birth: birth,
        username: username,
        password: password,
        role: role,
        disable: disable);
  }
}
