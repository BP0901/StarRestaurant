import 'package:flutter/material.dart';
import '../components/DrawerMGTM.dart';
import '../../../Util/constants.dart';

class MenuPage extends StatefulWidget {
  @override
  State<MenuPage> createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Quản lý thực đơn'),
      ),
      drawer: DrawerMGTM(),
      body: Container(
        color: kSupColor,
        padding: EdgeInsets.all(10),
        child: 
        Column(
          //In this lesson, we will replace the input form with "Modal Bottom Sheet"
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            findFood(),
            _bildListView(),
          ],
        ),
      ),
    );
  }
}

class _bildListView extends StatelessWidget {
  final int index = 20;
  ListView _buildListView() {
    return ListView.builder(
        itemCount: index,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => {},
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color:
                    (index) % 2 == 0 ? Colors.blueAccent : Colors.indigoAccent,
                elevation: 10,
                //this lesson will customize this ListItem, using Column and Row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/images/pizza.png",
                        height: 100,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          'Món ăn:  $index',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red[400]),
                        ),
                        Text('Mã món: $index',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Unit: ',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Price: 12000',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                        )
                      ],
                    ))
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(child: Container(child: _buildListView()));
  }
}

class findFood extends StatelessWidget {
  const findFood({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 10, bottom: 20),
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
}
