import 'package:flutter/material.dart';

class TableInfomationActivity extends StatefulWidget {
  final idTable;
  const TableInfomationActivity({Key? key, required this.idTable}) : super(key: key);

  @override
  State<TableInfomationActivity> createState() => _TableInfomationActivityState();
}

class _TableInfomationActivityState extends State<TableInfomationActivity> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(child: Text(widget.idTable)),
    );
  }
}