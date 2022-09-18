import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:recipes_app/viewmodels/fridge_viewmodel.dart';
import 'package:translator/translator.dart';

import '../models/recipe_card_model.dart';
import '../models/recipe_model.dart';
import '../services/spoonacular_recipes.dart';
import '../static/helper_functions.dart';

class RecipesViewmodel extends GetxController {
  List<RecipeCardModel> _recipes = <RecipeCardModel>[];

  List<RecipeCardModel> get recipes => _recipes;

  bool _loading = false;
  final translator = GoogleTranslator();

  bool get loading => _loading;

  _refreshRecipes() async {
    _loading = true;
    update();
    _loading = false;
  }

  getRecommendedRecipes(context) async {
    try {
      List<String> userIngredientsList = <String>[];

      _recipes = [];

      FridgeViewModel viewModel = FridgeViewModel();

      var userIngredientsCollection = FirebaseFirestore.instance
          .collection('ingredients')
          .where('user_uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

      userIngredientsCollection.snapshots().forEach((snapshot) async {
        for (var element in snapshot.docs) {
          {
            userIngredientsList.add(element['name']);
          }

          var response = await SpoonacularRecipes.spoonacularApi
              .makeRecommendedRequest(userIngredientsList.join(", "));
          List<dynamic> json = jsonDecode(response.body);

          for (var element in json) {
            String translation =
                await translateTextToBulgarian(element['title'], translator);

            RecipeCardModel recipeCard = RecipeCardModel(
                image: element['image'],
                id: element['id'],
                name: element['title'],
                nameBg: translation);

            _recipes.add(recipeCard);
          }
          _refreshRecipes();
        }
      });
    } catch (e) {
      showErrorMessage("${"temp_error".tr} $e", context);
    }
  }

  void getRecipes(
      nameController,
      cuisineFilterVal,
      maxProteinsFilter,
      minProteinsFilter,
      maxCaloriesFilter,
      minCaloriesFilter,
      maxTimeReadyFilter,
      context) async {
    try {
      String searchVal = nameController.text.trim();

      var response = await SpoonacularRecipes.spoonacularApi.makeSearchRequest(
          searchVal,
          cuisineFilterVal,
          maxTimeReadyFilter,
          minProteinsFilter,
          maxProteinsFilter,
          minCaloriesFilter,
          maxCaloriesFilter);

      List<dynamic> json = jsonDecode(response.body)['results'];

      _recipes = [];

      for (var element in json) {
        String translation =
            await translateTextToBulgarian(element['title'], translator);

        RecipeCardModel recipeCard = RecipeCardModel(
            image: element['image'],
            id: element['id'],
            name: element['title'],
            nameBg: translation);

        _recipes.add(recipeCard);
      }
      _refreshRecipes();
    } catch (e) {
      showErrorMessage("temp_error".tr, context);
    }
  }

  getRecipeInfo(id) async {
    var response =
        await SpoonacularRecipes.spoonacularApi.makeRecipeInfoRequest(id);

    Map json = jsonDecode(response.body);
    Map jsonCopy = jsonDecode(response.body);

    if (json['sourceName'] == null) {
      json['sourceName'] = '';
    }

    String translation =
        await translateTextToBulgarian(json['title'], translator);
    List<dynamic> ingredients = json['extendedIngredients'];
    for (var element in ingredients) {
      element['original'] =
          await translateTextToBulgarian(element['original'], translator);
    }

    List<dynamic> analyzedInstructions =
        json['analyzedInstructions'][0]['steps'];
    for (var element in analyzedInstructions) {
      element['step'] =
          await translateTextToBulgarian(element['step'], translator);
    }

    return RecipeModel(
        userUid: FirebaseAuth.instance.currentUser!.uid,
        id: json['id'],
        name: json['title'],
        image: json['image'],
        servings: json['servings'],
        totalTime: json['readyInMinutes'],
        source: json['sourceName'],
        ingredientsBg: ingredients,
        ingredients: jsonCopy['extendedIngredients'],
        analyzedInstructions: jsonCopy['analyzedInstructions'][0]['steps'],
        analyzedInstructionsBg: analyzedInstructions,
        nameBg: translation,
        url: json['sourceUrl'],
        pricePerServing: json['pricePerServing'],
        healthScore: json['healthScore']);
  }
}
