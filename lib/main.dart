import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:star_restaurant/Controller/MessagingController.dart';
import 'package:star_restaurant/Screen/Login/LoginActivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MessagingController.initialize();
  await Firebase.initializeApp();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  _messaging.unsubscribeFromTopic("food");
  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print(message.notification!.title);
      print(message.notification!.body);
    }
    MessagingController.display(message);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginActivity(),
    );
  }
}
