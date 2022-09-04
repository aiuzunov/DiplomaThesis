import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipes_app/screens/recipes.dart';
import 'package:recipes_app/widgets/app_bar.dart';
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
                Text('Здравейте, ето нашите предложения:'.tr,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                    )),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Recipes();
              }));
            },
            child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                    left: 100, right: 100, top: 10, bottom: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.restaurant, size: 100, color: Colors.grey),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('recipes'.tr,
                            style: GoogleFonts.roboto(
                              fontSize: 25,
                            )),
                      ],
                    ),
                  ],
                )),
          ),
          Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                  left: 100, right: 100, top: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cookie, size: 100, color: Colors.brown),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ingredients'.tr,
                          style: GoogleFonts.roboto(
                            fontSize: 25,
                          )),
                    ],
                  ),
                ],
              )),
          Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                  left: 100, right: 100, top: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
              decoration: BoxDecoration(
                  color: Colors.yellow, borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.favorite,
                        size: 100,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Любими рецепти'.tr,
                          style: GoogleFonts.roboto(
                            fontSize: 25,
                          )),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
