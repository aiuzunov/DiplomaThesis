import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../static/helper_functions.dart';

PreferredSizeWidget customAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    leading: const Icon(Icons.local_restaurant),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: PopupMenuButton<int>(
          onSelected: (val) => onSettingsItemTap(context, val),
          icon: const Icon(Icons.settings),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: [
                  const Icon(Icons.translate),
                  const SizedBox(width: 8),
                  Text('change_language'.tr),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 1,
              child: Row(
                children: [
                  const Icon(Icons.logout_sharp),
                  const SizedBox(width: 8),
                  Text('sign_out'.tr),
                ],
              ),
            )
          ],
        ),
      )
    ],
  );
}
