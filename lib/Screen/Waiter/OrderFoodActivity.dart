import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderFoodActivity extends StatefulWidget {
  final DocumentSnapshot? tableFood;
  const OrderFoodActivity({Key? key, required this.tableFood})
      : super(key: key);

  @override
  State<OrderFoodActivity> createState() => _OrderFoodActivityState();
}

class _OrderFoodActivityState extends State<OrderFoodActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(child: Container(color: Colors.amber,)),
    );
  }
}
