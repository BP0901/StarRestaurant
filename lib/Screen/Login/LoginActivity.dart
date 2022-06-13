import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:star_restaurant/Components/primary_button.dart';
import 'package:star_restaurant/Components/loading_daialog.dart';
import 'package:star_restaurant/Components/msg_dialog.dart';
import 'package:star_restaurant/Screen/Cashier/CashierActivity.dart';
import 'package:star_restaurant/Screen/Chef/ChefActiviy.dart';
import 'package:star_restaurant/Screen/Manager/ManagerActivity.dart';
import 'package:star_restaurant/Screen/Waiter/WaiterActivity.dart';
import 'package:star_restaurant/Util/constants.dart';
import 'package:star_restaurant/Screen/Login/Validation/validInput.dart';

class LoginActivity extends StatefulWidget {
  const LoginActivity({Key? key}) : super(key: key);

  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  AuthBloc authBloc = AuthBloc();

  bool _passStatetus = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showOrHidePass() {
    setState(() {});
    _passStatetus = !_passStatetus;
  }

  void _signInAnAccount() {
    String email = _usernameController.text;
    String pass = _passwordController.text;
    var isValid = authBloc.isLoginValid(email, pass);
    if (isValid) {
      LoadingDialog.showLoadingDialog(context, "Loading...");
      authBloc.signIn(email, pass, () {
        LoadingDialog.hideLoadingDialog(context);
        FirebaseFirestore.instance
            .collection('NhanVien')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          if (value.get('role') == "manager") {
            Get.to(const ManagerActivity());
          } else if (value.get('role') == "waiter") {
            Get.to(const WaiterActivity());
          } else if (value.get('role') == "cashier") {
            Get.to(const CashierActivity());
          } else if (value.get('role') == "chef") {
            Get.to(const ChefActivity());
          }
        });
      }, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, "Sign-In", msg);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 80,
                  ),
                  Image.asset(
                    "assets/images/logo.png",
                    height: 150,
                  ),
                  const Text(
                    kRestaurantName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 5),
                    child: StreamBuilder(
                        stream: authBloc.usernameStream,
                        builder: (context, snapshot) {
                          return TextField(
                              controller: _usernameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kPrimaryColor, width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  labelText: "Username",
                                  errorText: snapshot.hasError
                                      ? snapshot.error.toString()
                                      : null,
                                  prefixIcon: const SizedBox(
                                      width: 50,
                                      child: Icon(
                                        Icons.supervised_user_circle,
                                        color: kPrimaryColor,
                                      )),
                                  labelStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)));
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: StreamBuilder(
                        stream: authBloc.passStream,
                        builder: (context, snapshot) {
                          return Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: TextField(
                                      controller: _passwordController,
                                      obscureText: _passStatetus,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kPrimaryColor,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6))),
                                          errorText: snapshot.hasError
                                              ? snapshot.error.toString()
                                              : null,
                                          prefixIcon: const SizedBox(
                                              width: 50,
                                              child: Icon(
                                                Icons.password,
                                                color: kPrimaryColor,
                                              )),
                                          labelText: "Password",
                                          labelStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                ),
                                if (snapshot.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 45),
                                    child: TextButton(
                                        onPressed: _showOrHidePass,
                                        child: Text(
                                          _passStatetus ? "Hide" : "Show",
                                          style: const TextStyle(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: TextButton(
                                        onPressed: _showOrHidePass,
                                        child: Text(
                                          _passStatetus ? "Hide" : "Show",
                                          style: const TextStyle(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  )
                              ]);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: PrimaryButton(
                        key: null,
                        color: kPrimaryColor,
                        text: "Đăng nhập",
                        press: _signInAnAccount,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
