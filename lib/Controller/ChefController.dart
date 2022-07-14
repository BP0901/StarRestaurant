import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_restaurant/DAO/HttpRequest.dart';
import 'package:star_restaurant/DAO/MonAnDAO.dart';
import 'package:star_restaurant/Model/BanAn.dart';
import 'package:star_restaurant/Model/MonAnDaGoi.dart';

class ChefController {
  final HttpRequest _httpRequest = HttpRequest();
  MonAnDAO monAnDAO = MonAnDAO();

  confirmCooking(QueryDocumentSnapshot<Object?> doc, Function onSuccess,
      Function(String) onfailure) async {
    monAnDAO.confirm(doc, onSuccess, onfailure);
  }

  cancelCooking(QueryDocumentSnapshot<Object?> doc, Function onSuccess,
      Function(String) onfailure) async {
    try {
      monAnDAO.cancel(doc, onSuccess, onfailure);
      BanAn banAn = BanAn.origin();
      await FirebaseFirestore.instance
          .collection("BanAn")
          .doc(doc.get('idTable'))
          .get()
          .then((value) => banAn = BanAn.fromDocument(value));
      MonAnDaGoi monAnDaGoi = MonAnDaGoi.fromDocument(doc);
      String title = banAn.name;
      String body = "Từ chối: " + monAnDaGoi.name;
      _httpRequest.callOnFcmApiSendPushNotifications(title: title, body: body);
    } catch (e) {
      print(e);
    }
  }

  successCooking(QueryDocumentSnapshot<Object?> doc, Function onSuccess,
      Function(String) onfailure) async {
    try {
      monAnDAO.success(doc, onSuccess, onfailure);
      BanAn banAn = BanAn.origin();
      await FirebaseFirestore.instance
          .collection("BanAn")
          .doc(doc.get('idTable'))
          .get()
          .then((value) => banAn = BanAn.fromDocument(value));
      MonAnDaGoi monAnDaGoi = MonAnDaGoi.fromDocument(doc);
      String title = banAn.name;
      String body = "Đã xong: " + monAnDaGoi.name;
      _httpRequest.callOnFcmApiSendPushNotifications(title: title, body: body);
    } catch (e) {
      print(e);
    }
  }
}
