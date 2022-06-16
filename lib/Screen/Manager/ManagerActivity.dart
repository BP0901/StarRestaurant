import 'package:flutter/material.dart';

class ManagerActivity extends StatelessWidget {
  const ManagerActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: Text("quản lý"),
      )),
    );
  }
}
