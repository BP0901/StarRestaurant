import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Util/Constants.dart';
import '../components/DrawerMGTM.dart';
import '../components/Find.dart';
import './StaffListView.dart';
import 'AddStaffActivity.dart';

class StaffPage extends StatefulWidget {
  StaffPage({Key? key}) : super(key: key);
  @override
  State<StaffPage> createState() => _StaffPage();
}

class _StaffPage extends State<StaffPage> with WidgetsBindingObserver {
  bool _isFinding = false;
  String _findingValue = "";
  final TextEditingController _findStaffController = TextEditingController();
  Stream<QuerySnapshot> _staffCateStream =
      FirebaseFirestore.instance.collection('NhanVien').snapshots();
  int _cateIndex = -1;
  chooseCategory(chooseIndex) {
    _cateIndex = chooseIndex;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    //In this lesson, we need to add AppBar and more "Add" button
    //This must be Scaffold!. not MaterialApp !
    return Scaffold(
      drawer: DrawerMGTM(),
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: const Text('Quản lý nhân viên'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddStaff() //you can send parameters using constructor
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
              _isFinding ? _findStaffByName() : StaffList(),
            ],
          ),
        ),
      )),
    );
  }

  Widget _findStaff() {
    return const Padding(
      padding: EdgeInsets.only(right: 10, bottom: 20, left: 10, top: 10),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
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

  void onchangeFindVlaue(String value) async {
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
                itemBuilder: (context, index) => _buildVerticalStaffByCateItem(
                    index, snapshot.data?.docs[index]),
              );
            }
          }),
    );
  }

  Widget _buildVerticalStaffByCateItem(int index, DocumentSnapshot? document) {
    if (document != null &&
        document.get('name').toString().toLowerCase().contains(_findingValue)) {
      return Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Container(
          decoration: BoxDecoration(
              color: kSecondaryColor, borderRadius: BorderRadius.circular(15)),
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: kSecondaryColor),
                    child: Column(),
                  ),
                ],
              )),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
