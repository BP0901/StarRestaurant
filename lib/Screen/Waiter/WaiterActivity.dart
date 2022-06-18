import 'package:flutter/material.dart';
import 'package:star_restaurant/Screen/Waiter/Components/FoodMenu.dart';

import '../../Util/Constants.dart';

class WaiterActivity extends StatefulWidget {
  const WaiterActivity({Key? key}) : super(key: key);

  @override
  State<WaiterActivity> createState() => _WaiterActivityState();
}

class _WaiterActivityState extends State<WaiterActivity> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _mainBody = [
    FoodMenu(),
    const Text("table"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _mainBody[_currentIndex],
      ),
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
            elevation: 20,
            onTap: onTabTapped,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: "Menu",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.article),
                label: "Bàn ăn",
              ),
            ]),
      ),
    );
  }
}
