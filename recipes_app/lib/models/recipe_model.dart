class RecipeModel {
  String image, url, source, name;
  int totalTime, servings, id;
  double pricePerServing, healthScore;
  List<dynamic> ingredients, analyzedInstructions;
  RecipeModel(
      {required this.id,
      required this.ingredients,
      required this.servings,
      required this.totalTime,
      required this.image,
      required this.url,
      required this.source,
      required this.name,
      required this.analyzedInstructions,
      required this.pricePerServing,
      required this.healthScore});
}
