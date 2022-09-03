import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe_model.dart';

class Ingredients extends StatelessWidget {
  final RecipeModel recipeModel;
  const Ingredients({Key? key, required this.recipeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        ListView.separated(
            itemCount: recipeModel.ingredients.length,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(thickness: 1, color: Colors.white);
            },
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Flexible(
                        child:
                            Text("${recipeModel.ingredients[index]['text']}")),
                    Text(
                        " (${recipeModel.ingredients[index]['weight'].toInt().toString()} g)"),
                  ],
                ),
              );
            }),
      ],
    ));
  }
}
