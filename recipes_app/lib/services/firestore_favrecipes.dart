import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreFavRecipes {
  final CollectionReference _favRecipesCollection =
      FirebaseFirestore.instance.collection('fav_recipes');

  static final FirestoreFavRecipes database = FirestoreFavRecipes();

  Future<CollectionReference<Object?>> getFavRecipesFromFirestore() async {
    return _favRecipesCollection;
  }

  deleteFavRecipeFromFirestore(id) async {
    await _favRecipesCollection.doc(id).delete();
  }

  createFavRecipeFromFirestore(recipe) async {
    await _favRecipesCollection.add(recipe);
  }

  updateFavRecipeFromFirestore(documentSnapshot, recipe) async {
    await _favRecipesCollection.doc(documentSnapshot!.id).update(recipe);
  }
}
