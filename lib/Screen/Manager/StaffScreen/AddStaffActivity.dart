import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:star_restaurant/Bloc/StaffBloc.dart';
import 'package:star_restaurant/Model/NhanVien.dart';
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
  final StaffBloc _staffBloc = StaffBloc();
  ManagerController controller = ManagerController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameEditingController = TextEditingController();
  final _userNameEditingController = TextEditingController();
  final _passEditingController = TextEditingController();
  final _dateEditingController = TextEditingController();
  String _password = "";
  String _role = 'waiter';
  String _name = '';
  int _gender = 0;
  DateTime _birth = DateTime.now();
  var formatBirth = DateFormat('d-MM-y');
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
      _dateEditingController.text = DateFormat.yMd().format(_birth);
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
              padding: const EdgeInsets.only(
                  right: 10, bottom: 20, left: 10, top: 10),
              child: Column(
                children: [
                  const Text(
                    'THÔNG TIN NHÂN VIÊN',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  StreamBuilder(
                      stream: _staffBloc.nameStream,
                      builder: (context, snapshot) {
                        return TextField(
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          controller: _nameEditingController,
                          decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: 'Tên nhân viên',
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  StreamBuilder(
                      stream: _staffBloc.usernameStream,
                      builder: (context, snapshot) {
                        return TextField(
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          controller: _userNameEditingController,
                          decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: 'Tên tài khoản',
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  StreamBuilder(
                      stream: _staffBloc.passStream,
                      builder: (context, snapshot) {
                        return TextField(
                          obscureText: true,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          controller: _passEditingController,
                          decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: 'Mật khẩu',
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        const Text(
                          'Ngày sinh: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            enabled: false,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                            controller: _dateEditingController,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        IconButton(
                          icon: const Icon(
                            Icons.wysiwyg,
                            color: Colors.white,
                          ),
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
                                _birth = _fromDate;
                                _dateEditingController.text =
                                    formatBirth.format(_birth).toString();
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 20),
                    child: Row(
                      children: [
                        const Text(
                          'Giới tính: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Row(
                          children: [
                            Radio(
                                value: 0,
                                groupValue: _gender,
                                onChanged: (int? value) {
                                  setState(() =>
                                      _gender = int.parse(value.toString()));
                                }),
                            const Text(
                              'nam',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                                value: 1,
                                groupValue: _gender,
                                onChanged: (int? value) {
                                  setState(() =>
                                      _gender = int.parse(value.toString()));
                                }),
                            const Text(
                              'nữ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  ListTile(
                    title: const Text(
                      'Chức vụ:',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: DropdownButton(
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: kSecondaryColor,
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
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: kSupColor,
            padding: const EdgeInsets.only(bottom: 10),
            child: MaterialButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              padding: const EdgeInsets.all(10),
              height: 50,
              color: kPrimaryColor,
              minWidth: double.infinity,
              onPressed: () => addStaff(),
              child: const Text(
                'Thêm mới',
                style: TextStyle(color: Colors.white),
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
              padding: const EdgeInsets.only(
                  right: 10, bottom: 20, left: 10, top: 10),
              child: Column(
                children: [
                  const Text(
                    'SỬA THÔNG TIN NHÂN VIÊN',
                    style: TextStyle(
                        color: kSuccessColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  StreamBuilder(
                      stream: _staffBloc.nameStream,
                      builder: (context, snapshot) {
                        return TextField(
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          controller: _nameEditingController,
                          decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: 'Tên nhân viên',
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        const Text(
                          'Ngày sinh: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            enabled: false,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                            controller: _dateEditingController,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        IconButton(
                          icon: const Icon(
                            Icons.wysiwyg,
                            color: Colors.white,
                          ),
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
                                _birth = _fromDate;
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 20),
                    child: Row(
                      children: [
                        const Text(
                          'Giới tính: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Row(
                          children: [
                            Radio(
                                value: 0,
                                groupValue: _gender,
                                onChanged: (int? value) {
                                  setState(() =>
                                      _gender = int.parse(value.toString()));
                                }),
                            const Text(
                              'nam',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                                value: 1,
                                groupValue: _gender,
                                onChanged: (int? value) {
                                  setState(() =>
                                      _gender = int.parse(value.toString()));
                                }),
                            const Text(
                              'nữ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
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
                            style: const TextStyle(color: Colors.blue),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: kSupColor,
            padding: const EdgeInsets.only(bottom: 10),
            child: MaterialButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              padding: const EdgeInsets.all(10),
              height: 50,
              color: kSuccessColor,
              minWidth: double.infinity,
              onPressed: () {
                String name = _nameEditingController.text.trim();
                bool isvalid = _staffBloc.isNameValid(name);
                print(isvalid);
                if (isvalid) {
                  if (_dateEditingController.text.trim().isEmpty ||
                      _dateEditingController.text.trim() == "") {
                    Fluttertoast.showToast(msg: "Chọn ngày sinh");
                    return;
                  }
                  if (DateTime.now().compareTo(_birth) != 1) {
                    Fluttertoast.showToast(msg: "Chọn ngày sinh sai");
                    return;
                  }
                  print("fere");
                  controller
                      .updateStaff(staff!.id, name, _gender, _birth, _role, () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
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
                }
              },
              child: const Text(
                'Cập nhật',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ));
    }
  }

  addStaff() {
    String name = _nameEditingController.text.trim();
    String username = _userNameEditingController.text.trim();
    String pass = _passEditingController.text.trim();
    bool isvalid = _staffBloc.isValid(name, username, pass);
    if (isvalid) {
      if (_dateEditingController.text.trim().isEmpty ||
          _dateEditingController.text.trim() == "") {
        Fluttertoast.showToast(msg: "Chọn ngày sinh");
        return;
      }
      if (DateTime.now().compareTo(_birth) != 1) {
        Fluttertoast.showToast(msg: "Chọn ngày sinh sai");
        return;
      }
      NhanVien nhanVien = NhanVien(
          id: "",
          name: name,
          gender: _gender,
          birth: _birth,
          username: username,
          password: pass,
          role: _role,
          disable: false);
      controller.addStaff(nhanVien);
      Navigator.pop(context);
    }
  }
}
