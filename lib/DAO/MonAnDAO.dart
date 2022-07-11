import 'package:cloud_firestore/cloud_firestore.dart';

class MonAnDAO {
  final CollectionReference conllection =
  FirebaseFirestore.instance.collection('MonAnDaXacNhan');
  final String? id;
  MonAnDAO({this.id});

  Future confirm(String id, Function onSuccess, Function(String) onError)async {
    return await conllection
        .doc(id)
        .update({
      'status': 'cooking',
    })
        .then((value) => onSuccess())
        .catchError((onError) {
      onError("Xác nhận thất bại");
    });
  }
  Future cancel(String id, Function onSuccess, Function(String) onError)async {
    return await conllection
        .doc(id)
        .update({
      'status': 'cancel',
    })
        .then((value) => onSuccess())
        .catchError((onError) {
      onError("Hủy thất bại");
    });
  }
  Future success(String id, Function onSuccess, Function(String) onError)async {
    return await conllection
        .doc(id)
        .update({
      'status': 'cuccess',
    })
        .then((value) => onSuccess())
        .catchError((onError) {
      onError("Xác nhận thất bại");
    });
  }
}
