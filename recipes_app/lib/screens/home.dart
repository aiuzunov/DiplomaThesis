import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_app/widgets/app_bar.dart';
import '../static/helper_functions.dart';
import '../widgets/header.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: customAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
              margin: const EdgeInsets.only(left: 20),
              child: Header(text: "home".tr)),
          Center(
            child: Column(
              children: [
                Text('Signed in as ${user.email!}'),
                const IconButton(
                    onPressed: getWebsiteData, icon: Icon(Icons.abc_outlined))
              ],
            ),
          )
        ],
      ),
    );
  }
}
