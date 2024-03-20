import 'package:flutter/material.dart';
import 'ingredient.dart';
import 'package:recipes_app/models/review.dart';

class RecipeData {
  String recipeName;
  String id;
  String previewPath;
  final Kitchen? kitchen;
  List<Ingredient> ingredients;
  int readyTime;
  int timeInKitchen;
  int spiciness;
  int difficulty;

  List<Review> reviews = List.empty();

  late String description;
  late List<RecipeStep> steps;
  RecipeData(this.recipeName, this.id, this.previewPath, this.readyTime,
      this.timeInKitchen, this.difficulty, this.spiciness, this.ingredients,
      {this.kitchen});
  double getWeight() {
    return ingredients
        .map((e) => e.weight)
        .fold(0, (previousValue, element) => previousValue + element);
  }

  double getRating() {
    return reviews
        .map((e) => e.rating)
        .fold(0, (previousValue, element) => previousValue + element);
  }

  void loadDetails() {
    description =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    steps = [
      RecipeStep(
          Image.asset("resources/test_image.png"), "Do something. bla bla bla")
    ];
  }

  String getName({int? maxChars}) {
    if (maxChars != null && recipeName.characters.length > maxChars) {
      return recipeName.substring(0, maxChars) + "...";
    }
    return recipeName;
  }
}

class Kitchen {
  String kitchenName;
  Image kitchenFlag;
  Kitchen(this.kitchenName, this.kitchenFlag);
}

class RecipeStep {
  Image image;
  String description;
  RecipeStep(this.image, this.description);
}
