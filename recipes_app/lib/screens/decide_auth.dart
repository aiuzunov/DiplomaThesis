import 'package:flutter/material.dart';
import 'package:recipes_app/screens/login.dart';
import 'package:recipes_app/screens/sign_up.dart';

class DecideAuth extends StatefulWidget {
  const DecideAuth({Key? key}) : super(key: key);

  @override
  State<DecideAuth> createState() => _DecideAuthState();
}

class _DecideAuthState extends State<DecideAuth> {
  bool showLoginScreen = true;

  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(showRegisterPage: toggleScreens);
    } else {
      return SignUpPage(showLoginPage: toggleScreens);
    }
  }
}
