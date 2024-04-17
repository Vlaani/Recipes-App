import 'package:recipes_app/models/recipe.dart';

class User {
  String? profilePhotoPath;
  String userName;
  String login;
  String email;
  RecipeData? likedRecipes;
  User(this.profilePhotoPath, this.userName, this.login, this.email,
      this.likedRecipes);
  User.fromJson(Map<String, dynamic> json)
      : profilePhotoPath = json['profilePhotoPath'] as String?,
        userName = json['userName'] as String,
        login = json['login'] as String,
        email = json['email'] as String,
        likedRecipes = json['likedRecipes'] as RecipeData?;
}
