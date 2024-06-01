import 'package:flutter/material.dart';
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/view_model/data.dart';

class IngredientCard extends StatefulWidget {
  const IngredientCard(this.data, this.multiplier, {Key? key})
      : super(key: key);
  final Ingredient data;
  final double multiplier;
  @override
  _IngredientCardState createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
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
                    child: Image.network(
                      "http://" + serverUrl + "/images/" + widget.data.iconPath,
                      fit: BoxFit.fill,
                    ))),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.data.ingredientName.substring(
                      0,
                      widget.data.ingredientName.length > 24
                          ? 24
                          : widget.data.ingredientName.length) +
                  (widget.data.ingredientName.length > 24 ? "..." : ""),
              overflow: TextOverflow.visible,
              style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
            ),
          ],
        ),
        Flexible(
            child: Text(
                (widget.data.weight * widget.multiplier).toString() + " г",
                softWrap: false,
                overflow: TextOverflow.visible,
                style: const TextStyle(fontSize: 16, color: Color(0xFF666666))))
      ]),
    );
  }
}
