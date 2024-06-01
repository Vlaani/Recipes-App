import 'package:flutter/material.dart';
import 'package:recipes_app/view_model/data.dart';
import 'package:recipes_app/models/review.dart';

class RecipeData {
  String recipeName;
  //String previewPath;
  final Kitchen? kitchen;
  int readyTime;
  int timeInKitchen;
  int spiciness;
  int difficulty;
  String description;
  List<Pair<int, double>> ingredients = [];

  List<Review> reviews = [];
  List<RecipeStep> steps = [];
  List<String> photoPaths = [];

  RecipeData(
      this.recipeName,
      this.photoPaths,
      this.description,
      this.readyTime,
      this.timeInKitchen,
      this.difficulty,
      this.spiciness,
      this.ingredients,
      this.steps,
      {this.kitchen});
  RecipeData.clone(RecipeData obj)
      : this(
            obj.recipeName,
            obj.photoPaths,
            obj.description,
            obj.readyTime,
            obj.timeInKitchen,
            obj.difficulty,
            obj.spiciness,
            obj.ingredients,
            obj.steps,
            kitchen: obj.kitchen);
  RecipeData.fromJson(Map<String, dynamic> json)
      : recipeName = json['recipeName'] as String,
        photoPaths = json['photoPaths'] as List<String>,
        description = json['description'] as String,
        readyTime = json['readyTime'] as int,
        timeInKitchen = json['timeInKitchen'] as int,
        difficulty = json['difficulty'] as int,
        spiciness = json['spiciness'] as int,
        ingredients = json['ingredients'] as List<Pair<int, double>>,
        steps = json['steps'] as List<RecipeStep>,
        kitchen = json['kitchen'] as Kitchen?;
  Map<String, dynamic> toJson() {
    return {
      "recipeName": recipeName,
      "photoPaths": photoPaths,
      "description": description,
      "readyTime": readyTime,
      "timeInKitchen": timeInKitchen,
      "difficulty": difficulty,
      "spiciness": spiciness,
      "ingredients": ingredients,
      "steps": steps,
      "kitchen": kitchen
    };
  }

  double getWeight() {
    return ingredients
        .map((e) => e.value)
        .fold(0, (previousValue, element) => previousValue + element);
  }

  double getRating() {
    return reviews
        .map((e) => e.rating)
        .fold(0, (previousValue, element) => previousValue + element);
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
  String kitchenFlag;
  Kitchen(this.kitchenName, this.kitchenFlag);
  Kitchen.fromJson(Map<String, dynamic> json)
      : kitchenName = json['kitchenName'] as String,
        kitchenFlag = json['kitchenFlag'] as String;
  Map<String, dynamic> toJson() {
    return {"kitchenName": kitchenName, "kitchenFlag": kitchenFlag};
  }
}

class RecipeStep {
  //late Image image;
  String description;
  String iconPath;
  RecipeStep(this.description, this.iconPath);
  RecipeStep.fromJson(Map<String, dynamic> json)
      : description = json['description'] as String,
        iconPath = json['iconPath'] as String;
  Map<String, dynamic> toJson() {
    return {"description": description, "iconPath": iconPath};
  }
}
