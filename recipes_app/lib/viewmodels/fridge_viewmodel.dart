import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_app/services/firestore_ingredients.dart';

import '../constants/constants.dart';
import '../static/helper_functions.dart';
import '../widgets/grid_image.dart';

class FridgeViewModel extends GetxController {
  late CollectionReference<Object?> _ingredients;

  CollectionReference<Object?> get ingredients => _ingredients;

  bool _loading = false;

  bool get loading => _loading;

  @override
  void onInit() {
    super.onInit();
    _getIngredientsFromFirestore();
  }

  _getIngredientsFromFirestore() async {
    _loading = true;
    _ingredients = await FirestoreIngredients().getIngredientsFromFirestore();

    _loading = false;
    update();
  }

  deleteIngredientFromFirestore(id, context) async {
    try {
      await FirestoreIngredients.database.deleteIngredientFromFirestore(id);
    } on FirebaseException catch (e) {
      showErrorMessage(e.message.toString(), context);
    }
    showSucessMessage("You have sucessfully deleted the ingredient.", context);
  }

  updateIngredientFromFirestore(
      nameController, selectedImageIndex, context, documentSnapshot) async {
    try {
      if (documentSnapshot != null) {
        nameController.text = documentSnapshot['name'];
      }

      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return StatefulBuilder(
                builder: (BuildContext ctx, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'name'.tr),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Choose an image:"),
                    GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 10,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        children: [
                          for (int i = 1; i < randomImages.length; i++)
                            GestureDetector(
                                onTap: () => {
                                      setState(
                                        () {
                                          selectedImageIndex = i;
                                        },
                                      )
                                    },
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            style: selectedImageIndex == i
                                                ? BorderStyle.solid
                                                : BorderStyle.none,
                                            width: 3,
                                            color: selectedImageIndex == i
                                                ? Colors.white
                                                : Colors.transparent)),
                                    child: GridViewImage(
                                        imageUrl: randomImages[i])))
                        ]),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Text('update'.tr),
                      onPressed: () async {
                        final String name = nameController.text;
                        await FirestoreIngredients.database
                            .updateIngredientFromFirestore(documentSnapshot, {
                          "name": name,
                          "image_url": randomImages[selectedImageIndex]
                        });
                        nameController.text = '';
                      },
                    ),
                  ],
                ),
              );
            });
          });
    } catch (e) {
      showErrorMessage("Temporary error, please try again later!", context);
    }
  }

  createIngredientFromFirestore(
      nameController, selectedImageIndex, context) async {
    try {
      nameController.text = '';

      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return StatefulBuilder(
              builder: (BuildContext ctx, StateSetter setState) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'name'.tr),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Choose an image:"),
                      GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 10,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16),
                          children: [
                            for (int i = 1; i < randomImages.length; i++)
                              GestureDetector(
                                  onTap: () => {
                                        setState(
                                          () {
                                            selectedImageIndex = i;
                                          },
                                        )
                                      },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              style: selectedImageIndex == i
                                                  ? BorderStyle.solid
                                                  : BorderStyle.none,
                                              width: 3,
                                              color: selectedImageIndex == i
                                                  ? Colors.white
                                                  : Colors.transparent)),
                                      child: GridViewImage(
                                          imageUrl: randomImages[i])))
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: Text('add'.tr),
                        onPressed: () async {
                          final String name = nameController.text;
                          await FirestoreIngredients.database
                              .createIngredientFromFirestore({
                            "name": name,
                            "user_uid": FirebaseAuth.instance.currentUser!.uid,
                            "image_url": randomImages[selectedImageIndex]
                          });
                          nameController.text = '';
                        },
                      )
                    ],
                  ),
                );
              },
            );
          });
    } on FirebaseException catch (e) {
      showErrorMessage(e.message.toString(), context);
    }
    showSucessMessage("You have sucessfully added an ingredient.", context);
  }
}
