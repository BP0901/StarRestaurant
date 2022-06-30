import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_restaurant/Screen/Waiter/Components/FoodCard.dart';

import '../../../Util/Constants.dart';

class MenuOfFood extends StatefulWidget {
  const MenuOfFood({Key? key}) : super(key: key);

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
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _cateIndex = -1;
                    _foodByCateStream = FirebaseFirestore.instance
                        .collection('MonAn')
                        .snapshots();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color:
                            -1 == _cateIndex ? kPrimaryColor : kSecondaryColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Material(
                            child: Image.asset(
                              "assets/images/allcate.png",
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                        ),
                        const Text(
                          "Tất cả",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: _cateStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kPrimaryColor),
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
            ],
          ),
        ),
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
                        buildVerticalFood(index, snapshot.data?.docs[index]),
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
}
