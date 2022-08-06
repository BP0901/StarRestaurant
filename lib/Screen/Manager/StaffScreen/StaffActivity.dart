import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../Components/flash_message.dart';
import '../../../Controller/ManagerController.dart';
import '../../../Util/Constants.dart';
import '../components/DrawerMGTM.dart';
import '../components/Find.dart';
import 'AddStaffActivity.dart';
import '../components/CardStaff.dart';

class StaffPage extends StatefulWidget {
  StaffPage({Key? key}) : super(key: key);
  @override
  State<StaffPage> createState() => _StaffPage();
}

class _StaffPage extends State<StaffPage> with WidgetsBindingObserver {
  final TextEditingController _findController = TextEditingController();
  bool _isFinding = false;
  ManagerController controller = ManagerController();
  String _findingValue = "";
  final Stream<QuerySnapshot> _staffCateStream =
      FirebaseFirestore.instance.collection('NhanVien').snapshots();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMGTM(),
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: const Text('Quản lý nhân viên'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddStaff(
                        staff: null,
                      ) //you can send parameters using constructor
                  ));
              // showSearch(context: context, delegate: Seach());
            },
          )
        ],
      ),
      key: _scaffoldKey,
      body: SafeArea(
          child: Material(
        child: Container(
          color: kSupColor,
          child: Column(
            children: [
              _findStaff(),
              _isFinding ? _findStaffByName() : _staffList(),
            ],
          ),
        ),
      )),
    );
  }

  Widget _findStaff() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 20, left: 10, top: 10),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: _findController,
        onChanged:(String value) => onchangeFindVlaue(value),
        decoration: const InputDecoration(
            focusColor: kPrimaryColor,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            filled: true,
            fillColor: kSecondaryColor,
            hintText: "Tìm kiếm nhân viên",
            hintStyle: TextStyle(color: Colors.white)),
      ),
    );
  }

  onchangeFindVlaue(String value) async {
    if (value.isEmpty) {
      setState(() {
        _isFinding = false;
        _findingValue = value.toLowerCase();
      });
    } else {
      setState(() {
        _isFinding = true;
        _findingValue = value.toLowerCase();
      });
    }
  }

  Widget _findStaffByName() {
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
                    buildStaffItem(context, index, snapshot.data?.docs[index],_findingValue),
              );
            }
          }),
    );
  }

  Widget _staffList() {
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
                    buildStaffItem(context, index, snapshot.data?.docs[index],null),
              );
            }
          }),
    );
  }
}
