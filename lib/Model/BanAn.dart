import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BanAn {
  late String id;
  late String name;
  late bool type;

  BanAn({required this.id, required this.name, required this.type});
}
