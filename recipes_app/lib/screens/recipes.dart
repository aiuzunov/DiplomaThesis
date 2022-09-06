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
import 'package:recipes_app/viewmodels/recipes_viewmodel.dart';
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
  String cuisineFilterVal = "";
  final TextEditingController _maxTimeReadyFilter = TextEditingController();
  final TextEditingController _minCaloriesFilter = TextEditingController();
  final TextEditingController _maxCaloriesFilter = TextEditingController();
  final TextEditingController _minProteinsFilter = TextEditingController();
  final TextEditingController _maxProteinsFilter = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    Get.put(RecipesViewmodel());
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: customAppBar(context),
        body: GetBuilder<RecipesViewmodel>(
          init: Get.find<RecipesViewmodel>(),
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
                          controller.getRecipes(
                              _nameController,
                              cuisineFilterVal,
                              _maxProteinsFilter,
                              _minProteinsFilter,
                              _maxCaloriesFilter,
                              _minCaloriesFilter,
                              _maxTimeReadyFilter,
                              context);
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.getRecipes(
                                    _nameController,
                                    cuisineFilterVal,
                                    _maxProteinsFilter,
                                    _minProteinsFilter,
                                    _maxCaloriesFilter,
                                    _minCaloriesFilter,
                                    _maxTimeReadyFilter,
                                    context);
                              },
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
                          onTap: () {
                            controller.getRecommendedRecipes(context);
                          },
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
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, mainAxisExtent: 350),
                            shrinkWrap: true,
                            itemCount: controller.recipes.length,
                            itemBuilder: (context, index) {
                              final RecipeCardModel documentSnapshot =
                                  controller.recipes[index];
                              return Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () async {
                                      RecipeModel model = await controller
                                          .getRecipeInfo(documentSnapshot.id);
                                      if (!mounted) return;
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return RecipePage(
                                            favorite: false,
                                            recipeModel: model);
                                      }));
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(12),
                                        width: 300,
                                        height: 300,
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
                                                child: Image.network(
                                                    documentSnapshot.image
                                                        .toString())),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2.0,
                                                        horizontal: 8),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          documentSnapshot.name,
                                                          maxLines: 2,
                                                          style: const TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontSize: 20)),
                                                    ])),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              );
                            }))
                  ],
                ),
        ));
  }
}
