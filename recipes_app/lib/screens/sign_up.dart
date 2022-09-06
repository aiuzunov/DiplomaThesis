import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:recipes_app/viewmodels/sign_up_viewmodel.dart';

import '../static/helper_functions.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.showLoginPage}) : super(key: key);
  final VoidCallback showLoginPage;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SignUpViewModel());
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: GetBuilder<SignUpViewModel>(
            init: Get.find<SignUpViewModel>(),
            builder: (controller) => controller.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.restaurant, size: 100),
                        const SizedBox(
                          height: 50,
                        ),
                        const SizedBox(height: 10),
                        Text('register_below'.tr,
                            style: GoogleFonts.roboto(
                              fontSize: 26,
                            )),
                        const SizedBox(height: 40),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 100.0),
                          child: TextField(
                            controller: _emailController,
                            onChanged: (val) {},
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                hintText: "email".tr,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade600)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade600))),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 100.0),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            onChanged: (val) {},
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.key),
                                hintText: "password".tr,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade600)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade600))),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 100.0),
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            onChanged: (val) {},
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.key),
                                hintText: "confirm_password".tr,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade600)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade600))),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100),
                            child: GestureDetector(
                              onTap: () {
                                controller.signUp(
                                    _emailController,
                                    _passwordController,
                                    _confirmPasswordController,
                                    context);
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                      child: Text('sign_up'.tr,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)))),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('already_registered'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            GestureDetector(
                              onTap: widget.showLoginPage,
                              child: Text('login_now'.tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ),
                          ],
                        )
                      ],
                    ),
                  )));
  }
}
