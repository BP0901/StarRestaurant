import 'package:flutter/material.dart';
import '../components/DrawerMGTM.dart';
import '../../../Util/constants.dart';
import '../../../Model/BanAn.dart';

class TablePage extends StatefulWidget {
  @override
  State<TablePage> createState() => _TablePage();
}

class _TablePage extends State<TablePage> {
  final _contentController = TextEditingController();
  final _amountController = TextEditingController();
  int _radioVal = 0;
  double _slider2Val = 50.0;
  //define states
  BanAn _table = BanAn(id: '', name: '', type: true);
  List<BanAn> _tables = List<BanAn>.empty();

  void _insertTransaction() {
    //You must validate information first
    if (_table.name.isEmpty) {
      return;
    }
    _tables.add(_table);
    _table = BanAn(id: '', name: '', type: true);
    _contentController.text = '';
    _amountController.text = '';
  }

  void _onButtonShowModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: _contentController,
                    onChanged: (text) {
                      setState(() {});
                    },
                  )),
              const Divider(),
              Container(
                padding: EdgeInsets.only(left: 15, right: 20),
                child: Row(
                  children: [
                    Text(
                      'Giới tính: ',
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Radio(
                              value: 0,
                              groupValue: _radioVal,
                              onChanged: (int? value) {
                                setState(() => _radioVal =
                                    int.parse(value.toString()));
                              }),
                          Text(
                            'nam',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Radio(
                              value: 1,
                              groupValue: _radioVal,
                              onChanged: (int? value) {
                                setState(() => _radioVal =
                                    int.parse(value.toString()));
                              }),
                          Text(
                            'nữ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                        child: SizedBox(
                      child: RaisedButton(
                        color: Colors.teal,
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: () {
                          print('press Save');
                          setState(() {
                            this._insertTransaction();
                          });
                          //dismiss after inserting
                          Navigator.of(context).pop();
                        },
                      ),
                      height: 50,
                    )),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                        child: SizedBox(
                      child: RaisedButton(
                        color: Colors.pinkAccent,
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: () {
                          print('Press cancel');
                          Navigator.of(context).pop();
                        },
                      ),
                      height: 50,
                    ))
                  ],
                ),
              ),
              //ok button
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final int index = 10;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Quản lý bàn ăn'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              this._onButtonShowModalSheet();
            },
          )
        ],
      ),
      drawer: DrawerMGTM(),
      body: ListView.builder(
          itemCount: index,
          itemBuilder: (context, index) {
            return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: (index) % 2 == 0 ? Colors.green : kSupColor,
                elevation: 10,
                //this lesson will customize this ListItem, using Column and Row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          'Bàn số $index',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                      ],
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Loại bàn: Thường',
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
                ));
          }),
    );
  }
}
