import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Components/primary_button.dart';
import './components/DrawerMGTM.dart';
import 'MenuScreen/MenuActivity.dart';
import 'StaffScreen/StaffActivity.dart';
import 'TableScreen/TableActivity.dart';
import '../../../Util/Constants.dart';

class ManagerActivity extends StatefulWidget {
  const ManagerActivity({Key? key}) : super(key: key);

  @override
  State<ManagerActivity> createState() => _ManagermentActivityState();
}

class _ManagermentActivityState extends State<ManagerActivity> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: kAppBarColor,
            title: const Text("Trang quản lý thông tin")),
        drawer: DrawerMGTM(),
        body: SafeArea(
          child: Container(
            color: kSupColor,
            child: Column(
              children: [
                PrimaryButton(
                  text: 'Quản lý nhân viên',
                  press: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            StaffPage() //you can send parameters using constructor
                        ));
                  },
                  color: Colors.blue,
                  padding: const EdgeInsets.all(8.0),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                PrimaryButton(
                  text: 'Quản lý Menu',
                  press: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MenuPage() //you can send parameters using constructor
                        ));
                  },
                  color: Colors.blue,
                  padding: const EdgeInsets.all(8.0),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                PrimaryButton(
                  text: 'Quản lý bàn ăn',
                  press: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            TablePage() //you can send parameters using constructor
                        ));
                  },
                  color: Colors.blue,
                  padding: const EdgeInsets.all(8.0),
                )
              ],
            ),
            // margin: const EdgeInsets.symmetric(horizontal: 8.0),
            padding: const EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
