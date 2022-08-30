import 'dart:math';
import 'package:flutter/material.dart';
import 'package:recipes_app/screens/fridge.dart';
import 'package:recipes_app/screens/recipes.dart';
import 'package:firebase_database/firebase_database.dart';

import 'home.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  int _counter = 0;
  int _currentIndex = 0;
  final screens = [const Home(), const Recipes(), Fridge()];

  // void _incrementCounter() {
  //   DatabaseReference testRef = FirebaseDatabase.instance.ref().child("test");
  //   testRef.set("Hello World ${Random().nextInt(100)}");
  //   setState(() {
  //     _counter++;
  //   });
  // }

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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Начало',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Рецепти',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage_rounded),
            label: 'Съставки',
          ),
        ],
      ),
    );
  }
}
