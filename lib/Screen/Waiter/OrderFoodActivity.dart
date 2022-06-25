import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:star_restaurant/Components/flash_message.dart';
import 'package:star_restaurant/Controller/WaiterController.dart';
import 'package:star_restaurant/Util/Constants.dart';

class OrderFoodActivity extends StatefulWidget {
  final DocumentSnapshot? tableFood;
  const OrderFoodActivity({Key? key, required this.tableFood})
      : super(key: key);

  @override
  State<OrderFoodActivity> createState() => _OrderFoodActivityState();
}

class _OrderFoodActivityState extends State<OrderFoodActivity> {
  final TextEditingController _findfoodController = TextEditingController();
  int _amount = 1;
  bool _isFinding = false;
  String _findingValue = "";
  final Stream<QuerySnapshot> _foodByCateStream =
      FirebaseFirestore.instance.collection('MonAn').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
          child: SafeArea(
        child: Container(
          color: kSupColor,
          child: Column(
            children: [
              _findFood(),
              _showFoods(),
            ],
          ),
        ),
      )),
    );
  }

  Widget _findFood() {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
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

  Widget _showFoods() {
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
    if (document != null) {
      if (_isFinding) {
        if (document
            .get('name')
            .toString()
            .toLowerCase()
            .contains(_findingValue)) {
          return _foodCard(document);
        } else {
          return const SizedBox.shrink();
        }
      } else {
        return _foodCard(document);
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Padding _foodCard(DocumentSnapshot<Object?> document) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      child: GestureDetector(
        onTap: () {
          _buildOrderFoodSheet(document);
        },
        child: Container(
          decoration: BoxDecoration(
              color: kSecondaryColor, borderRadius: BorderRadius.circular(15)),
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        document.get('name'),
                        textScaleFactor: 1.5,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      document.get('discount') != 0
                          ? _priceWithDiscount(document.get('price'),
                              document.get('discount'), document.get('unit'))
                          : _priceWithoutDiscount(
                              document.get('price'), document.get('unit')),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future<dynamic> _buildOrderFoodSheet(DocumentSnapshot<Object?> document) {
    _amount = 1;
    return showModalBottomSheet(
        elevation: 10,
        backgroundColor: kSupColor,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => SizedBox(
                height: 210,
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: kDefaultPadding / 2),
                        child: Text(
                          widget.tableFood!.get('name'),
                          textScaleFactor: 2,
                          style: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Món: ",
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            document.get('name'),
                            textScaleFactor: 1.5,
                            style: const TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Số lượng: ",
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_amount != 1) {
                                    _amount -= 1;
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_left_sharp,
                                color: Colors.white,
                              )),
                          Text(
                            "$_amount",
                            textScaleFactor: 1.5,
                            style: const TextStyle(color: Colors.white),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _amount += 1;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_right_sharp,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                            ),
                            onPressed: () {
                              WaiterController waiterController =
                                  WaiterController();
                              waiterController.orderFood(
                                  widget.tableFood, document, _amount, () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: FlashMessageScreen(
                                        type: "Thông báo",
                                        content: "Thêm món thành công",
                                        color: Colors.green),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ),
                                );
                                Navigator.pop(context);
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
                            },
                            child: const Text(
                              "Gọi món",
                              textScaleFactor: 1.5,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  _priceWithDiscount(price, discount, unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          price.toString().toVND(),
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            discount.toString().toVND(),
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
