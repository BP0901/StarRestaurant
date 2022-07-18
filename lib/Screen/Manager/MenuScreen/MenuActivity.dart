import 'package:flutter/material.dart';
import 'package:star_restaurant/Controller/ManagerController.dart';
import 'package:star_restaurant/Screen/Manager/MenuScreen/EditMenuAxtivity.dart';
import 'package:star_restaurant/Screen/Manager/components/CardFood.dart';
import '../components/DrawerMGTM.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Util/constants.dart';

class MenuPage extends StatefulWidget {
  @override
  State<MenuPage> createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  final TextEditingController _findController = TextEditingController();
  bool _isFinding = false;
  ManagerController controller = ManagerController();
  String _findingValue = "";
  final Stream<QuerySnapshot> _foodCateStream =
      FirebaseFirestore.instance.collection('MonAn').snapshots();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    //In this lesson, we need to add AppBar and more "Add" button
    //This must be Scaffold!. not MaterialApp !
    return Scaffold(
      drawer: const DrawerMGTM(),
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: const Text('Quản lý thực đơn'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EditMenu(
                        food: null,
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
              _findFood(),
              _isFinding ? _findFoodByName() : _foodList(),
            ],
          ),
        ),
      )),
    );
  }

  Widget _findFood() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 20, left: 10, top: 10),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: _findController,
        onChanged: (String value) => onchangeFindVlaue(value),
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
            hintText: "Tìm kiếm món ăn",
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

  Widget _findFoodByName() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: _foodCateStream,
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
                itemBuilder: (context, index) => buildFoodItem(
                    context, index, snapshot.data?.docs[index], _findingValue),
              );
            }
          }),
    );
  }

  Widget _foodList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: _foodCateStream,
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
                itemBuilder: (context, index) => buildFoodItem(
                    context, index, snapshot.data?.docs[index], null),
              );
            }
          }),
    );
  }
}
