import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Util/Constants.dart';
class Seach extends SearchDelegate {
  Stream<QuerySnapshot> _staffCateStream =
  FirebaseFirestore.instance.collection('NhanVien').snapshots();
  List<String> data= [];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery=[];
    for(var item in data){
      if(item.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(item);
      }
    }
    return ListView.builder(
    itemCount: matchQuery.length,
    itemBuilder: (context, index){
     var result = matchQuery[index];
     return ListTile(
       title: Text(result),
     );
    });
  }
}
