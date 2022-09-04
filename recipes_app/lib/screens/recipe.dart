import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../models/recipe_model.dart';
import '../widgets/ingredients.dart';

class RecipePage extends StatefulWidget {
  final RecipeModel recipeModel;
  bool favorite = false;
  RecipePage({super.key, required this.recipeModel, required this.favorite});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference _favRecipes =
      FirebaseFirestore.instance.collection('fav_recipes');

  void saveFavoriteRecipe(RecipeModel documentSnapshot) async {
    setState(() {
      widget.favorite = true;
    });

    await _favRecipes.add({
      "ingredients": documentSnapshot.ingredients,
      "servings": documentSnapshot.servings,
      "calories": documentSnapshot.calories,
      "totalWeight": documentSnapshot.totalWeight,
      "totalTime": documentSnapshot.totalTime,
      "url": documentSnapshot.url,
      "image": documentSnapshot.image,
      "source": documentSnapshot.source,
      "name": documentSnapshot.name
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
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
                      tag: widget.recipeModel.url,
                      child: Image.network(
                        widget.recipeModel.image.toString(),
                        height: (size.height / 2) + 50,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 40,
                      right: 20,
                      child: widget.favorite
                          ? IconButton(
                              onPressed: () => {},
                              icon: const Icon(Icons.favorite, size: 38),
                              color: Colors.teal,
                            )
                          : IconButton(
                              onPressed: () =>
                                  {saveFavoriteRecipe(widget.recipeModel)},
                              icon:
                                  const Icon(Icons.favorite_outline, size: 38),
                              color: Colors.teal,
                            )),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        CupertinoIcons.back,
                        color: Colors.teal,
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
                    Text(widget.recipeModel.name, style: textTheme.headline6),
                    const SizedBox(height: 10),
                    Text("Author: ${widget.recipeModel.source}",
                        style: textTheme.caption),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.scale_outlined),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                            "${widget.recipeModel.totalWeight.toInt().toString()} g"),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.run_circle),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                            "${widget.recipeModel.calories.toInt().toString()} cal"),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.timer_outlined),
                        const SizedBox(
                          width: 2,
                        ),
                        Text("${widget.recipeModel.totalTime.toString()}'"),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(width: 2, height: 30, color: Colors.white),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                            "${widget.recipeModel.servings.toString()} Servings"),
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
                              Ingredients(recipeModel: widget.recipeModel),
                              Text(
                                  "You can find the directions here: ${widget.recipeModel.url}"),
                            ],
                          ))
                        ],
                      ),
                    ))
                  ]),
            )));
  }
}
