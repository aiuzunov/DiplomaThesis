import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

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

Future getWebsiteData() async {
  var response = await http
      .get(Uri.parse('https://www.allrecipes.com/recipe/51773/musaka'));
  print("JOE MAMA");
  print(response.body);

  dom.Document html = dom.Document.html(response.body);
  final titles = html
      .querySelectorAll(
          '#dartdoc-main-content > section.desc.markdown > div:nth-child(18) > div > div.snippet-description > p:nth-child(4) > img')
      .toList();
  print(titles.length);
}
