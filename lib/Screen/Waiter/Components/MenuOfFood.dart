import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Util/Constants.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

class MenuOfFood extends StatefulWidget {
  MenuOfFood({Key? key}) : super(key: key);

  @override
  State<MenuOfFood> createState() => _MenuOfFoodState();
}

class _MenuOfFoodState extends State<MenuOfFood> {
  final Stream<QuerySnapshot> _cateStream =
      FirebaseFirestore.instance.collection('LoaiMonAn').snapshots();
  Stream<QuerySnapshot> _foodByCateStream =
      FirebaseFirestore.instance.collection('MonAn').snapshots();
  int _cateIndex = -1;

  chooseCategory(chooseIndex) {
    _cateIndex = chooseIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        SizedBox(
            height: 150,
            child: StreamBuilder<QuerySnapshot>(
              stream: _cateStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) => _buildHorizonCateItem(
                        index, snapshot.data?.docs[index]),
                  );
                }
              },
            )),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: _foodByCateStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        _buildVerticalFoodByCateItem(
                            index, snapshot.data?.docs[index]),
                  );
                }
              }),
        ),
      ],
    ));
  }

  Widget _buildHorizonCateItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _cateIndex = index;
            _foodByCateStream = FirebaseFirestore.instance
                .collection('MonAn')
                .where('type', isEqualTo: document.get('id'))
                .snapshots();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
                color: index == _cateIndex ? kPrimaryColor : kSecondaryColor,
                borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Material(
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
                ),
                Text(
                  document.get('name'),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildVerticalFoodByCateItem(int index, DocumentSnapshot? document) {
    if (document != null) {
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
