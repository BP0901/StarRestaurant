import 'package:star_restaurant/Components/primary_button.dart';
import 'package:flutter/material.dart';

class MsgDialog {
  static void showMsgDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          PrimaryButton(
              text: "OK", press: () => Navigator.of(context).pop(MsgDialog))
        ],
      ),
    );
  }
}
