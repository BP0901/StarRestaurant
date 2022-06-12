import 'package:flutter/material.dart';
import 'package:star_restaurant/Components/primary_button.dart';
import 'package:star_restaurant/Util/constants.dart';

class LoginActivity extends StatefulWidget {
  const LoginActivity({Key? key}) : super(key: key);

  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  bool _passStatetus = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _emailErr = "Email không đúng";
  final _passErr = "Password không đúng";
  final _isEmailValid = true;
  final _isPassValid = true;

  void _showOrHidePass() {
    setState(() {});
    _passStatetus = !_passStatetus;
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
                    child: TextField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: "Email",
                            errorText: _isEmailValid ? null : _emailErr,
                            labelStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: TextField(
                                controller: _passwordController,
                                obscureText: _passStatetus,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    errorText: _isPassValid ? null : _passErr,
                                    labelText: "Password",
                                    labelStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                          ),
                          TextButton(
                              onPressed: _showOrHidePass,
                              child: Text(
                                _passStatetus ? "Show" : "Hide",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ))
                        ]),
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
                        press: () {},
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
