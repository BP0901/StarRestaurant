import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_restaurant/Screen/Waiter/Components/MenuOfFood.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

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
                itemBuilder: (context, index) => _buildVerticalFoodByCateItem(
                    index, snapshot.data?.docs[index]),
              );
            }
          }),
    );
  }

  Widget _buildVerticalFoodByCateItem(int index, DocumentSnapshot? document) {
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
                  Material(
                    child: Image.network(
                      document.get('image'),
                      errorBuilder: (context, object, stackTrace) {
                        return Image.asset(
                          "assets/images/img_not_available.jpeg",
                        );
                      },
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  Container(
                    decoration: const BoxDecoration(color: kSecondaryColor),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              document.get('name'),
                              textScaleFactor: 1.5,
                              style: const TextStyle(color: Colors.white),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                        document.get('discount') != 0
                            ? _priceWithDiscount(document.get('price'),
                                document.get('discount'), document.get('unit'))
                            : _priceWithoutDiscount(
                                document.get('price'), document.get('unit')),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  _priceWithDiscount(price, discount, unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          discount.toString().toVND(),
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            price.toString().toVND(),
            style: const TextStyle(
              color: kPrimaryColor,
            ),
          ),
        ),
        const Text(
          " / ",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _priceWithoutDiscount(price, unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          price.toString().toVND(),
          style: const TextStyle(
            color: kPrimaryColor,
          ),
        ),
        const Text(
          " / ",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
