import 'package:flutter/material.dart';
import 'package:recipes_app/screens/fav_recipes.dart';
import 'package:recipes_app/screens/fridge.dart';
import 'package:recipes_app/screens/recipes.dart';
import 'package:get/get.dart';
import 'checklist.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  int _currentIndex = 0;
  final screens = [
    const Recipes(),
    const FavouriteRecipes(),
    const Fridge(),
    const Checklist()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        iconSize: 25,
        selectedFontSize: 18,
        showUnselectedLabels: false,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.food_bank),
            label: 'recipes'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'fav_recipes'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.storage_rounded),
            label: 'ingredients'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_basket),
            label: 'cart'.tr,
          ),
        ],
      ),
    );
  }
}
