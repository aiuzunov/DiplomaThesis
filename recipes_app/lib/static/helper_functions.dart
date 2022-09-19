import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void onSettingsItemTap(BuildContext context, int val) {
  switch (val) {
    case 0:
      if (Get.locale.toString() == 'bg_BG') {
        Get.updateLocale(const Locale('en', 'US'));
      } else {
        Get.updateLocale(const Locale('bg', 'BG'));
      }
      break;
    case 1:
      FirebaseAuth.instance.signOut();
      break;
  }
}

void showErrorMessage(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(msg, style: const TextStyle(color: Colors.white))));
}

void showSucessMessage(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(msg, style: const TextStyle(color: Colors.white))));
}

translateText(String text, translator) async {
  var translation;

  if (Get.locale.toString() == 'bg_BG') {
    translation = await translator.translate(text, from: 'en', to: 'bg');
  }

  return translation != null ? translation.text : text;
}

translateTextReverse(String text, translator) async {
  var translation;

  translation = await translator.translate(text, from: 'bg', to: 'en');

  return translation != null ? translation.text : text;
}

translateTextToBulgarian(String text, translator) async {
  var translation;

  translation = await translator.translate(text, from: 'en', to: 'bg');

  return translation != null ? translation.text : text;
}
