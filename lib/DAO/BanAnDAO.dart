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

  void confirmOrders(
      String idT, Function onSuccess, Function(String) onfailure) {
    FirebaseFirestore.instance
        .collection("MonAnTamGoi/$idT/MonAnChoXacNhan")
        .get()
        .then((value) {
      if (value.size != 0) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection("MonAnDaXacNhan/$idT/DaXacNhan")
              .doc()
              .set(element.data());
          FirebaseFirestore.instance
              .collection("MonAnTamGoi/$idT/MonAnChoXacNhan")
              .doc(element.id)
              .delete();
        }); 
        onSuccess();
      } else {
        onfailure("Lỗi: Thêm món ăn trước khi xác nhận");
      }
    });
  }
}
