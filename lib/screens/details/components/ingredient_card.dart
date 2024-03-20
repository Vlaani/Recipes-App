import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingredient.dart';

class IngredientCard extends StatelessWidget {
  IngredientCard(this.data, this.multiplier, {Key? key}) : super(key: key);
  Ingredient data;
  double multiplier;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2, bottom: 2),
      height: 50,
      padding: EdgeInsets.only(left: 8, right: 10),
      decoration: BoxDecoration(
        color: Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    "resources/test_image_2.png",
                    fit: BoxFit.fill,
                  ),
                )),
            SizedBox(
              width: 10,
            ),
            Text(
              data.ingredientName,
              style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
            ),
          ],
        ),
        Text((data.weight * multiplier).toString() + " г",
            style: const TextStyle(fontSize: 16, color: Color(0xFF666666)))
      ]),
    );
  }
}
