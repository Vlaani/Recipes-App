import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';

class StepCard extends StatelessWidget {
  StepCard(this.data, {Key? key}) : super(key: key);
  RecipeStep data;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 2, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 320,
              width: 320,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "resources/test_image_2.png",
                    fit: BoxFit.fitHeight,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Text(data.description,
                style: TextStyle(fontSize: 16, color: Color(0xFF666666)))
          ],
        ));
  }
}
