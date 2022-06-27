import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import '../../../Components/flash_message.dart';
import '../../../Model/NhanVien.dart';
import '../../../Util/Constants.dart';
import 'package:intl/intl.dart';
import '../../../Controller/ManagerController.dart';

class StaffList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _staffList();
}

class _staffList extends State<StaffList> {
  ManagerController controller = ManagerController();
  final _nameEditingController = TextEditingController();
  final _userNameEditingController = TextEditingController();
  Stream<QuerySnapshot> _staffCateStream =
      FirebaseFirestore.instance.collection('NhanVien').snapshots();
  int _cateIndex = -1;
  final _contentController = TextEditingController();
  chooseCategory(chooseIndex) {
    _cateIndex = chooseIndex;
  }

  Widget _buildStaffItem(int index, DocumentSnapshot? document) {
    String _role = document?.get('role');
    String _name=document?.get('name');
    // int _gender = document?.get('gender');
    // DateTime _birth = document?.get('birth');
    String _username=document?.get('username');
    if (document != null) {
      return GestureDetector(
        onDoubleTap: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Xác nhận xóa'),
                    content: Text('Bạn có muốn xóa ${document.get('name')}'),
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
              if(value=='OK'){
                controller.deleteStaff(document.id, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
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
                          type: "Thông báo",
                          content: msg,
                          color: kPrimaryColor),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  );
                  Navigator.pop(context);
                });
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: FlashMessageScreen(
                        type: "Thông báo",
                        content: "Lỗi!",
                        color: Colors.redAccent),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                );
              }
            }
          });
        },
        onTap: () => {_onButtonShowModalSheet(_name,_username,_role,document)},
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: (index) % 2 == 0 ? kSecondaryColor : kSupColor,
            elevation: 10,
            //this lesson will customize this ListItem, using Column and Row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Text(
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
                    Text(
                        'Gender: ${document.get('gender') == 0 ? 'Nam' : 'Nữ'}',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text('Birth: ${DateFormat('d/M/y').format(DateTime.now())}',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text('Role: ${document.get('role')}',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Padding(padding: EdgeInsets.only(bottom: 10)),
                  ],
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Locker',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    Icon(
                      Icons.lock_open,
                      color: kSuccessColor,
                    ),
                    Padding(
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

  @override
  Widget build(BuildContext context) {
    //Now how to make this "Scrollable", let use ListView:
    //1.ListView(children: <Widget>[]) => this loads all children at the same time
    //2.ListView(itemBuilder: ...) => this loads only visible items
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: _staffCateStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                ),
              );
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) =>
                    _buildStaffItem(index, snapshot.data?.docs[index]),
              );
              ;
            }
          }),
    );
  }

  void _onButtonShowModalSheet(name,username,role,DocumentSnapshot? document) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: <Widget>[
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
                    name = text;//when state changed => build() rerun => reload widget
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10),
                    ),
                  ),
                  labelText: 'Tên nhân viên',
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              TextField(
                controller: _userNameEditingController,
                onChanged: (text) {
                  this.setState(() {
                    username = text;//when state changed => build() rerun => reload widget
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10),
                    ),
                  ),
                  labelText: 'Tên tài khoản',
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              // Padding(padding: EdgeInsets.only(bottom: 10)),
              // Container(
              //   padding: EdgeInsets.only(left: 15),
              //   child: Row(
              //     children: [
              //       Text(
              //         'Ngày sinh: ${DateFormat.yMd().format(birth)}',
              //         style: TextStyle(color: Colors.white),
              //       ),
              //       Padding(padding: EdgeInsets.only(left: 10)),
              //       RaisedButton(
              //         splashColor: Colors.greenAccent,
              //         child: Icon(Icons.wysiwyg),
              //         onPressed: () {
              //           showDatePicker(
              //             context: context,
              //             firstDate: DateTime(1960),
              //             lastDate: DateTime(2025),
              //             initialDate: DateTime.now(),
              //           ).then((value) {
              //             if (value != null) {
              //               DateTime _fromDate = DateTime.now();
              //               _fromDate = value;
              //               birth = _fromDate;
              //             }
              //           });
              //         },
              //       )
              //     ],
              //   ),
              // ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Container(
                padding: EdgeInsets.only(left: 15, right: 20),
                child: Row(
                  children: [
                    Text(
                      'Giới tính: ',
                      style: TextStyle(color: Colors.black),
                    ),
                    Container(
                      child: Row(
                        children: [
                          // Radio(
                          //     value: 0,
                          //     groupValue: gender,
                          //     onChanged: (int? value) {
                          //       setState(() => gender =
                          //           int.parse(value.toString()));
                          //     }),
                          Text(
                            'nam',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          // Radio(
                          //     value: 1,
                          //     groupValue: gender,
                          //     onChanged: (int? value) {
                          //       setState(() => gender =
                          //           int.parse(value.toString()));
                          //     }),
                          Text(
                            'nữ',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              // ListTile(
              //   title: const Text(
              //     'Chức vụ:',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   trailing: DropdownButton(
              //     value: role,
              //     hint: const Text('waiter'),
              //     onChanged: (String? value) {
              //       setState(() {
              //         role = value.toString();
              //       });
              //     },
              //     items: <String>['waiter', 'cashier', 'chef', 'manager']
              //         .map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(
              //           value,
              //           style: TextStyle(color: Colors.blue),
              //         ),
              //       );
              //     }).toList(),
              //   ),
              // ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              const Divider(),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                        child: SizedBox(
                      child: RaisedButton(
                        color: Colors.teal,
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: () {
                          print('press Save');
                          setState(() {});
                          //dismiss after inserting
                          Navigator.of(context).pop();
                        },
                      ),
                      height: 50,
                    )),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                        child: SizedBox(
                      child: RaisedButton(
                        color: Colors.pinkAccent,
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: () {
                          print('Press cancel');
                          Navigator.of(context).pop();
                        },
                      ),
                      height: 50,
                    ))
                  ],
                ),
              ),
              //ok button
            ],
          );
        });
  }
}
