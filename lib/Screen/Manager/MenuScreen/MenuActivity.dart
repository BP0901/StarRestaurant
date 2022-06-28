import 'package:flutter/material.dart';
import '../components/DrawerMGTM.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        child: Column(
          //In this lesson, we will replace the input form with "Modal Bottom Sheet"
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            findFood(),
            buildListView()
          ],
        ),
      ),
    );
  }
}

class buildListView extends StatelessWidget {
  bool _isFinding = false;
  String _findingValue = "";
  final TextEditingController _findFoodController = TextEditingController();
  Stream<QuerySnapshot> _foodCateStream =
      FirebaseFirestore.instance.collection('MonAn').snapshots();
  Widget _buildListView(int index, DocumentSnapshot? document) {
    return GestureDetector(
      onTap: () => {},
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: (index) % 2 == 0 ? Colors.blueAccent : Colors.indigoAccent,
          elevation: 10,
          //this lesson will customize this ListItem, using Column and Row
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.network(
                    document?.get('image'),
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      '${document?.get('name')}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red[400]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Unit: ${document?.get('unit')}',
                            style: TextStyle(fontSize: 18, color: Colors.white)),
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Price: ${document?.get('price')}',
                                      style: TextStyle(fontSize: 18, color: Colors.white)),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(Radius.circular(10))),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                )
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              ),

            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                itemBuilder: (context, index) =>
                    _buildListView(index, snapshot.data?.docs[index]),
              );
              ;
            }
          }),
    );
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
            hintText: "Tìm kiếm món ăn",
            hintStyle: TextStyle(color: Colors.white)),
      ),
    );
  }
}
