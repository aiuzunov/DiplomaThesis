class IngredientModel {
  late String name, imageUrl, userUid;

  IngredientModel({
    required this.name,
    required this.imageUrl,
    required this.userUid,
  });

  IngredientModel.fromJson(Map<dynamic, dynamic> map) {
    name = map['name'];
    imageUrl = map['image_url'];
    userUid = map['user_uid'];
  }

  toJson() {
    return {'name': name, 'image_url': imageUrl, 'user_uid': userUid};
  }
}
