import 'package:flutter/material.dart';

class Ingredient {
  String ingredientName;
  String id;
  double calories, proteins, fats, carbohydrates, weight;
  late Image image;
  Ingredient(this.ingredientName, this.id, this.weight, this.calories,
      this.proteins, this.fats, this.carbohydrates);
}
