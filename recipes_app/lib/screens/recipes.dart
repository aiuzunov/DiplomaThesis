import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipes_app/auth/keys.dart';
import 'package:recipes_app/models/recipe_card_model.dart';
import 'package:recipes_app/screens/recipe.dart';
import 'package:recipes_app/static/helper_functions.dart';
import 'package:recipes_app/widgets/app_bar.dart';
import 'package:translator/translator.dart';
import '../input_formatters/input_formatters.dart';
import '../models/recipe_model.dart';
import '../widgets/header.dart';
import 'package:get/get.dart';
import 'package:recipes_app/constants/constants.dart';

class Recipes extends StatefulWidget {
  const Recipes({super.key});

  @override
  State<Recipes> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<Recipes> {
  final user = FirebaseAuth.instance.currentUser!;
  final translator = GoogleTranslator();

  Future<Secret> futureSecret =
      SecretLoader(secretPath: '../lib/auth/secrets.json').load();

  final url = 'https://api.spoonacular.com/recipes/';
  List<RecipeCardModel> recipesList = <RecipeCardModel>[];

  String searchVal = "";
  String cuisineFilterVal = "";
  final TextEditingController _maxTimeReadyFilter = TextEditingController();
  final TextEditingController _minCaloriesFilter = TextEditingController();
  final TextEditingController _maxCaloriesFilter = TextEditingController();
  final TextEditingController _minProteinsFilter = TextEditingController();
  final TextEditingController _maxProteinsFilter = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void upateSearchValState() {
    setState(() {
      searchVal = _nameController.text.trim();
    });
  }

  Future<http.Response> makeRecipeInfoRequest(int id) async {
    try {
      Secret awaitedSecret = await futureSecret;

      var url =
          '${this.url}/$id/information?apiKey=${awaitedSecret.apiKey}&includeNutrition';

      var response = await http.get(Uri.parse(url));

      return response;
    } catch (e) {
      showErrorMessage("Temporary error, please try again later!", context);
    }

    throw ('Application error');
  }

  Future<http.Response> makeRecommendedRequest(searchString) async {
    try {
      Secret awaitedSecret = await futureSecret;

      var url =
          '${this.url}findByIngredients?ingredients=$searchString&apiKey=${awaitedSecret.apiKey}&number=1';

      var response = await http.get(Uri.parse(url));

      return response;
    } catch (e) {
      showErrorMessage("Temporary error, please try again later!", context);
    }

    throw ('Application error');
  }

  Future<http.Response> makeSearchRequest(searchString) async {
    try {
      Secret awaitedSecret = await futureSecret;

      var url =
          '${this.url}complexSearch?query=$searchString&apiKey=${awaitedSecret.apiKey}&number=1';

      if (cuisineFilterVal != '') {
        url += '&cuisine=$cuisineFilterVal';
      }

      if (_maxTimeReadyFilter.value.text.trim().toString() != '') {
        url +=
            '&maxReadyTime=${_maxTimeReadyFilter.value.text.trim().toString()}';
      }

      if (_minProteinsFilter.value.text.trim().toString() != '') {
        url += '&minProtein=${_minProteinsFilter.value.text.trim().toString()}';
      }

      if (_maxProteinsFilter.value.text.trim().toString() != '') {
        url += '&maxProtein=${_maxProteinsFilter.value.text.trim().toString()}';
      }

      if (_minCaloriesFilter.value.text.trim().toString() != '') {
        url +=
            '&minCalories=${_minCaloriesFilter.value.text.trim().toString()}';
      }

      if (_maxCaloriesFilter.value.text.trim().toString() != '') {
        url +=
            '&maxCalories=${_maxCaloriesFilter.value.text.trim().toString()}';
      }

      var response = await http.get(Uri.parse(url));

      return response;
    } catch (e) {
      showErrorMessage("Temporary error, please try again later!", context);
    }
    throw ('Application error');
  }

  Future<RecipeModel> getRecipeInfo(id) async {
    try {
      var response = await makeRecipeInfoRequest(id);

      Map json = jsonDecode(response.body);

      if (json['sourceName'] == null) {
        json['sourceName'] = '';
      }

      return RecipeModel(
          id: json['id'],
          name: json['title'],
          image: json['image'],
          servings: json['servings'],
          totalTime: json['readyInMinutes'],
          source: json['sourceName'],
          ingredients: json['extendedIngredients'],
          analyzedInstructions: json['analyzedInstructions'][0]['steps'],
          url: json['sourceUrl'],
          pricePerServing: json['pricePerServing'],
          healthScore: json['healthScore']);
    } catch (e) {
      showErrorMessage("Temporary error, please try again later!", context);
    }

    throw ('Application error');
  }

  void showFiltersModal() async {
    try {
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text('Cuisine: '),
                        const SizedBox(
                          width: 20,
                        ),
                        DropdownButton<String>(
                          value: cuisineFilterVal,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.white),
                          iconSize: 15,
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              cuisineFilterVal = value!;
                            });
                          },
                          items: cuisinesList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${"maximum_2".tr} ${"time_to_prepare".tr}: '),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: TextField(
                            controller: _maxTimeReadyFilter,
                            decoration: InputDecoration(
                                labelText:
                                    "${"maximum_2".tr} ${"time_to_prepare".tr}"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              CustomRangeTextInputFormatter()
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 300,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${"minimum".tr} ${"calories".tr}: "),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: TextField(
                            controller: _minCaloriesFilter,
                            decoration: InputDecoration(
                                labelText: "${"minimum".tr} ${"calories".tr}"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              ProteinsRangeTextInputFormatter()
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text('${"maximum".tr} ${"calories".tr}: '),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: TextField(
                            controller: _maxCaloriesFilter,
                            decoration: InputDecoration(
                                labelText: "${"maximum".tr} ${"calories".tr}"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              ProteinsRangeTextInputFormatter()
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 200,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${"minimum".tr} ${"proteins".tr}: '),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: TextField(
                            controller: _minProteinsFilter,
                            decoration: InputDecoration(
                                labelText: "${"minimum".tr} ${"proteins".tr}"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              ProteinsRangeTextInputFormatter()
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text('${"maximum".tr} ${"proteins".tr}: '),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: TextField(
                            controller: _maxProteinsFilter,
                            decoration: InputDecoration(
                                labelText: "${"maximum".tr} ${"proteins".tr}"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              ProteinsRangeTextInputFormatter()
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 200,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
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

  void getRecommendedRecipes() async {
    try {
      List<String> userIngredientsList = <String>[];

      var userIngredientsCollection = FirebaseFirestore.instance
          .collection('ingredients')
          .where('user_uid', isEqualTo: user.uid);

      userIngredientsCollection.snapshots().forEach((snapshot) async {
        for (var element in snapshot.docs) {
          {
            userIngredientsList.add(element['name']);
          }

          var response =
              await makeRecommendedRequest(userIngredientsList.join(", "));
          List<dynamic> json = jsonDecode(response.body);
          setState(() {
            recipesList = [];
          });

          for (var element in json) {
            var translation;
            if (Get.locale.toString() == 'bg_BG') {
              translation = await translator.translate(element['title'],
                  from: 'en', to: 'bg');
            }

            RecipeCardModel recipeCard = RecipeCardModel(
              image: element['image'],
              id: element['id'],
              name: translation != null ? translation.text : element['title'],
            );

            setState(() {
              recipesList.add(recipeCard);
            });
          }
        }
      });
    } catch (e) {
      showErrorMessage("Temporary error, please try again later!", context);
    }
  }

  void getRecipes() async {
    try {
      upateSearchValState();

      var response = await makeSearchRequest(searchVal);

      List<dynamic> json = jsonDecode(response.body)['results'];

      setState(() {
        recipesList = [];
      });

      for (var element in json) {
        var translation;
        if (Get.locale.toString() == 'bg_BG') {
          translation = await translator.translate(element['title'],
              from: 'en', to: 'bg');
        }

        RecipeCardModel recipeCard = RecipeCardModel(
          image: element['image'],
          id: element['id'],
          name: translation != null ? translation.text : element['title'],
        );

        setState(() {
          recipesList.add(recipeCard);
        });
      }
    } catch (e) {
      showErrorMessage("Temporary error, please try again later!", context);
    }
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Header(text: "recipes".tr)),
              Container(
                  margin: const EdgeInsets.only(right: 50),
                  child: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        showFiltersModal();
                      })),
            ],
          ),
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
                      crossAxisCount: 2, mainAxisExtent: 350),
                  shrinkWrap: true,
                  itemCount: recipesList.length,
                  itemBuilder: (context, index) {
                    final RecipeCardModel documentSnapshot = recipesList[index];
                    return Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            RecipeModel model =
                                await getRecipeInfo(documentSnapshot.id);
                            if (!mounted) return;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RecipePage(
                                  favorite: false, recipeModel: model);
                            }));
                          },
                          child: Container(
                              padding: const EdgeInsets.all(12),
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                          documentSnapshot.image.toString())),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 8),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(documentSnapshot.name,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 20)),
                                          ])),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // const Divider(color: Colors.white),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  // Padding(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 10),
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.start,
                                  //       children: const [
                                  //         Icon(Icons.scale_outlined),
                                  //         SizedBox(
                                  //           width: 2,
                                  //         ),
                                  //         Text("100 g"),
                                  //         SizedBox(
                                  //           width: 10,
                                  //         ),
                                  //         Icon(Icons.run_circle),
                                  //         SizedBox(
                                  //           width: 2,
                                  //         ),
                                  //         Text("200 cal"),
                                  //         SizedBox(
                                  //           width: 10,
                                  //         ),
                                  //         Icon(Icons.timer_outlined),
                                  //         SizedBox(
                                  //           width: 2,
                                  //         ),
                                  //         Text("30'"),
                                  //         SizedBox(
                                  //           width: 15,
                                  //         ),
                                  //       ],
                                  //     )),
                                  // const SizedBox(height: 5),
                                  // Padding(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 10),
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         Text("3 ${'servings'.tr}"),
                                  //       ],
                                  //     )),
                                ],
                              )),
                        ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }
}
