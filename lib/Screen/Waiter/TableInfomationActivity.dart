import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_restaurant/Screen/Waiter/Components/FoodOrdered.dart';

import '../../Util/Constants.dart';
import 'Components/OrderFoodConfirm.dart';

class TableInfomationActivity extends StatefulWidget {
  final DocumentSnapshot? tableFood;
  const TableInfomationActivity({Key? key, required this.tableFood})
      : super(key: key);

  @override
  State<TableInfomationActivity> createState() =>
      _TableInfomationActivityState();
}

class _TableInfomationActivityState extends State<TableInfomationActivity> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _currentIndex == 0
              ? OrderFoodConfirm(tableFood: widget.tableFood)
              : FoodOrdered(tableFood: widget.tableFood)),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(0.5, 3),
              color: Colors.black,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: kSupColor,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: Colors.white,
            elevation: 20,
            onTap: onTabTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: "Món tạm gọi",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article),
                label: "Món đã gọi",
              ),
            ]),
      ),
    );
  }
}
