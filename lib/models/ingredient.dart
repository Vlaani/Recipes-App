import 'package:flutter/material.dart';

class Ingredient {
  String ingredientName;
  String iconPath;
  double calories, proteins, fats, carbohydrates, weight;
  //late Image image;
  Ingredient(this.ingredientName, this.iconPath, this.weight, this.calories,
      this.proteins, this.fats, this.carbohydrates);

  Ingredient.fromJson(Map<String, dynamic> json)
      : ingredientName = json['ingredientName'] as String,
        iconPath = json['iconPath'] as String,
        calories = json['calories'] as double,
        proteins = json['proteins'] as double,
        fats = json['fats'] as double,
        carbohydrates = json['carbohydrates'] as double,
        weight = json['weight'] as double;
  Map<String, dynamic> toJson() {
    return {
      "ingredientName": ingredientName,
      "iconPath": iconPath,
      "calories": calories,
      "proteins": proteins,
      "fats": fats,
      "carbohydrates": carbohydrates,
      "weight": weight
    };
  }
}
