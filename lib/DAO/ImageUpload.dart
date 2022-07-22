import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageUpload {
  Future<String> uploadFile(File? imageFile, String fileName) async {
    String imageUrl = "";
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile!);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
    return imageUrl;
  }
}
