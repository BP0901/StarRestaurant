import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_restaurant/Screen/Waiter/Components/MenuOfFood.dart';
import 'package:star_restaurant/Screen/Waiter/Components/FoodCard.dart';

import '../../../Util/Constants.dart';

class FoodMenu extends StatefulWidget {
  const FoodMenu({Key? key}) : super(key: key);

  @override
  State<FoodMenu> createState() => _FoodMenuState();
}

class _FoodMenuState extends State<FoodMenu> {
  bool _isFinding = false;
  String _findingValue = "";
  final TextEditingController _findfoodController = TextEditingController();
  final Stream<QuerySnapshot> _foodByCateStream =
      FirebaseFirestore.instance.collection('MonAn').snapshots();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: kSupColor,
        child: Column(
          children: [
            _findFood(),
            _isFinding ? _findFoodByName() : MenuOfFood(),
          ],
        ),
      ),
    );
  }

  Widget _findFood() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 50),
      child: TextField(
        controller: _findfoodController,
        onChanged: onchangeFindVlaue,
        style: const TextStyle(color: Colors.white),
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

  Widget _findFoodByName() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: _foodByCateStream,
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
                itemBuilder: (context, index) => buildVerticalFoodByCateItem(
                    index, snapshot.data?.docs[index], _findingValue),
              );
            }
          }),
    );
  }
}
