import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpRequest {
  Future<bool> callOnFcmApiSendPushNotifications(
      {required String title, required String body}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": "/topics/food",
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "type": '0rder',
        "id": '28',
        "click_action": 'FLUTTER_NOTIFICATION_CLICK',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAX4ynqtk:APA91bFqmlfpaNvC_oa-5sepbgg7O3i-Z4AlAFPhR6d1DQ3QvPQHUGmMHPDTIdUKCjUrxaDddw7HiYKGYmTGU4Wb61ukZS0_6Y9rm-1BDk3O8qsYajnmz0erhrlAkRpQsDicxmHIUWar' // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}
