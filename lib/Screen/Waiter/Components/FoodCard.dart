import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

import '../../../Util/Constants.dart';

Widget buildVerticalFood(int index, DocumentSnapshot? document) {
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
                Padding(
                  padding: const EdgeInsets.only(top: kDefaultPadding / 2),
                  child: Container(
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
                ),
              ],
            )),
      ),
    );
  } else {
    return const SizedBox.shrink();
  }
}

Widget buildVerticalFoodByCateItem(
    int index, DocumentSnapshot? document, String findingValue) {
  if (document != null &&
      document.get('name').toString().toLowerCase().contains(findingValue)) {
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
