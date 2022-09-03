import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipes_app/auth/keys.dart';
import 'package:recipes_app/screens/recipe.dart';
import 'package:recipes_app/widgets/app_bar.dart';
import 'package:translator/translator.dart';
import '../models/recipe_model.dart';
import '../widgets/header.dart';
import 'package:get/get.dart';

class Recipes extends StatefulWidget {
  const Recipes({super.key});

  @override
  State<Recipes> createState() => _FridgePageState();
}

class _FridgePageState extends State<Recipes> {
  final user = FirebaseAuth.instance.currentUser!;
  final translator = GoogleTranslator();

  final CollectionReference _ingredients =
      FirebaseFirestore.instance.collection('ingredients');

  final url = 'https://api.edamam.com/api/recipes/v2';
  List<RecipeModel> recipesList = <RecipeModel>[];

  String searchVal = "";
  final TextEditingController _nameController = TextEditingController();

  void upateSearchValState() {
    setState(() {
      searchVal = _nameController.text.trim();
    });
  }

  Future<http.Response> makeRequest(searchString) async {
    Future<Secret> futureSecret =
        SecretLoader(secretPath: '../lib/auth/secrets.json').load();

    Secret awaitedSecret = await futureSecret;

    var url =
        '${this.url}?type=any&q=$searchString&app_id=${awaitedSecret.appId}&app_key=${awaitedSecret.apiKey}';

    var response = await http.get(Uri.parse(url));

    return response;
  }

  void getRecommendedRecipes() async {
    List<String> userIngredientsList = <String>[];

    var userIngredientsCollection = FirebaseFirestore.instance
        .collection('ingredients')
        .where('user_uid', isEqualTo: user.uid);

    userIngredientsCollection.snapshots().forEach((snapshot) async {
      for (var element in snapshot.docs) {
        {
          userIngredientsList.add(element['name']);
        }

        var response = await makeRequest(userIngredientsList.join(", "));
        Map json = jsonDecode(response.body);
        setState(() {
          recipesList = [];
        });

        json['hits'].forEach((hit) async {
          var translation;
          if (Get.locale.toString() == 'bg_BG') {
            translation = await translator.translate(hit['recipe']['label'],
                from: 'en', to: 'bg');
          }

          RecipeModel recipeCard = RecipeModel(
            ingredients: hit['recipe']['ingredients'],
            servings: hit['recipe']['yield'],
            calories: hit['recipe']['calories'],
            totalWeight: hit['recipe']['totalWeight'],
            totalTime: hit['recipe']['totalTime'],
            url: hit['recipe']['url'],
            image: hit['recipe']['image'],
            source: hit['recipe']['source'],
            name:
                translation != null ? translation.text : hit['recipe']['label'],
          );

          setState(() {
            recipesList.add(recipeCard);
          });
        });
      }
    });
  }

  void getRecipes() async {
    upateSearchValState();

    var response = await makeRequest(searchVal);

    Map json = jsonDecode(response.body);
    setState(() {
      recipesList = [];
    });

    json['hits'].forEach((hit) async {
      var translation;
      if (Get.locale.toString() == 'bg_BG') {
        translation = await translator.translate(hit['recipe']['label'],
            from: 'en', to: 'bg');
      }
      RecipeModel recipeCard = RecipeModel(
        ingredients: hit['recipe']['ingredients'],
        servings: hit['recipe']['yield'],
        calories: hit['recipe']['calories'],
        totalWeight: hit['recipe']['totalWeight'],
        totalTime: hit['recipe']['totalTime'],
        url: hit['recipe']['url'],
        image: hit['recipe']['image'],
        source: hit['recipe']['source'],
        name: translation.text,
      );

      setState(() {
        recipesList.add(recipeCard);
      });
    });
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
              onSubmitted: (val) {
                setState(() {
                  searchVal = val;
                });
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: getRecipes,
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
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('or'.tr,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200),
              child: GestureDetector(
                onTap: getRecommendedRecipes,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Center(
                        child: Text('get_recommendations'.tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)))),
              )),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: GridView.builder(
                  controller: ScrollController(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisExtent: 450),
                  shrinkWrap: true,
                  itemCount: recipesList.length,
                  itemBuilder: (context, index) {
                    final RecipeModel documentSnapshot = recipesList[index];
                    return Column(children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return RecipePage(recipeModel: documentSnapshot);
                          }));
                        },
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Hero(
                                      tag: documentSnapshot.url,
                                      child: Image.network(
                                          documentSnapshot.image.toString()),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 8),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(documentSnapshot.name,
                                              style: const TextStyle(
                                                  fontSize: 20)),
                                          // Text('Description test',
                                          //     style: TextStyle(
                                          //         color: Colors.grey[700]))
                                        ])),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            iconSize: 20,
                                            onPressed: () => {},
                                            icon: const Icon(
                                                Icons.remove_red_eye_sharp)),
                                      ],
                                    )),
                                const SizedBox(
                                  height: 1,
                                ),
                              ],
                            )),
                      )
                    ]);
                  }))
        ],
      ),
    );
  }
}
