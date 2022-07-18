import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Components/flash_message.dart';
import '../../../Controller/ManagerController.dart';
import '../../../Util/Constants.dart';
import '../StaffScreen/AddStaffActivity.dart';

Widget buildStaffItem(BuildContext context, int index,
    DocumentSnapshot? document, String? value) {
  String _role = document?.get('role');
  String _name = document?.get('name');
  bool _locker = document?.get('disable');
  int _gender = document?.get('gender');
  Timestamp _date = document?.get('birth');
  var formatBirth = DateFormat('d-MM-y');
  DateTime _birth = _date.toDate();
  String _username = document?.get('username');
  // document.get('name').toString().toLowerCase().contains(value!)
  if (value == null) {
    if (document != null) {
      return GestureDetector(
        onLongPress: () {
          _deleteStaff(context, _name, document.id);
        },
        onTap: () {
          _infoStaff(context, document.id, _name, _role, _gender, _locker,
              formatBirth.format(_birth), _username, document);
        },
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: (index) % 2 == 0 ? kSecondaryColor : kSupColor,
            elevation: 10,
            //this lesson will customize this ListItem, using Column and Row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        const Text(
                          'Nhân viên: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        Text(
                          '${document.get('name')}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red[400]),
                        ),
                      ],
                    ),
                    // ${(document.get('gender')) == '1' ? 'Nam' : 'Nữ'}
                    Text('Gender: ${_gender == 0 ? 'Nam' : 'Nữ'}',
                        style: const TextStyle(fontSize: 18, color: Colors.white)),
                    Text('Birth: ${formatBirth.format(_birth)}',
                        style: const TextStyle(fontSize: 18, color: Colors.white)),
                    Text('Role: ${_role}',
                        style: const TextStyle(fontSize: 18, color: Colors.white)),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                  ],
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Locker',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const Icon(
                      Icons.lock_open,
                      color: kSuccessColor,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                    )
                  ],
                ))
              ],
            )),
      );
    } else {
      return const SizedBox.shrink();
    }
  } else {
    if (document != null &&
        document.get('name').toString().toLowerCase().contains(value)) {
      return GestureDetector(
        onLongPress: () {
          _deleteStaff(context, _name, document.id);
        },
        onTap: () {
          _infoStaff(context, document.id, _name, _role, _gender, _locker,
              formatBirth.format(_birth), _username, document);
        },
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: (index) % 2 == 0 ? kSecondaryColor : kSupColor,
            elevation: 10,
            //this lesson will customize this ListItem, using Column and Row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        const Text(
                          'Nhân viên: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        Text(
                          '${document.get('name')}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red[400]),
                        ),
                      ],
                    ),
                    // ${(document.get('gender')) == '1' ? 'Nam' : 'Nữ'}
                    Text('Gender: ${_gender == 0 ? 'Nam' : 'Nữ'}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                    Text('Birth: ${formatBirth.format(_birth)}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                    Text('Role: ${_role}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                  ],
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Locker',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const Icon(
                      Icons.lock_open,
                      color: kSuccessColor,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                    )
                  ],
                ))
              ],
            )),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

void _infoStaff(
    BuildContext context,
    String id,
    String name,
    String role,
    int gender,
    bool locker,
    String birth,
    String username,
    DocumentSnapshot document) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ID Cá nhân: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${id}',
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ngày sinh: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${birth}',
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Giới tính: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${gender == 0 ? 'Nam' : 'Nữ'}',
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chức vụ: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${role}',
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tài khoản cá nhân: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${username}',
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trạng thái tài khoản: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${locker == false ? 'hoạt động' : 'tạm khóa'}',
                      ),
                    ],
                  ),
                  SizedBox(
                      width: 320.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Get.to(AddStaff(
                                  staff: document,
                                ));
                              },
                              child: const Text(
                                "Sửa thông tin",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              color: const Color(0xFF1BC0C5),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Hủy",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              color: const Color(0xFF1BC0C5),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      });
}

void _deleteStaff(BuildContext context, String name, String id) {
  ManagerController controller = ManagerController();
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text('Bạn có muốn xóa ${name}'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel')),
              FlatButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'))
            ],
          )).then((value) {
    if (value != null) {
      if (value == 'OK') {
        controller.deleteStaff(id, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: FlashMessageScreen(
                  type: "Thông báo",
                  content: "Xóa thành công!",
                  color: Colors.green),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
        }, (msg) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: FlashMessageScreen(
                  type: "Thông báo", content: msg, color: kPrimaryColor),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
          Navigator.pop(context);
        });
      } else {}
    }
  });
}
