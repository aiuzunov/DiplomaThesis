import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreIngredients {
  final CollectionReference _ingredientsCollection =
      FirebaseFirestore.instance.collection('ingredients');

  static final FirestoreIngredients database = FirestoreIngredients();

  Future<CollectionReference<Object?>> getIngredientsFromFirestore() async {
    return _ingredientsCollection;
  }

  deleteIngredientFromFirestore(id) async {
    await _ingredientsCollection.doc(id).delete();
  }

  createIngredientFromFirestore(ingredient) async {
    await _ingredientsCollection.add(ingredient);
  }

  updateIngredientFromFirestore(documentSnapshot, ingredient) async {
    await _ingredientsCollection
      .doc(documentSnapshot!.id).update(ingredient);
  }
}
