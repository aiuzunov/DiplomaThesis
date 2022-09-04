import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/screens/recipe.dart';
import 'package:recipes_app/widgets/app_bar.dart';
import 'package:translator/translator.dart';
import '../models/recipe_model.dart';
import '../widgets/header.dart';
import 'package:get/get.dart';

class FavouriteRecipes extends StatefulWidget {
  const FavouriteRecipes({super.key});

  @override
  State<FavouriteRecipes> createState() => _FavouriteRecipesPageState();
}

class _FavouriteRecipesPageState extends State<FavouriteRecipes> {
  final user = FirebaseAuth.instance.currentUser!;
  final translator = GoogleTranslator();

  final CollectionReference _recipes =
      FirebaseFirestore.instance.collection('fav_recipes');

  List<RecipeModel> recipesList = <RecipeModel>[];

  String searchVal = "";
  final TextEditingController _nameController = TextEditingController();

  void upateSearchValState() {
    setState(() {
      searchVal = _nameController.text.trim();
    });
  }

  void removeFavoriteRecipe(String id) async {
    await _recipes.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: customAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
              margin: const EdgeInsets.only(left: 20),
              child: Header(text: "recipes".tr)),
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
                      borderSide: BorderSide(color: Colors.grey.shade600)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600))),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: StreamBuilder(
                  stream: (searchVal != "")
                      ? _recipes
                          .where('name',
                              isGreaterThanOrEqualTo: searchVal,
                              isLessThan: searchVal.substring(
                                      0, searchVal.length - 1) +
                                  String.fromCharCode(searchVal
                                          .codeUnitAt(searchVal.length - 1) +
                                      1))
                          .snapshots()
                      : _recipes.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return GridView.builder(
                          controller: ScrollController(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, mainAxisExtent: 550),
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
                                        ingredients:
                                            documentSnapshot['ingredients'],
                                        servings: documentSnapshot['servings'],
                                        totalTime:
                                            documentSnapshot['totalTime'],
                                        image: documentSnapshot['image'],
                                        url: documentSnapshot['url'],
                                        source: documentSnapshot['source'],
                                        name: documentSnapshot['name'],
                                        totalWeight:
                                            documentSnapshot['totalWeight'],
                                        calories: documentSnapshot['calories']);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return RecipePage(
                                          favorite: true,
                                          recipeModel: recipeModel);
                                    }));
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(12),
                                      width: 300,
                                      height: 500,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[850],
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Hero(
                                                tag: documentSnapshot['url'],
                                                child: Image.network(
                                                    documentSnapshot['image']
                                                        .toString()),
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 8),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        documentSnapshot[
                                                            'name'],
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontSize: 20)),
                                                    // Text('Description test',
                                                    //     style: TextStyle(
                                                    //         color: Colors.grey[700]))
                                                  ])),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Divider(color: Colors.white),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                      Icons.scale_outlined),
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                      "${documentSnapshot['totalWeight'].toInt().toString()} g"),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Icon(Icons.run_circle),
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                      "${documentSnapshot['calories'].toInt().toString()} cal"),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Icon(
                                                      Icons.timer_outlined),
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                      "${documentSnapshot['totalTime'].toString()}'"),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                ],
                                              )),
                                          const SizedBox(height: 5),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${documentSnapshot['servings']} ${'servings'.tr}"),
                                                ],
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      removeFavoriteRecipe(
                                                          documentSnapshot.id);
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete_forever,
                                                    ),
                                                    iconSize: 25,
                                                    color: Colors.white,
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
    );
  }
}
