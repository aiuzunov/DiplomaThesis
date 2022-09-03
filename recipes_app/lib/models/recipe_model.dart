class RecipeModel {
  String image, url, source, name;
  int totalTime, servings;
  double totalWeight, calories;
  List<dynamic> ingredients;
  RecipeModel(
      {required this.ingredients,
      required this.servings,
      required this.totalTime,
      required this.image,
      required this.url,
      required this.source,
      required this.name,
      required this.totalWeight,
      required this.calories});
}
