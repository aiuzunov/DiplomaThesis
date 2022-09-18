import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:recipes_app/services/firestore_favrecipes.dart';
import 'package:translator/translator.dart';

import '../models/recipe_model.dart';
import '../static/helper_functions.dart';

class FavRecipesViewModel extends GetxController {
  late CollectionReference<Object?> _favRecipes;

  CollectionReference<Object?> get favRecipes => _favRecipes;

  bool _loading = false;

  bool get loading => _loading;

  @override
  void onInit() {
    super.onInit();
    _getFavRecipesFromFirestore();
  }

  _getFavRecipesFromFirestore() async {
    _loading = true;
    _favRecipes = await FirestoreFavRecipes().getFavRecipesFromFirestore();
    _loading = false;
    update();
  }

  createFavRecipeFromFirestore(documentSnapshot, context) async {
    try {
      var bulgarianRecipeName = await translateTextToBulgarian(
          documentSnapshot.name, GoogleTranslator());

      _favRecipes
          .where('id', isEqualTo: documentSnapshot.id)
          .get()
          .then((value) => {
                if (value.docs.isEmpty)
                  {
                    FirestoreFavRecipes().createFavRecipeFromFirestore({
                      "user_uid": FirebaseAuth.instance.currentUser!.uid,
                      "id": documentSnapshot.id,
                      "ingredients": documentSnapshot.ingredients,
                      "servings": documentSnapshot.servings,
                      "totalTime": documentSnapshot.totalTime,
                      "url": documentSnapshot.url,
                      "image": documentSnapshot.image,
                      "source": documentSnapshot.source,
                      "name": documentSnapshot.name,
                      "nameBg": bulgarianRecipeName,
                      "analyzedInstructions":
                          documentSnapshot.analyzedInstructions,
                      "pricePerServing": documentSnapshot.pricePerServing,
                      "healthScore": documentSnapshot.healthScore
                    }),
                    showSucessMessage("add_recipe".tr, context)
                  }
                else
                  {
                    FirestoreFavRecipes()
                        .deleteFavRecipeFromFirestore(value.docs.first.id),
                    showSucessMessage("remove_recipe".tr, context)
                  }
              });
    } on FirebaseException catch (e) {
      showErrorMessage(e.message.toString(), context);
    }
  }

  deleteFavRecipeFromFirestore(id, context) async {
    try {
      await FirestoreFavRecipes.database.deleteFavRecipeFromFirestore(id);
    } on FirebaseException catch (e) {
      showErrorMessage(e.message.toString(), context);
    }
    showSucessMessage("remove_recipe".tr, context);
  }

  getFavRecipeInfo(documentSnapshot, translator) async {
    List<dynamic> ingredients = documentSnapshot['ingredients'];
    List<dynamic> analyzedInstructions =
        documentSnapshot['analyzedInstructions'];

    for (var element in ingredients) {
      element['original'] =
          await translateTextToBulgarian(element['original'], translator);
    }

    for (var element in analyzedInstructions) {
      element['step'] =
          await translateTextToBulgarian(element['step'], translator);
    }

    RecipeModel recipeModel = RecipeModel(
        userUid: FirebaseAuth.instance.currentUser!.uid,
        id: documentSnapshot['id'],
        ingredients: documentSnapshot['ingredients'],
        ingredientsBg: ingredients,
        servings: documentSnapshot['servings'],
        totalTime: documentSnapshot['totalTime'],
        image: documentSnapshot['image'],
        url: documentSnapshot['url'],
        source: documentSnapshot['source'],
        name: documentSnapshot['name'],
        nameBg: documentSnapshot['nameBg'],
        analyzedInstructions: documentSnapshot['analyzedInstructions'],
        analyzedInstructionsBg: analyzedInstructions,
        pricePerServing: documentSnapshot['pricePerServing'],
        healthScore: documentSnapshot['healthScore']);

    return recipeModel;
  }
}
