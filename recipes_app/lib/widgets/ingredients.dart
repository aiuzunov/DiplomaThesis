import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            itemCount: Get.locale.toString() == 'bg_BG'
                ? recipeModel.ingredientsBg.length
                : recipeModel.ingredients.length,
            controller: ScrollController(),
            primary: false,
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
                        child: Get.locale.toString() == 'bg_BG'
                            ? Text(
                                "${recipeModel.ingredientsBg[index]['original']}")
                            : Text(
                                "${recipeModel.ingredients[index]['original']}")),
                  ],
                ),
              );
            }),
      ],
    ));
  }
}
