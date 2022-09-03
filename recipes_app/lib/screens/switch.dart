import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/screens/decide_auth.dart';
import 'package:recipes_app/screens/startup.dart';

class SwitchPage extends StatelessWidget {
  const SwitchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return const StartupPage(title: 'Recipes App');
        } else {
          return const DecideAuth();
        }
      }),
    ));
  }
}
