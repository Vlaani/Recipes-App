import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/extensions.dart';
import 'package:recipes_app/view_model/data.dart';

class User {
  String? profilePhotoPath;
  String userName;
  String? cookie;
  String login;
  String email;
  List<String>? likedRecipes = [];
  List<String>? publishedRecipes = [];
  List<RecipeData>? userRecipes = [];
  User(this.profilePhotoPath, this.userName, this.login, this.email);
  User.fromJson(Map<String, dynamic> json)
      : profilePhotoPath = json['profilePhotoPath'] as String?,
        userName = json['userName'] as String,
        cookie = json['cookie'] as String,
        login = json['login'] as String,
        email = json['email'] as String,
        likedRecipes = json['likedRecipes'] as List<String>?,
        userRecipes = json['userRecipes']?.map<RecipeData>((e) {
          return RecipeData(
              e["recipeName"],
              (e["photoPaths"] as List<dynamic>).correct<String>(),
              e["description"],
              e["readyTime"],
              e["timeInKitchen"],
              e["difficulty"],
              e["spiciness"],
              e["ingredients"]
                  .map<Pair<int, double>>((e) => Pair<int, double>.fromJson(e))
                  .toList(),
              (e["steps"] as List<dynamic>).correct<RecipeStep>());
        }).toList();
  Map<String, dynamic> toJson() {
    return {
      'profilePhotoPath': profilePhotoPath,
      "userName": userName,
      "cookie": cookie,
      "login": login,
      "email": email,
      "publishedRecipes": publishedRecipes,
      "likedRecipes": likedRecipes,
      "userRecipes": userRecipes
    };
  }
}
