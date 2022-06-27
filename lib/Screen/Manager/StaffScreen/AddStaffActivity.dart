import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../Components/flash_message.dart';
import '../../../Util/Constants.dart';
import '../../../Controller/ManagerController.dart';

class AddStaff extends StatefulWidget {
  AddStaff({Key? key}) : super(key: key);
  @override
  State<AddStaff> createState() => _addStaff();
}

class _addStaff extends State<AddStaff> {
  ManagerController controller = ManagerController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _nameEditingController = TextEditingController();
  final _userNameEditingController = TextEditingController();
  String _role = 'waiter';
  String _name='';
  int _gender = 0;
  DateTime _birth = DateTime.now();
  String _username='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          title: const Text('Quản lý nhân viên'),
        ),
        key: _scaffoldKey,
        body: SafeArea(
          child: Container(
            color: kSupColor,
            padding: EdgeInsets.only(right: 10, bottom: 20, left: 10, top: 10),
            child: Column(
              children: [
                Text(
                  'THÔNG TIN NHÂN VIÊN',
                  style: TextStyle(
                      color: kSuccessColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                TextField(
                  controller: _nameEditingController,
                  onChanged: (text) {
                    this.setState(() {
                      _name = text;//when state changed => build() rerun => reload widget
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10),
                      ),
                    ),
                    labelText: 'Tên nhân viên',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                TextField(
                  controller: _userNameEditingController,
                  onChanged: (text) {
                    this.setState(() {
                      _username = text;//when state changed => build() rerun => reload widget
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10),
                      ),
                    ),
                    labelText: 'Tên tài khoản',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        'Ngày sinh: ${DateFormat.yMd().format(this._birth)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      RaisedButton(
                        splashColor: Colors.greenAccent,
                        child: Icon(Icons.wysiwyg),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            firstDate: DateTime(1960),
                            lastDate: DateTime(2025),
                            initialDate: DateTime.now(),
                          ).then((value) {
                            if (value != null) {
                              DateTime _fromDate = DateTime.now();
                              _fromDate = value;
                              this._birth = _fromDate;
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'Giới tính: ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Radio(
                                value: 0,
                                groupValue: _gender,
                                onChanged: (int? value) {
                                  setState(() => this._gender =
                                      int.parse(value.toString()));
                                }),
                            Text(
                              'nam',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Radio(
                                value: 1,
                                groupValue: _gender,
                                onChanged: (int? value) {
                                  setState(() => this._gender =
                                      int.parse(value.toString()));
                                }),
                            Text(
                              'nữ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                ListTile(
                  title: const Text(
                    'Chức vụ:',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: DropdownButton(
                    value: _role,
                    hint: const Text('waiter'),
                    onChanged: (String? value) {
                      setState(() {
                        _role = value.toString();
                      });
                    },
                    items: <String>['waiter', 'cashier', 'chef', 'manager']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.blue),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: kSupColor,
          padding: EdgeInsets.only(bottom: 10),
          child: MaterialButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            padding: EdgeInsets.all(10),
            height: 50,
            color: kSuccessColor,
            minWidth: double.infinity,
            onPressed: () {
              controller.addStaff(_name, _gender, _birth, _role, false, _username, () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: FlashMessageScreen(
                        type: "Thông báo",
                        content: "Lưu thành công!",
                        color: Colors.green),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                );
              }, (msg) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: FlashMessageScreen(
                        type: "Thông báo",
                        content: msg,
                        color: kPrimaryColor),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                );
              });
            },
            child: Text(
              'Lưu',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}
