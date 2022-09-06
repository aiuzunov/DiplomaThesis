import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:recipes_app/services/firestore_favrecipes.dart';

import '../static/helper_functions.dart';

class FavRecipesViewModel extends GetxController {
  late CollectionReference<Object?> _favRecipes;

  CollectionReference<Object?> get favRecipes => _favRecipes;

  final user = FirebaseAuth.instance.currentUser!;

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
      _favRecipes
          .where('id', isEqualTo: documentSnapshot.id)
          .get()
          .then((value) => {
                if (value.docs.isEmpty)
                  {
                    FirestoreFavRecipes().createFavRecipeFromFirestore({
                      "user_uid": user.uid,
                      "id": documentSnapshot.id,
                      "ingredients": documentSnapshot.ingredients,
                      "servings": documentSnapshot.servings,
                      "totalTime": documentSnapshot.totalTime,
                      "url": documentSnapshot.url,
                      "image": documentSnapshot.image,
                      "source": documentSnapshot.source,
                      "name": documentSnapshot.name,
                      "analyzedInstructions":
                          documentSnapshot.analyzedInstructions,
                      "pricePerServing": documentSnapshot.pricePerServing,
                      "healthScore": documentSnapshot.healthScore
                    })
                  }
              });
    } on FirebaseException catch (e) {
      showErrorMessage(e.message.toString(), context);
    }

    showSucessMessage(
        "You have sucessfully added the recipe to your favorites.", context);
  }

  deleteFavRecipeFromFirestore(id, context) async {
    try {
      await FirestoreFavRecipes.database.deleteFavRecipeFromFirestore(id);
    } on FirebaseException catch (e) {
      showErrorMessage(e.message.toString(), context);
    }
    showSucessMessage(
        "You have sucessfully removed the recipe from your favorites.",
        context);
  }
}
