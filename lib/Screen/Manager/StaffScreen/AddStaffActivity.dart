import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../Components/flash_message.dart';
import '../../../Util/Constants.dart';
import '../../../Controller/ManagerController.dart';

class AddStaff extends StatefulWidget {
  final DocumentSnapshot? staff;
  const AddStaff({Key? key, required this.staff}) : super(key: key);
  @override
  State<AddStaff> createState() => _addStaff();
}

class _addStaff extends State<AddStaff> {
  DocumentSnapshot? staff;

  ManagerController controller = ManagerController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _nameEditingController = TextEditingController();
  final _userNameEditingController = TextEditingController();
  final _dateEditingController = TextEditingController();
  String _role = 'waiter';
  String _name = '';
  int _gender = 0;
  DateTime _birth = DateTime.now();
  var formatBirth = new DateFormat('d-MM-y');
  String _username = '';
  @override
  void initState() {
    super.initState();
    staff = widget.staff;
    if (staff != null) {
      _username = staff?.get('username');
      _name = staff?.get('name');
      _role = staff?.get('role');
      _gender = staff?.get('gender');
      Timestamp _date = staff?.get('birth');
      _birth = _date.toDate();
      _nameEditingController.text = _name;
      _userNameEditingController.text = _username;
      _dateEditingController.text=DateFormat.yMd().format(this._birth);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (staff == null) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: kAppBarColor,
            title: const Text('Quản lý nhân viên'),
          ),
          key: _scaffoldKey,
          body: SafeArea(
            child: Container(
              color: kSupColor,
              padding:
                  EdgeInsets.only(right: 10, bottom: 20, left: 10, top: 10),
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
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _nameEditingController,
                    onChanged: (text) {
                      this.setState(() {
                        _name =
                            text; //when state changed => build() rerun => reload widget
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
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _userNameEditingController,
                    onChanged: (text) {
                      this.setState(() {
                        _username =
                            text; //when state changed => build() rerun => reload widget
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
                          'Ngày sinh: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            enabled: false,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                            controller: _dateEditingController,
                          ),
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
                                _dateEditingController.text=DateFormat.yMd().format(this._birth);
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
                controller.addStaff(
                    _name, _gender, _birth, _role, false, _username, () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: FlashMessageScreen(
                          type: "Thông báo",
                          content: "Cập nhật thành công!",
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
                'Cập nhật',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: kAppBarColor,
            title: const Text('Quản lý nhân viên'),
          ),
          key: _scaffoldKey,
          body: SafeArea(
            child: Container(
              color: kSupColor,
              padding:
                  EdgeInsets.only(right: 10, bottom: 20, left: 10, top: 10),
              child: Column(
                children: [
                  Text(
                    'SỬA THÔNG TIN NHÂN VIÊN',
                    style: TextStyle(
                        color: kSuccessColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 20)),
                  TextField(
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _nameEditingController,
                    onChanged: (text) {
                      this.setState(() {
                        _name =
                            text; //when state changed => build() rerun => reload widget
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
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    controller: _userNameEditingController,
                    onChanged: (text) {
                      this.setState(() {
                        _username =
                            text; //when state changed => build() rerun => reload widget
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
                          'Ngày sinh: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            enabled: false,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                            controller: _dateEditingController,
                          ),
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
                controller.updateStaff( staff!.id,
                    _name, _gender, _birth, _role, () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: FlashMessageScreen(
                          type: "Thông báo",
                          content: "Cập nhật thành công!",
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
                'Cập nhật',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ));
    }
  }
}
