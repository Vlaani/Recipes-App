import 'package:flutter/material.dart';

class RecipeTab extends StatelessWidget {
  String text;
  bool isSelected;
  RecipeTab(this.text, this.isSelected);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        height: 36,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isSelected ? Colors.amber : Color(0xFFD9D9D9),
            shape: BoxShape.rectangle),
        child: Text(text.isEmpty ? "Новый рецепт" : text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                overflow: TextOverflow.visible,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1,
                color: Color(0xFF666666))),
      ),
    );
  }
}
