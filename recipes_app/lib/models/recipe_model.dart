class RecipeModel {
  String image, url, source, name, nameBg, userUid;
  int totalTime, servings, id;
  double pricePerServing, healthScore;
  List<dynamic> ingredients,
      ingredientsBg,
      analyzedInstructions,
      analyzedInstructionsBg;
  RecipeModel(
      {required this.userUid,
      required this.id,
      required this.ingredients,
      required this.ingredientsBg,
      required this.servings,
      required this.totalTime,
      required this.image,
      required this.url,
      required this.source,
      required this.name,
      required this.nameBg,
      required this.analyzedInstructions,
      required this.analyzedInstructionsBg,
      required this.pricePerServing,
      required this.healthScore});
}
