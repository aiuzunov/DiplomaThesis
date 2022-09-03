import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipes_app/models/recipe_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../models/recipe_model.dart';
import '../widgets/ingredients.dart';

class RecipePage extends StatelessWidget {
  final RecipeModel recipeModel;
  RecipePage({super.key, required this.recipeModel});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _textTheme = Theme.of(context).textTheme;
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: SlidingUpPanel(
            minHeight: (size.height / 2),
            maxHeight: (size.height / 1.2),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            parallaxEnabled: true,
            color: const Color.fromARGB(255, 48, 48, 48),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Hero(
                      tag: recipeModel.url,
                      child: Image.network(
                        recipeModel.image.toString(),
                        height: (size.height / 2) + 50,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 40,
                    right: 20,
                    child: Icon(
                      Icons.bookmark_add_outlined,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        CupertinoIcons.back,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            panel: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                          height: 5,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(height: 30),
                    Text(recipeModel.name, style: _textTheme.headline6),
                    const SizedBox(height: 10),
                    Text("Author: ${recipeModel.source}",
                        style: _textTheme.caption),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.scale_outlined),
                        const SizedBox(
                          width: 2,
                        ),
                        Text("${recipeModel.totalWeight.toInt().toString()} g"),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.run_circle),
                        const SizedBox(
                          width: 2,
                        ),
                        Text("${recipeModel.calories.toInt().toString()} cal"),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.timer_outlined),
                        const SizedBox(
                          width: 2,
                        ),
                        Text("${recipeModel.totalTime.toString()}'"),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(width: 2, height: 30, color: Colors.white),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("${recipeModel.servings.toString()} Servings"),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: DefaultTabController(
                      length: 2,
                      initialIndex: 0,
                      child: Column(
                        children: [
                          TabBar(tabs: [
                            Tab(text: "Ingredients".toUpperCase()),
                            Tab(text: "Preparation".toUpperCase()),
                          ]),
                          Expanded(
                              child: TabBarView(
                            children: [
                              Ingredients(recipeModel: recipeModel),
                              const Text("Prepatration"),
                            ],
                          ))
                        ],
                      ),
                    ))
                  ]),
            )));
  }
}
