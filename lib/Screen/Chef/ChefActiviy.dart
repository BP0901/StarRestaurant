import 'package:flutter/material.dart';
import '../../Util/Constants.dart';
import './Components/ListNewFood.dart';
import './Components/ListOffFood.dart';

class ChefActivity extends StatefulWidget {
  const ChefActivity({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChefActivity();
}

class _ChefActivity extends State<ChefActivity> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _mainBody = [
    ListNewFood(),
    ListOffFood(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: kAppBarColor, title: const Text('KITCHEN')),
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
            unselectedItemColor: Colors.white,
            elevation: 20,
            onTap: onTabTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: "Món mới",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cookie),
                label: "Món đang nấu",
              ),
            ]),
      ),
    );
  }
}
