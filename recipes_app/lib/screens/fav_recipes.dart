import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/screens/recipe.dart';
import 'package:recipes_app/viewmodels/favrecipes_viewmodel.dart';
import 'package:recipes_app/widgets/app_bar.dart';
import 'package:translator/translator.dart';
import '../models/recipe_model.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/header.dart';
import 'package:get/get.dart';

class FavouriteRecipes extends StatefulWidget {
  const FavouriteRecipes({super.key});

  @override
  State<FavouriteRecipes> createState() => _FavouriteRecipesPageState();
}

class _FavouriteRecipesPageState extends State<FavouriteRecipes> {
  final translator = GoogleTranslator();

  String searchVal = "";
  final TextEditingController _nameController = TextEditingController();

  void upateSearchValState() {
    setState(() {
      searchVal = _nameController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(FavRecipesViewModel());
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: customAppBar(context),
        body: GetBuilder<FavRecipesViewModel>(
          init: Get.find<FavRecipesViewModel>(),
          builder: (controller) => controller.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Header(text: "fav_recipes".tr)),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: TextField(
                        controller: _nameController,
                        onChanged: (val) {
                          setState(() {
                            searchVal = val;
                          });
                        },
                        onSubmitted: (val) {
                          setState(() {
                            searchVal = val;
                          });
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: upateSearchValState,
                              icon: const Icon(Icons.search),
                            ),
                            hintText: "find_recipe".tr,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade600)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade600))),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                        child: StreamBuilder(
                            stream: (searchVal != "")
                                ? controller.favRecipes
                                    .where('user_uid',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .where('name',
                                        isGreaterThanOrEqualTo: searchVal,
                                        isLessThan: searchVal.substring(
                                                0, searchVal.length - 1) +
                                            String.fromCharCode(searchVal.codeUnitAt(
                                                    searchVal.length - 1) +
                                                1))
                                    .snapshots()
                                : controller.favRecipes
                                    .where('user_uid',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                              if (streamSnapshot.hasData) {
                                return GridView.builder(
                                    controller: ScrollController(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisExtent: 450),
                                    shrinkWrap: true,
                                    itemCount: streamSnapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final DocumentSnapshot documentSnapshot =
                                          streamSnapshot.data!.docs[index];
                                      return Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              RecipeModel recipeModel = RecipeModel(
                                                  userUid: FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  id: documentSnapshot['id'],
                                                  ingredients: documentSnapshot[
                                                      'ingredients'],
                                                  servings: documentSnapshot[
                                                      'servings'],
                                                  totalTime: documentSnapshot[
                                                      'totalTime'],
                                                  image:
                                                      documentSnapshot['image'],
                                                  url: documentSnapshot['url'],
                                                  source: documentSnapshot[
                                                      'source'],
                                                  name:
                                                      documentSnapshot['name'],
                                                  analyzedInstructions:
                                                      documentSnapshot[
                                                          'analyzedInstructions'],
                                                  pricePerServing:
                                                      documentSnapshot[
                                                          'pricePerServing'],
                                                  healthScore: documentSnapshot[
                                                      'healthScore']);
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return RecipePage(
                                                    favorite: true,
                                                    recipeModel: recipeModel);
                                              }));
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                width: 320,
                                                height: 425,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[850],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Image.network(
                                                            documentSnapshot[
                                                                    'image']
                                                                .toString())),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 2.0,
                                                                horizontal: 8),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  documentSnapshot[
                                                                      'name'],
                                                                  maxLines: 2,
                                                                  style: const TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          20)),
                                                              // Text('Description test',
                                                              //     style: TextStyle(
                                                              //         color: Colors.grey[700]))
                                                            ])),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Divider(
                                                        color: Colors.white),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Icon(
                                                                CupertinoIcons
                                                                    .money_dollar),
                                                            const SizedBox(
                                                              width: 1,
                                                            ),
                                                            Text(((documentSnapshot[
                                                                            'pricePerServing'] *
                                                                        documentSnapshot[
                                                                            'servings']) /
                                                                    100)
                                                                .toStringAsFixed(
                                                                    2)),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            const Icon(
                                                                CupertinoIcons
                                                                    .heart),
                                                            const SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                                "${documentSnapshot['healthScore']}%"),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            const Icon(Icons
                                                                .timer_outlined),
                                                            const SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                                "${documentSnapshot['totalTime'].toString()}'"),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                                width: 2,
                                                                height: 30,
                                                                color: Colors
                                                                    .white),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                                "${documentSnapshot['servings']} ${'servings'.tr}"),
                                                          ],
                                                        )),
                                                    const SizedBox(height: 5),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                controller
                                                                    .deleteFavRecipeFromFirestore(
                                                                        documentSnapshot
                                                                            .id,
                                                                        context);
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .delete_forever,
                                                              ),
                                                              iconSize: 35,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        )),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      );
                                    });
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }))
                  ],
                ),
        ));
  }
}
