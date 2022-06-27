import 'package:flutter/material.dart';
import '../StaffScreen/StaffActivity.dart';
import '../MenuScreen/MenuActivity.dart';
import '../TableScreen/TableActivity.dart';

class DrawerMGTM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('MENU QUẢN LÝ'),
          ),
          ListTile(
            title: const Text('Quản lý nhân viên'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      StaffPage() //you can send parameters using constructor
                  ));
            },
          ),
          ListTile(
            title: const Text('Quản lý menu'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      MenuPage() //you can send parameters using constructor
                  ));
            },
          ),
          ListTile(
            title: const Text('Quản lý bàn ăn'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      TablePage() //you can send parameters using constructor
                  ));
            },
          ),
        ],
      ),
    );
  }
}
