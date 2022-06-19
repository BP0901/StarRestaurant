import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BanAnDAO {
  final User? _user = FirebaseAuth.instance.currentUser;
  final _ref = FirebaseFirestore.instance.collection('BanAn');

  void checkIsUsingAndUser(DocumentSnapshot? document, Function onSuccess,
      Function(String) onErrorChecked) {
    if (!document!.get('isUsing')) {
      onSuccess();
    } else {
      bool checkCurrentUser =
          document.get('idUser') == _user!.uid ? true : false;
      if (checkCurrentUser) {
        onSuccess();
      } else {
        onErrorChecked('Bàn này không được phép xem!');
      }
    }
  }
}
