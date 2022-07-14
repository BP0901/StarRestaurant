import 'package:flutter/material.dart';
import 'package:star_restaurant/Util/Constants.dart';
import '../StaffScreen/StaffActivity.dart';
import '../MenuScreen/MenuActivity.dart';
import '../TableScreen/TableActivity.dart';

class DrawerMGTM extends StatelessWidget {
  const DrawerMGTM({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _choosen = 0;
    return Drawer(
      child: StatefulBuilder(
        builder: (context, drawerStateFull) => Container(
          color: kSupColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Center(
                  child: Column(
                    children: [
                      Image.asset("assets/images/logo.png"),
                      const Text(
                        kRestaurantName,
                        textScaleFactor: 1.5,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding / 4),
                child: Container(
                  color: _choosen == 1 ? kSecondaryColor : kSupColor,
                  child: ListTile(
                    title: const Text(
                      'Quản lý nhân viên',
                      textScaleFactor: 1.25,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      drawerStateFull(
                        () {
                          _choosen = 1;
                        },
                      );
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              StaffPage() //you can send parameters using constructor
                          ));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding / 4),
                child: Container(
                  color: _choosen == 2 ? kSecondaryColor : kSupColor,
                  child: ListTile(
                    title: const Text(
                      'Quản lý menu',
                      textScaleFactor: 1.25,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      drawerStateFull(
                        () {
                          _choosen = 2;
                        },
                      );
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MenuPage() //you can send parameters using constructor
                          ));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding / 4),
                child: Container(
                  color: _choosen == 3 ? kSecondaryColor : kSupColor,
                  child: ListTile(
                    title: const Text(
                      'Quản lý bàn ăn',
                      textScaleFactor: 1.25,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      drawerStateFull(
                        () {
                          _choosen = 3;
                        },
                      );
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              TablePage() //you can send parameters using constructor
                          ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
