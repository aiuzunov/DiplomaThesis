import 'dart:convert';

import '../auth/keys.dart';
import 'package:http/http.dart' as http;

class SpoonacularRecipes {
  static final SpoonacularRecipes spoonacularApi = SpoonacularRecipes();
  Future<Secret> futureSecret =
      SecretLoader(secretPath: '../lib/auth/secrets.json').load();
  final url = 'https://api.spoonacular.com/recipes/';

  Future<http.Response> makeRecipeInfoRequest(int id) async {
    Secret awaitedSecret = await futureSecret;

    var url =
        '${this.url}/$id/information?apiKey=${awaitedSecret.apiKey}&includeNutrition';

    var response = await http.get(Uri.parse(url));

    return response;
  }

  Future<http.Response> makeRecommendedRequest(searchString) async {
    Secret awaitedSecret = await futureSecret;

    var url =
        '${this.url}findByIngredients?ingredients=$searchString&apiKey=${awaitedSecret.apiKey}&number=1';

    var response = await http.get(Uri.parse(url));

    return response;
  }

  Future<http.Response> makeSearchRequest(
      searchString,
      cuisineFilterVal,
      maxTimeReadyFilter,
      minProteinsFilter,
      maxProteinsFilter,
      minCaloriesFilter,
      maxCaloriesFilter) async {
    Secret awaitedSecret = await futureSecret;

    var url =
        '${this.url}complexSearch?query=$searchString&apiKey=${awaitedSecret.apiKey}&number=1';

    if (cuisineFilterVal != '') {
      url += '&cuisine=$cuisineFilterVal';
    }

    if (maxTimeReadyFilter.value.text.trim().toString() != '') {
      url += '&maxReadyTime=${maxTimeReadyFilter.value.text.trim().toString()}';
    }

    if (minProteinsFilter.value.text.trim().toString() != '') {
      url += '&minProtein=${minProteinsFilter.value.text.trim().toString()}';
    }

    if (maxProteinsFilter.value.text.trim().toString() != '') {
      url += '&maxProtein=${maxProteinsFilter.value.text.trim().toString()}';
    }

    if (minCaloriesFilter.value.text.trim().toString() != '') {
      url += '&minCalories=${minCaloriesFilter.value.text.trim().toString()}';
    }

    if (maxCaloriesFilter.value.text.trim().toString() != '') {
      url += '&maxCalories=${maxCaloriesFilter.value.text.trim().toString()}';
    }

    var response = await http.get(Uri.parse(url));

    return response;
  }
}
